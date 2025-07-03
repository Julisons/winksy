import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:winksy/screen/authenticate/password/reset_password.dart';
import 'package:winksy/screen/authenticate/select/bio.dart';
import 'package:winksy/screen/authenticate/sign_up.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../component/button.dart';
import '../../component/google.dart';
import '../../component/loader.dart';
import '../../component/logo.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../model/user.dart';
import '../../request/posts.dart';
import '../../request/urls.dart';
import '../../theme/custom_colors.dart';
import '../home/home.dart';

class ISignIn extends StatefulWidget {
  const ISignIn({Key? key}) : super(key: key);

  @override
  State<ISignIn> createState() => _ISignInState();
}

class _ISignInState extends State<ISignIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes,);
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _pinConfirmController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  final User user = User();
  
  var name;
  var image;
  var email;
  var gender;
  var birthday;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _imageController.dispose();
    _nameController.dispose();
    _pinController.dispose();
    _pinConfirmController.dispose();
    _passwordController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: color.xPrimaryColor,
        title: Text('Sign in', style: TextStyle(color: color.xTrailing, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: color.xTrailing,),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Container(
        color: color.xPrimaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24, top: 16),
        child: Center(
          child: Column(
            children: [
               Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Welcome Back',
                    style: TextStyle(
                      fontSize: FONT_APP_BAR,
                      fontWeight: FontWeight.bold,
                      color: color.xTrailing,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 34),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
                decoration:  InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  border: InputBorder.none,
                  labelText: 'Email address',
                  labelStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  fillColor: color.xSecondaryColor,
                  filled: true,
                ),
              ),
              SizedBox(height: 24.h),
              TextFormField(
                controller: _pinController,
                keyboardType: TextInputType.text,
                obscureText: !isPasswordVisible,
                style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  border: InputBorder.none,
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(153, 153, 153, 1),
                    fontSize: 16,
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                fillColor: color.xSecondaryColor,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: color.xTrailing
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 34.h),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Mixin.navigate(context, IResetPassword());
                  },
                  child: RichText(
                    text:  TextSpan(
                      text: "Forgot",
                      style: TextStyle(color: color.xTrailing, fontSize: FONT_13, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  password ? ',
                            style: TextStyle(color: color.xTrailing,fontWeight: FontWeight.bold, fontSize: FONT_13)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 34.h),
              _isLoading ? Center(
                child: Loading(
                  dotColor: color.xTrailing))
                  :
              IButton(
                onPress: () {
                  if (_emailController.text.isEmpty) {
                    Mixin.showToast(context,  "Email cannot be empty", ERROR);
                    return;
                  }

                  if (_pinController.text.isEmpty) {
                    Mixin.showToast(context,  "Password cannot be empty", ERROR);
                    return;
                  }

                  User user = User()
                    ..usrUsername = _emailController.text.trim()
                    ..usrEncryptedPassword = _pinController.text.trim();

                  setState(() {
                    _isLoading = true;
                  });

                  IPost.postData(user, (state, res, value) {
                    setState(() {
                      if (state) {
                        Mixin.prefString(pref: jsonEncode(value), key: CURR);
                        Mixin.showToast(context, res, INFO);
                        Mixin.getUser().then((value) =>
                        {
                          Mixin.user = value,
                          Mixin.user = User()
                            ..usrId = Mixin.user?.usrId,

                            Mixin.pop(context, const IBio())
                        });
                      } else {
                        Mixin.errorDialog(context, 'ERROR', res);
                      }
                      _isLoading = false;
                    });
                  }, IUrls.SIGN_IN());
                },
                isBlack: false,
                text: "Sign in",
                color: color.xTrailing,
                textColor: Colors.white,
              ),
              SizedBox(height: 18.h,),
              IGoogle(onPress: (){
                _handleSignIn(context);
              }, text: 'Sign in with Google', width: MediaQuery.of(context).size.width,textColor: color.xTextColor,
                color: color.xSecondaryColor,isBlack: false,),
              SizedBox(height: 44.h),
              SizedBox(
                width: 300.w,
                child: InkWell(
                  onTap: () {
                    Mixin.navigate(context, const ISignUp());
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text:  TextSpan(
                      text: "By signing up, you agree to our",
                      style: TextStyle(color: color.xTextColor, fontSize: FONT_MEDIUM),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Terms of Use ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONT_MEDIUM, color: color.xTrailing,
                                decoration: TextDecoration.underline)),
                        TextSpan(
                            text: 'and to receive Winksy emails & updates and acknowledge that you read our ',
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: FONT_MEDIUM, color: color.xTextColor)),
                        TextSpan(
                            text: ' Privacy Policy.',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONT_MEDIUM, color: color.xTrailing, decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _fetchGoogleProfileData(String accessToken) async {
    try {
      // Fetch user profile data from Google People API
      final response = await http.get(
        Uri.parse('https://people.googleapis.com/v1/people/me?personFields=genders,birthdays'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Google People API Response: $data');
        
        // Extract gender
        if (data['genders'] != null && data['genders'].isNotEmpty) {
          gender = data['genders'][0]['value'] ?? 'Not specified';
          // Normalize gender values
          switch (gender?.toLowerCase()) {
            case 'male':
              gender = 'Male';
              break;
            case 'female':
              gender = 'Female';
              break;
            case 'other':
              gender = 'Other';
              break;
            default:
              gender = 'Not specified';
          }
        }
        
        // Extract birthday
        if (data['birthdays'] != null && data['birthdays'].isNotEmpty) {
          final birthdayData = data['birthdays'][0]['date'];
          if (birthdayData != null) {
            final year = birthdayData['year'];
            final month = birthdayData['month'];
            final day = birthdayData['day'];
            
            if (year != null && month != null && day != null) {
              birthday = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}T00:00:00.000Z';
            }
          }
        }
      } else {
        print('Failed to fetch Google profile data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching Google profile data: $error');
      // Set defaults if API call fails
      gender = 'Not specified';
      birthday = null;
    }
  }

  Future<void> _handleSignIn(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // await _googleSignIn.signOut();
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in process
        print('-----------------------------------------------------------------user cancelled sign-in');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      name = googleUser.displayName ?? "N/A";
      image = googleUser.photoUrl ?? "N/A";
      email = googleUser.email ?? "N/A";
      
      _nameController.text = name;
      _imageController.text = image;
      _emailController.text = email;
      _passwordController.text = name;

      // Fetch additional profile data including gender and birthday
      await _fetchGoogleProfileData(accessToken!);

      print('-----------------------------------------------------------------name: $name image: $image email : $email gender: $gender birthday: $birthday');


      if (accessToken == null) {
        // Handle error: missing token
        setState(() {
          _isLoading = false;
        });

        return;
      }
      setState(() {
        _isLoggedIn = true;
        _isLoading = false;
      });

      User user = User()
        ..usrFirstName = name
        ..usrLastName = name
        ..usrFullNames = name
        ..usrNationalId = email
        ..usrEmail = email
        ..usrMobileNumber = ''
        ..usrImage = image
        ..usrType = 'GOOGLE'
        ..usrEncryptedPassword = email+':'+email
        ..usrUsername = email
        ..usrGender = gender ?? 'Not specified'
        ..usrDob = birthday;

      IPost.postData(user, (state, res, value) {
        setState(() {
          if (state) {
            Mixin.prefString(pref: jsonEncode(value), key: CURR);
            Mixin.showToast(context, res, INFO);
            Mixin.getUser().then((value) => {
              Mixin.user = value,
              Mixin.pop(context, const IBio())
            });
          } else {
            Mixin.errorDialog(context, 'ERROR', res);
          }
          _isLoading = false;
        });
      }, IUrls.SIGN_IN());


    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

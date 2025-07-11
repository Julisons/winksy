import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:winksy/screen/authenticate/select/bio.dart';
import 'package:winksy/screen/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../mixin/constants.dart';
import '../../component/button.dart';
import '../../component/google.dart';
import '../../component/loader.dart';
import '../../component/logo.dart';
import '../../component/phone_field.dart';
import '../../mixin/mixins.dart';
import '../../model/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../request/posts.dart';
import '../../request/urls.dart';
import '../../theme/custom_colors.dart';
import '../account/terms.dart';
import '../home/home.dart';

class ISignUp extends StatefulWidget {
  const ISignUp({Key? key}) : super(key: key);

  @override
  State<ISignUp> createState() => _ISignUpState();
}

class _ISignUpState extends State<ISignUp> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _pinConfirmController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  bool _isLoggedIn = false;
  var name;
  var image;
  var email;


  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime latestAllowedDate = DateTime(now.year - 18, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: latestAllowedDate, // safe default
      firstDate: DateTime(1900),
      lastDate: latestAllowedDate,
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _ageController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.xPrimaryColor,
        title: Text('Sign up', style: TextStyle(color: color.xTrailing, fontWeight: FontWeight.bold),),
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: color.xTrailing),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: color.xPrimaryColor,
          height: MediaQuery.of(context).size.height + 56,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: 16, left: 24, right: 24, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: const SizedBox.shrink()),
              TextFormField(
                controller: _firstNameController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.xTrailing),
                    ),
                    border: InputBorder.none,
                    hintText: 'First name',
                    labelText: 'First name',
                    labelStyle: TextStyle(
                      color: color.xTextColor,
                      fontSize: FONT_13,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.xTrailing),
                    ),
                    hintStyle: TextStyle(
                      color: color.xTextColor,
                      fontSize: FONT_13,
                    ),
                    suffixIcon: Icon(Icons.star,color: color.xTrailing, size: 1,),
                    fillColor: color.xSecondaryColor,
                    filled: true
                ),
              ),
              SizedBox(height: 24.h),
              TextFormField(
                controller: _lastNameController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
                decoration:  InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  border: InputBorder.none,
                  hintText: 'Last name',
                  labelText: 'Last name',
                  labelStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  hintStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  suffixIcon: Icon(Icons.star,color: color.xTrailing, size: 1,),
                  fillColor: color.xSecondaryColor,
                  filled: true,
                ),
              ),
               SizedBox(height: 24.h),
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
                  hintText: 'Email address',
                  hintStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  suffixIcon: Icon(Icons.star,color: color.xTrailing, size: 1,),
                  fillColor: color.xSecondaryColor,
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),
              PhoneField(
                textEditingController: _phoneController,
                onCodeChange: (code) {},
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
                onTap: () {
                  _selectDate(context);
                },
                decoration:  InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  border: InputBorder.none,
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  hintText: 'Date of Birth (18+ required)',
                  hintStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  suffixIcon: Icon(Icons.star,color: color.xTrailing, size: 1,),
                  fillColor: color.xSecondaryColor,
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _pinController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  border: InputBorder.none,
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  fillColor: color.xSecondaryColor,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: color.xTrailing,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

               SizedBox(height: 34.h),
              Text(' * Please fill in all marked areas correctly.', style: TextStyle(color: color.xTrailing, fontWeight: FontWeight.bold),),
               SizedBox(height: 44.h),
              _isLoading
                  ?  Center(
                child: Loading(
                  dotColor: color.xTrailing,
                ),
              )
                  :

              IButton(
                color: color.xTrailing,
                onPress: () {
                  if (_firstNameController.text.isEmpty) {
                    Mixin.showToast(context, "First name cannot be empty!", ERROR);
                    return;
                  }

                  if (_lastNameController.text.isEmpty) {
                    Mixin.showToast(context, "Last name cannot be empty!", ERROR);
                    return;
                  }

                  if (_ageController.text.isEmpty) {
                    Mixin.showToast(context, "Date of birth cannot be empty!", ERROR);
                    return;
                  }

                  // Check if user is at least 18 years old
                  if (selectedDate != null) {
                    final DateTime now = DateTime.now();
                    final DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
                    if (selectedDate!.isAfter(eighteenYearsAgo)) {
                      Mixin.showToast(context, "You must be at least 18 years old to use this app!", ERROR);
                      return;
                    }
                  }

                  if (_emailController.text.isEmpty) {
                    Mixin.showToast(context, "Email cannot be empty!", ERROR);
                    return;
                  }

                  if (_phoneController.text.isEmpty) {
                    Mixin.showToast(context, "Phone cannot be empty!", ERROR);
                    return;
                  }

                  if (_pinController.text.isEmpty) {
                    Mixin.showToast(context, "Password cannot be empty!", ERROR);
                    return;
                  }

                  User user = User()
                    ..usrFirstName = _firstNameController.text.trim()
                    ..usrLastName = _lastNameController.text.trim()
                    ..usrEmail = _emailController.text.trim()
                    ..usrType = 'NORMAL'
                    ..usrFullNames = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                    ..usrMobileNumber = _phoneController.text.trim()
                    ..usrEncryptedPassword = _pinController.text.trim()
                    ..usrDob = DateFormat('yyyy-MM-dd').format(selectedDate!)
                    ..usrUsername = _emailController.text.trim();

                  setState(() {
                    _isLoading = true;
                  });

                  IPost.postData(user, (state, res, value) {
                    setState(() {
                      if (state) {
                        Mixin.prefString(pref: jsonEncode(value), key: CURR);
                        Mixin.showToast(context, res, INFO);
                        Mixin.getUser().then((value) => {
                          Mixin.user = value,
                          if(Mixin.user?.usrId != null){
                            Mixin.navigate(context, const IBio())
                          }
                        });
                      } else {
                        Mixin.errorDialog(context, 'ERROR', res);
                      }
                      _isLoading = false;
                    });
                  }, IUrls.SIGN_UP());
                },
                isBlack: true,
                text: "Submit",
                textColor: Colors.white,
              ),
              SizedBox(height: 16.h,),
              IGoogle(onPress: (){
                _handleSignIn(context);
              }, text: 'Sign up with Google', width: MediaQuery.of(context).size.width,textColor: color.xTextColor,
                color: color.xSecondaryColor,isBlack: false,),
               SizedBox(height: 24.h),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Mixin.navigate(context, const ISignIn());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Have an account?",
                      style: TextStyle(color: color.xTextColor, fontSize: FONT_MEDIUM),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  Sign in  ',
                            style: TextStyle(color: color.xTrailing,
                                fontWeight: FontWeight.bold, fontSize: FONT_MEDIUM)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: 300.w,
                child: InkWell(
                  onTap: () {
                   Mixin.navigate(context, const ITerms());
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
                            text: 'and to receive Wink emails & updates and acknowledge that you read our',
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

  Future<void> _handleSignIn(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // await _googleSignIn.signOut();
      // Trigger the Google Sign-in flow
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

      print('-----------------------------------------------------------------name: $name image: $image email : $email');

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
        ..usrType = 'GOOGLE'
        ..usrImage = image
        ..usrEncryptedPassword = email
        ..usrUsername = email;

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
            Mixin.signIn(context, 'ERROR', res);
          }
          _isLoading = false;
        });
      }, IUrls.SIGN_UP());


    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

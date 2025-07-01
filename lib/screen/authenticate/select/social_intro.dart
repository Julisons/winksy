import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:winksy/component/button.dart';
import 'package:winksy/screen/authenticate/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../component/google.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/user.dart';
import '../../../request/posts.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../home/home.dart';
import '../sign_in.dart';
import 'bio.dart';

class SocialIntro extends StatefulWidget {

  @override
  State<SocialIntro> createState() => _SocialIntroState();
}

class _SocialIntroState extends State<SocialIntro> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes,);

  bool _isLoading = false;
  bool _isLoggedIn = false;

  var name;
  var image;
  var email;
  var gender;
  var birthday;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.only(left: 30.h, right: 30.h, bottom: 30.h, top: 43.h),
        child:  Center(
            child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/icon.png',
                      width: MediaQuery.of(context).size.width,
                      height: 200.h,
                      fit: BoxFit.contain, // Adjust the image's scaling
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "Sign up",
                    style: TextStyle(
                      fontSize: FONT_START,
                      fontWeight: FontWeight.bold,
                      color: color.xTrailing,
                    ),
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width/1.4,
                      child: Text(" By signing up, you agree to our Terms of Use and to receive Winksy emails & updates and acknowledge that you read our Privacy Policy. ",
                          textAlign: TextAlign.center,
                          style: TextStyle( fontWeight: FontWeight.normal, color: color.xTextColor, fontSize: FONT_13)),
                    ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                      child: Text("Read Here",
                          textAlign: TextAlign.center,
                          style: TextStyle( fontWeight: FontWeight.bold, color: color.xTextColor,
                              fontSize: FONT_13, decoration: TextDecoration.underline)),
                    ),

                ],
              ),
            ),
            SizedBox(height: 20.h,),
           /* IButton(onPress: (){
            }, text: 'Apple', width: MediaQuery.of(context).size.width,textColor: Colors.white,
              color: Colors.grey,isBlack: false,),*/
            SizedBox(height: 16.h,),
            IGoogle(onPress: (){
              _handleSignIn(context);
            }, text: 'Sign up with Google', width: MediaQuery.of(context).size.width,textColor:color.xTextColor,
              color: color.xSecondaryColor,isBlack: false,),
            SizedBox(height: 16.h,),
            IButton(onPress: (){
              Mixin.navigate(context, const ISignUp());
            }, text: 'Sign up', width: MediaQuery.of(context).size.width,
              color: color.xTrailing,isBlack: false,textColor: Colors.white,),
            SizedBox(height: 26.h,),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Mixin.navigate(context, const ISignIn());
                },
                child: RichText(
                  text: TextSpan(
                    text: "Have an account ? ",
                    style: TextStyle(color: color.xTextColor, fontSize: FONT_MEDIUM),
                    children: <TextSpan>[
                      TextSpan(
                          text: '  Sign in Here  ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: FONT_MEDIUM, color: color.xTrailing)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        )),
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
}

import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.only(left: 30.h, right: 30.h, bottom: 30.h, top: 43.h),
        child:  Center(child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center, // Align widgets within the Stack
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
                  Positioned(
                    bottom: 205, // Position the text near the bottom
                    child: SizedBox(
                      width: 208.w,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Sign Up",
                        style: TextStyle(
                          fontSize: FONT_START,
                          fontWeight: FontWeight.bold,
                          color: color.xTrailing,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 70, // Position the text near the bottom
                    child: SizedBox(
                      width: 260.w,
                      child: Text(" By signing up, you agree to our Terms of Use and to receive Winksy emails & updates and acknowledge that you read our Privacy Policy. ",
                          textAlign: TextAlign.center,
                          style: TextStyle( fontWeight: FontWeight.normal, color: color.xTextColor, fontSize: FONT_13)),
                    ),
                  ),
                  Positioned(
                    bottom: 26, // Position the text near the bottom
                    child: SizedBox(
                      width: 260.w,
                      child: Text("Read Here",
                          textAlign: TextAlign.center,
                          style: TextStyle( fontWeight: FontWeight.bold, color: color.xTextColor,
                              fontSize: FONT_13, decoration: TextDecoration.underline)),
                    ),
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
            }, text: 'Sign Up with Google', width: MediaQuery.of(context).size.width,textColor:color.xTextColor,
              color: color.xSecondaryColor,isBlack: false,),
            SizedBox(height: 16.h,),
            IButton(onPress: (){
              Mixin.navigate(context, const ISignUp());
            }, text: 'Sign Up', width: MediaQuery.of(context).size.width,
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
                          text: '  Sign In Here  ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: FONT_MEDIUM, color: Theme.of(context).colorScheme.tertiary)),
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

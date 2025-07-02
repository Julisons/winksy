import 'dart:convert';
import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:winksy/screen/authenticate/password/reset_password.dart';
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

                            Mixin.pop(context, const IHome())
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

/*
  Future<void> password() async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('RESET PASSWORD', style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
          content: SizedBox(
            width: MediaQuery.of(context).size.width-10,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text('Enter email/phone number'),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).extension<CustomColors>()!.xTextColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: FONT_13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email address/phone',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                        fontSize: 16,
                      ),
                      fillColor: Color.fromARGB(250, 250, 250, 250),
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset', style: TextStyle(color: color.xTrailingAlt, fontWeight: FontWeight.bold)),
              onPressed: () {

                if (_emailController.text.isEmpty) {
                  Mixin.showToast(context,  "Email cannot be empty", ERROR);
                  return;
                }

                showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) => const Center(
                      child: Loading(
                        dotColor: xBlueColor,
                      ),
                    )
                );

                IPost.getData((state, res, value) {
                  setState(() {
                    if (state) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Mixin.showToast(context, res, INFO);
                      Future.delayed(const Duration(seconds: 3), () {validatePin();});
                    } else {
                      Navigator.of(context).pop();
                      password();
                      Mixin.errorDialog(context, 'ERROR', res);
                    }
                  });
                }, IUrls.RESET_PASSWORD());
              },
            ),
          ],
        );
      },
    );
  }
*/

/*  Future<void> validatePin() async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ENTER ONE TIME PIN(OTP)', style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
          content: SizedBox(
            width: MediaQuery.of(context).size.width-10,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text('Enter One Time Pin(OTP)'),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).extension<CustomColors>()!.xTextColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: _pinController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    style: TextStyle(fontSize: FONT_13),
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter One Time Pin(OTP)',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                        fontSize: 16,
                      ),
                      labelText: 'Enter One Time Pin(OTP)',
                      labelStyle: TextStyle(
                        color: Theme.of(context).extension<CustomColors>()!.xTextColor,
                        fontSize: FONT_13,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).extension<CustomColors>()!.xTrailing),
                      ),
                      fillColor: Color.fromARGB(250, 250, 250, 250),
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset', style: TextStyle(color: color.xTrailingAlt, fontWeight: FontWeight.bold)),
              onPressed: () {

                if (_emailController.text.isEmpty) {
                  Mixin.showToast(context,  "Email cannot be empty", ERROR);
                  return;
                }

                if (_pinController.text.isEmpty) {
                  Mixin.showToast(context,  "One time pin cannot be empty", ERROR);
                  return;
                }

                showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) =>  Center(
                      child: Loading(
                        dotColor: color.,
                      ),
                    )
                );

                User user = User()
                  ..usrUsername = _emailController.text.trim()
                  ..usrType = 'NORMAL'
                  ..usrEncryptedPassword = _pinController.text.trim();

                IPost.postData(user, (state, res, value) {
                  setState(() {
                    if (state) {
                      FocusScope.of(context).unfocus();
                      _pinConfirmController.text = '';
                      _pinController.text = '';
                      Mixin.user = User.fromJson(jsonDecode(value.toString() ?? ""));
                      Mixin.showToast(context, "Kindly reset your password now.", INFO);
                      Future.delayed(const Duration(seconds: 3), () {updatePassword(Mixin.user!);});
                    } else {
                      Mixin.errorDialog(context, 'ERROR', res);
                    }
                  });
                }, IUrls.SIGN_IN());
              },
            ),
          ],
        );
      },
    );
  }*/

  /*Future<void> updatePassword(User user) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('UPDATE PASSWORD', style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
          content: SizedBox(
            width: MediaQuery.of(context).size.width-10,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text('Enter new password'),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).extension<CustomColors>()!.xTextColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: _pinController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    style: TextStyle(fontSize: FONT_13),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                        fontSize: 16,
                      ),
                      fillColor: const Color.fromARGB(250, 250, 250, 250),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).extension<CustomColors>()!.xTextColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: _pinConfirmController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    style: TextStyle(fontSize: FONT_13),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Confirm password',
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                        fontSize: 16,
                      ),
                      fillColor: const Color.fromARGB(250, 250, 250, 250),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset', style: TextStyle(color: color.xTrailingAlt, fontWeight: FontWeight.bold)),
              onPressed: () {

                if (_pinController.text.isEmpty) {
                  Mixin.showToast(context,  "Password cannot be empty", ERROR);
                  return;
                }

                if (_pinConfirmController.text.isEmpty) {
                  Mixin.showToast(context,  "Password cannot be empty", ERROR);
                  return;
                }

                if (_pinConfirmController.text != _pinConfirmController.text) {
                  Mixin.showToast(context,  "Passwords don't interest", ERROR);
                  return;
                }

                 user.usrEncryptedPassword = _pinController.text.trim();

                showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) => const Center(
                      child: Loading(
                        dotColor: xBlueColor,
                      ),
                    )
                );

                IPost.postData(user, (state, res, value) {
                  setState(() {
                    if (state) {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                      Mixin.prefString(pref: value.toString(), key: CURR);
                      Mixin.showToast(context, res, INFO);
                      Mixin.pop(context, const IHome());
                    } else {
                      Navigator.of(context).pop();
                      Mixin.errorDialog(context, 'ERROR', res);
                    }
                    _isLoading = false;
                  });
                }, IUrls.RESET_PASSWORD());
              },
            ),
          ],
        );
      },
    );
  }*/

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

      _nameController.text = googleUser.displayName ?? "N/A";
      _imageController.text = googleUser.photoUrl ?? "N/A";
      _emailController.text = googleUser.email ?? "N/A";
      _passwordController.text = googleUser.displayName?? "N/A";


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
        ..usrFirstName = _nameController.text
        ..usrLastName =  _nameController.text
        ..usrType = 'GOOGLE'
        ..usrFullNames =  _nameController.text
        ..usrNationalId =  _emailController.text
        ..usrEmail = _emailController.text
        ..usrMobileNumber = _emailController.text
        ..usrImage = _imageController.text
        ..usrEncryptedPassword = _emailController.text
        ..usrUsername = _emailController.text;

      IPost.postData(user, (state, res, value) {
        setState(() {
          if (state) {
            Mixin.prefString(pref: jsonEncode(value), key: CURR);
            Mixin.showToast(context, res, INFO);
            Mixin.getUser().then((value) => {
              Mixin.user = value,
              Mixin.pop(context, const IHome())
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

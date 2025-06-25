import 'dart:convert';
import 'dart:developer';
import 'package:winksy/screen/authenticate/sign_up.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../component/button.dart';
import '../../../component/logo.dart';
import '../../../component/phone_field.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/user.dart';
import '../../../request/posts.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../home/home.dart';

class IResetPassword extends StatefulWidget {
  const IResetPassword({Key? key}) : super(key: key);

  @override
  State<IResetPassword> createState() => _IResetPasswordState();
}

class _IResetPasswordState extends State<IResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _pinConfirmController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  bool isPasswordVisible = false;
  bool isLoading = false;
  final User user = User();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text('Reset password', style: TextStyle(color:color.xTrailing, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.tertiary,),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body:
      Container(
        color:Theme.of(context).colorScheme.surface,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24, top: 16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width-10,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               Expanded(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     RichText(
                       textAlign: TextAlign.center,
                       text: TextSpan(
                         style: TextStyle(
                           color:  color.xTrailing,
                           fontSize: FONT_13, // adjust to your design
                         ),
                         children: [
                            TextSpan(text: 'Enter the '),
                            TextSpan(
                             text: 'email',
                             style: TextStyle(color: color.xTextColorSecondary,fontSize: FONT_13,fontWeight: FontWeight.bold),
                           ),
                            TextSpan(text: ' or '),
                            TextSpan(
                             text: 'mobile number',
                             style: TextStyle(color: color.xTextColorSecondary,fontSize: FONT_13,fontWeight: FontWeight.bold),
                           ),
                            TextSpan(text: '\nassociated with your account.'),
                         ],
                       ),
                     ),
                     SizedBox(height: 46.h),
                     /*PhoneField(
                      textEditingController: _phoneController,
                      onCodeChange: (code) {}),*/

                     TextFormField(
                       controller: _emailController,
                       keyboardType: TextInputType.emailAddress,
                       style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
                       decoration:  InputDecoration(
                         enabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: color.xTrailing),
                         ),
                         border: InputBorder.none,
                         labelText: 'Email or Mobile Number',
                         labelStyle: TextStyle(
                           color: color.xTextColor,
                           fontSize: FONT_13,
                         ),
                         focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: color.xTrailing),
                         ),
                         fillColor: Theme.of(context).colorScheme.surface,
                         filled: true,
                       ),
                     ),
                   ],
                 ),
               ),

              _isLoading ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.tertiary)) :

              IButton(
                  onPress: () {
                    if (_emailController.text.isEmpty) {
                      Mixin.showToast(context,  "Email or Mobile Number cannot be empty", ERROR);
                      return;
                    }

                    User user = User()
                      ..usrUsername = _emailController.text.trim();

                    setState(() {
                      _isLoading = true;
                    });

                    IPost.postData(user, (state, res, value) {
                      setState(() {
                        if (state) {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actionsAlignment: MainAxisAlignment.end,
                                backgroundColor:color.xSecondaryColor,
                                title: Text('INFO', style:  TextStyle(color: color.xTrailing)),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(res, style: TextStyle(color:  color.xTextColorSecondary)),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  IButton(
                                    onPress: () {
                                      Navigator.of(context).pop();
                                      validatePin();
                                    },
                                    isBlack: false,
                                    text: 'Ok',
                                    color:  color.xTrailing,
                                    textColor:  Colors.white,
                                    fontWeight: FontWeight.normal,
                                    width: 120.w,
                                    height: 35.h,
                                  )
                                ],
                              );
                            },
                          );
                        } else {
                          Mixin.errorDialog(context, 'ERROR', res);
                        }
                        _isLoading = false;
                      });
                    }, IUrls.RESET_PASSWORD());

                  },
                  isBlack: false,
                  text: "Reset password",
                  color: color.xTrailing,
                  textColor: Colors.white,
                 // width: MediaQuery.of(context).size.width/2
              ),
              SizedBox(height: 46.h),

              SizedBox(
                width: 300.w,
                child: InkWell(
                  onTap: () {
                   // Mixin.navigate(context, const ITerms());
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text:  TextSpan(
                      text: "By signing up, you agree to our",
                      style: TextStyle(color: Colors.white, fontSize: FONT_MEDIUM),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Terms of Use ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONT_MEDIUM, color: Theme.of(context).colorScheme.tertiary,
                                decoration: TextDecoration.underline)),
                        TextSpan(
                            text: 'and to receive Kiurate emails & updates and acknowledge that you read our ',
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: FONT_MEDIUM, color: Colors.white)),
                        TextSpan(
                            text: ' Privacy Policy.',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONT_MEDIUM, color: Theme.of(context).colorScheme.tertiary, decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        )

      ),
    );
  }


  Future<void> validatePin() async {
    final color = Theme.of(context).extension<CustomColors>()!;
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.end,
          backgroundColor: color.xSecondaryColor,
          title: Text('Enter One Time Pin (OTP)', style: TextStyle(color: color.xTrailing, fontSize: FONT_TITLE), textAlign: TextAlign.center, ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width/1.2,
            height: 180.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                 Text('Enter One Time Pin(OTP)',style: TextStyle(color: color.xTextColorSecondary, fontSize: FONT_13)),
                const SizedBox(height: 20),
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
                    hintText: 'PIN',
                    hintStyle: const TextStyle(
                      color: Color.fromRGBO(153, 153, 153, 1),
                      fontSize: 16,
                    ),
                    labelText: 'PIN',
                    labelStyle: TextStyle(
                      color: color.xTextColor,
                      fontSize: FONT_13,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.xTrailing),
                    ),
                    fillColor: Theme.of(context).colorScheme.surface,
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
              ],
            ),
          ),
          actions: <Widget>[
            IButton(
              text: 'Validate',
              color: color.xTrailing,
              textColor: Colors.white,
              onPress: () {

                if (_pinController.text.isEmpty) {
                  Mixin.showToast(context,  "One time pin cannot be empty", ERROR);
                  return;
                }

                showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(
                        color: xBlueColor,
                      ),
                    )
                );

                User user = User()
                  ..usrUsername = _emailController.text.trim()
                  ..usrCode = _pinController.text.trim();

                IPost.postData(user, (state, res, value) {
                  setState(() {
                    if (state) {
                      FocusScope.of(context).unfocus();
                      _phoneController.text = '';
                      _pinController.text = '';
                      Mixin.user = User.fromJson(jsonDecode(jsonEncode(value)));
                      Mixin.showToast(context,res, INFO);
                      Future.delayed(const Duration(seconds: 3), () {updatePassword(Mixin.user!);});
                    } else {
                      Mixin.errorDialog(context, 'ERROR', res);
                    }
                  });
                }, IUrls.VERIFY_OTP());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updatePassword(User user) async {
    final color = Theme.of(context).extension<CustomColors>()!;
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: color.xSecondaryColor,
          title: Text('UPDATE PASSWORD', style: TextStyle(color: color.xTrailing), textAlign: TextAlign.center,),
          content: SizedBox(
            width: MediaQuery.of(context).size.width-10,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                 Text('Enter new password',style: TextStyle(color: color.xTextColorSecondary,fontSize: FONT_13,)),
                const SizedBox(height: 20),
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
                    fillColor: color.xPrimaryColor,
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _pinConfirmController,
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
                    hintText: 'Confirm password',
                    hintStyle: TextStyle(
                      color: color.xTextColor,
                      fontSize: FONT_13,
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: color.xTextColor,
                      fontSize: FONT_13,
                    ),
                    fillColor: color.xPrimaryColor,
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
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            IButton(
              text: 'Update password',
              color: color.xTrailing,
              textColor: Colors.white,
              onPress: () {

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
                      child: CircularProgressIndicator(
                        color: xBlueColor,
                      ),
                    )
                );

                IPost.postData(user, (state, res, value) {
                  setState(() {
                    if (state) {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();

                      Mixin.prefString(pref: jsonEncode(value), key: CURR);
                      Mixin.showToast(context, res, INFO);
                      Mixin.getUser().then((value) => {
                        Mixin.user = value,
                        Mixin.navigate(context, const IHome())
                      });

                    } else {
                      Navigator.of(context).pop();
                      Mixin.errorDialog(context, 'ERROR', res);
                    }
                    isLoading = false;
                  });
                }, IUrls.UPDATE_PASSWORD());
              },
            ),
          ],
        );
      },
    );
  }
}

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
import '../../home/home.dart';

class IResetPassword extends StatefulWidget {
  const IResetPassword({Key? key}) : super(key: key);

  @override
  State<IResetPassword> createState() => _IResetPasswordState();
}

class _IResetPasswordState extends State<IResetPassword> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _pinConfirmController = TextEditingController();
  bool _isLoading = false;

  bool isPasswordVisible = false;
  bool isLoading = false;
  final User user = User();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text('Password Reset', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
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
                     Text(' Enter the mobile number\n'
                        'associated with your account. ',
                       textAlign: TextAlign.center,style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
                     SizedBox(height: 46.h),
                                   PhoneField(
                      textEditingController: _phoneController,
                      onCodeChange: (code) {},
                                   ),
                   ],
                 ),
               ),

              _isLoading ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.tertiary)) :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IButton(
                      onPress: () {
                        if (_phoneController.text.isEmpty) {
                          Mixin.showToast(context,  "Phone cannot be empty", ERROR);
                          return;
                        }

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
                        }, IUrls.SEND_OTP("phone=${_phoneController.text}"));
                      },
                      isBlack: false,
                      text: "Done",
                      color: Theme.of(context).colorScheme.tertiary,
                      width: MediaQuery.of(context).size.width/2.4
                  ),
                  IButton(
                      onPress: () {

                        Navigator.pop(context);
                      },
                      isBlack: false,
                      text: "Cancel",
                      color: Theme.of(context).colorScheme.secondary,
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width/2.4
                  ),
                ],
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

  Future<void> password() async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('RESET PASSWORD', style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
          content:

          SizedBox(
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
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: _phoneController,
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
              child: const Text('Reset', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: () {

                if (_phoneController.text.isEmpty) {
                  Mixin.showToast(context,  "Email cannot be empty", ERROR);
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
                }, IUrls.SEND_OTP("phone=${_phoneController.text}"));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> validatePin() async {
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
                      color: Colors.white,
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
                        color: Colors.white,
                        fontSize: FONT_13,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
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
              child: const Text('Reset', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: () {

                if (_phoneController.text.isEmpty) {
                  Mixin.showToast(context,  "Email cannot be empty", ERROR);
                  return;
                }

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
                  ..usrMobileNumber = _phoneController.text.trim();

                IPost.postData(user, (state, res, value) {
                  setState(() {
                    if (state) {
                      FocusScope.of(context).unfocus();
                      _phoneController.text = '';
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
  }

  Future<void> updatePassword(User user) async {
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
                      color: Colors.white,
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
                      color: Colors.white,
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
              child: const Text('Reset', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                      Mixin.prefString(pref: value.toString(), key: CURR);
                      Mixin.showToast(context, res, INFO);
                      Mixin.pop(context, const IHome());
                    } else {
                      Navigator.of(context).pop();
                      Mixin.errorDialog(context, 'ERROR', res);
                    }
                    isLoading = false;
                  });
                }, IUrls.RESET_PASSWORD());
              },
            ),
          ],
        );
      },
    );
  }
}

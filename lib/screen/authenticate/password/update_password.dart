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

class IUpdatePassword extends StatefulWidget {
  const IUpdatePassword({Key? key}) : super(key: key);

  @override
  State<IUpdatePassword> createState() => _IUpdatePasswordState();
}

class _IUpdatePasswordState extends State<IUpdatePassword> {
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
    

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text('New Password', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
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
                     TextFormField(
                       controller: _pinController,
                       keyboardType: TextInputType.text,
                       style: TextStyle(fontSize: FONT_13,  color: Theme.of(context).colorScheme.tertiary),
                       obscureText: !_isPasswordVisible,
                       decoration: InputDecoration(
                         enabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                         ),
                         focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                         ),
                         border: InputBorder.none,
                         hintText: 'Password',
                         hintStyle: TextStyle(
                           color: Theme.of(context).colorScheme.tertiary,
                           fontSize: FONT_13,
                         ),
                         labelText: 'Password',
                         labelStyle: TextStyle(
                           color: Theme.of(context).colorScheme.tertiary,
                           fontSize: FONT_13,
                         ),
                         fillColor: Theme.of(context).colorScheme.surface,
                         filled: true,
                         suffixIcon: IconButton(
                           icon: Icon(
                             // Based on passwordVisible state choose the icon
                             _isPasswordVisible
                                 ? Icons.visibility
                                 : Icons.visibility_off,
                             color: Theme.of(context).colorScheme.tertiary,
                           ),
                           onPressed: () {
                             setState(() {
                               _isPasswordVisible = !_isPasswordVisible;
                             });
                           },
                         ),
                       ),
                     ),
                     SizedBox(height: 36.h),
                     TextFormField(
                       controller: _pinConfirmController,
                       keyboardType: TextInputType.text,
                       style: TextStyle(fontSize: FONT_13,  color: Theme.of(context).colorScheme.tertiary),
                       obscureText: !_isPasswordVisible,
                       decoration: InputDecoration(
                         enabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                         ),
                         focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                         ),
                         border: InputBorder.none,
                         hintText: 'Password',
                         hintStyle: TextStyle(
                           color: Theme.of(context).colorScheme.tertiary,
                           fontSize: FONT_13,
                         ),
                         labelText: 'Repeat Password',
                         labelStyle: TextStyle(
                           color: Theme.of(context).colorScheme.tertiary,
                           fontSize: FONT_13,
                         ),
                         fillColor: Theme.of(context).colorScheme.surface,
                         filled: true,
                      /*   suffixIcon: IconButton(
                           icon: Icon(
                             // Based on passwordVisible state choose the icon
                             _isPasswordVisible
                                 ? Icons.visibility
                                 : Icons.visibility_off,
                             color: Theme.of(context).colorScheme.tertiary,
                           ),
                           onPressed: () {
                             setState(() {
                               _isPasswordVisible = !_isPasswordVisible;
                             });
                           },
                         ),*/
                       ),
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

import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../component/logo.dart';
import '../../component/popup.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';
import '../authenticate/select/intro.dart';
import '../authenticate/sign_up.dart';
import '../home/home.dart';

class ITerms extends StatefulWidget {
  const ITerms({Key? key}) : super(key: key);

  @override
  State<ITerms> createState() => _ITermsState();
}

class _ITermsState extends State<ITerms> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
          surfaceTintColor: color.xPrimaryColor,
          centerTitle: true,
          backgroundColor: color.xPrimaryColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: color.xTrailing),
            onPressed: () {
              Navigator.pop(context); // Pops the current screen from the stack
            },
          ),
          title:Text("Terms & Conditions", style: TextStyle(color: color.xTrailing, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
      ),
      backgroundColor: color.xPrimaryColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:  EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 258.w,
                  child: Image.asset(
                    'assets/images/icon.png',
                    fit: BoxFit.cover, // Adjust the image's scaling
                  ),
                ),
                Text("TERMS AND CONDITIONS FOR THE USE OF THE"
                    "BREADCRAM MOBILE SOFTWARE APPLICATION\n\n",
                    textAlign: TextAlign.center,
                    style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize: FONT_MEDIUM)),
                Text(
                  "The following Terms and Conditions apply to the use of this mobile application. "
                      "By using Wink, you are deemed to have read, understood, and accepted these Terms and Conditions.\n\n"

                      "1. Introduction – By using the Wink mobile application, you enter into a binding agreement with us. "
                      "If you do not agree with these Terms and Conditions, please do not use the service. By proceeding, you warrant that "
                      "you are legally capable of entering into a contract and are not prohibited by any applicable laws.\n\n"

                      "2. Changes to Terms – Wink may update these Terms and Conditions at any time, at its sole discretion. "
                      "If any changes are considered material, you will be notified via the application. Continued use of the app implies your acceptance "
                      "of the revised terms.\n\n"

                      "3. Eligibility – You must be at least 18 years of age to use Wink.\n\n"

                      "4. Prohibited Use – By using Wink, you agree not to modify, reverse engineer, or create derivative works of our services.\n\n"

                      "5. Intellectual Property – All rights, titles, and interests in Wink, including trademarks, names, and related IP, "
                      "remain the exclusive property of Wink. You may not use or register any of Wink’s intellectual property.\n\n"

                      "6. Limitation of Liability – Wink shall not be liable for any indirect, incidental, special, or consequential damages, "
                      "including but not limited to loss of profits, data, or business interruption arising from the use or inability to use the service, "
                      "even if advised of the possibility of such damages. Liability is limited to the amount paid by you, if any.\n\n"

                      "7. Governing Law – These Terms shall be governed by the laws of Kenya, and any disputes shall be resolved in the Kenyan courts.\n\n"

                      "8. Termination – Wink reserves the right to change, suspend, or discontinue any part of the app or its features at any time, "
                      "without notice.\n\n",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: FONT_MEDIUM,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

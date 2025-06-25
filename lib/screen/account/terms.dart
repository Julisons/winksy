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

    return Scaffold(
      appBar: AppBar(
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.tertiary),
            onPressed: () {
              Navigator.pop(context); // Pops the current screen from the stack
            },
          ),
          title:Text("Terms & Conditions", style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
          actions: <Widget>[
            IPopup()
          ]),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:  EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/ic_launcher.webp'),
                SizedBox(
                  width: 258.w,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover, // Adjust the image's scaling
                  ),
                ),
                Text("TERMS AND CONDITIONS FOR THE USE OF THE"
                    "BREADCRAM MOBILE SOFTWARE APPLICATION\n\n",
                    textAlign: TextAlign.start,
                    style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize: FONT_MEDIUM)),
                Text("The following Terms and Conditions apply to the"
                    "use of this mobile software application and by"
                    "using the application you will be deemed to have"
                    "read, understood and accepted these Terms and"
                    "Conditions;\n\n"

                    "1.Introduction- by using Breadcram Mobile"
                    "Software Application, you are entering into a"
                    "binding contract with our company. Your"
                    "agreement with Breadcram includes these Terms"
                    "and Conditions. If you do not agree with the"
                    "Terms and Conditions, do not use the service. By"
                    "using Breadcram, you warrant that you have the"
                    "power to enter into a binding contract with us and"
                    "that you are not prevented by any applicable"
                    "laws.\n\n"

                    "2.Changes to the Terms and Conditions-"
                    "Breadcram may, from time to time, and at their"
                    "sole discretion, make changes to these Terms"
                    "and Conditions. When Breadcram makes such"
                    "changes that they consider material, you will be"
                    "notified you through the software application. By"
                    "continuing to use the application after changes"
                    "have been made, you express and acknowledge"
                    "your acceptance of the changes."

                    "3.Eligibility- you must be 18 years of age or older"
                    "4.Prohibited uses- by using Breadcram services"
                    "you agree not to; -modify, prepare derivative"
                    "works of, or reverse engineer our services."
                    "5.Intellectual property- you acknowledge that"
                    "Breadcram retains all proprietary rights, title and"
                    "interest in the services;- name, marks and any"
                    "related IP rights including, without limitation, all"
                    "modifications, enhancements and upgrades"
                    "thereto. You agree that you will not use or"
                    "register any of Breadcram’s intellectual property"
                    "(trademark, business name).\n\n"

                    "6.Limitation of liability and warranties- you agree"
                    "that Breadcram mobile software application shall,"
                    "in no event, be liable for any consequential,"
                    "incidental, indirect, special, or other loss/damage"
                    "whatsoever or for loss of business profits,"
                    "business interruption, computer failure, or other"
                    "loss arising out of or caused by your use of or"
                    "inability to use the service, even if Breadcram"
                    "mobile software application has been advised of"
                    "the possibility of such damage. In no event shall"
                    "Breadcram be liable to you in respect of any"
                    "service, whether direct/indirect, exceed the fees"
                    "paid by you towards such service."
                    "7.Governing law and jurisdiction- these Terms of"
                    "Service are governed by the laws of Kenya and all"
                    "parties submit to the exclusive jurisdiction of the"
                    "courts of Kenya.\n\n"

                    "8.Termination- Breadcram reserves the right, in"
                    "its sole discretion, to change, limit or discontinue"
                    "any aspect, content, or feature of the application,"
                    "as well as any aspect pertaining to the use of the"
                    "mobile application.\n\n"
                    ,
                    textAlign: TextAlign.start,
                    style: TextStyle( fontWeight: FontWeight.normal, color: Colors.white, fontSize: FONT_MEDIUM)),
                 SizedBox(height: 20.h),
                SizedBox(
                  width: 258.w,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover, // Adjust the image's scaling
                  ),
                ),
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

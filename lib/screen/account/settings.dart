import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:winksy/screen/account/profile.dart';
import 'package:winksy/screen/account/terms.dart';

import '../../component/logo.dart';
import '../../component/popup.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../provider/theme_provider.dart';
import '../../theme/custom_colors.dart';
import '../../theme/theme_data_style.dart';
import '../authenticate/select/intro.dart';
import '../authenticate/sign_up.dart';
import '../home/home.dart';
import 'account.dart';
import 'contact.dart';

class ISettings extends StatefulWidget {
  const ISettings({Key? key}) : super(key: key);

  @override
  State<ISettings> createState() => _ISettingsState();
}

class _ISettingsState extends State<ISettings> {
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
          automaticallyImplyLeading: false,
          backgroundColor: color.xPrimaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: color.xTrailing),
            onPressed: () {
              Navigator.pop(context); // Pops the current screen from the stack
            },
          ),
          title: Text(
            "Settings",
            style: TextStyle(
                color: color.xTrailing,
                fontWeight: FontWeight.bold,
                fontSize: FONT_APP_BAR),
          ),
         ),
      backgroundColor: color.xPrimaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: 100.h, right: 24.h, left: 24.h),
              child: Column(
                children: [
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: color.xTextColorSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_APP_BAR),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      ],
                    ),
                    onTap: () {
                      Mixin.navigate(context,  IAccount());
                    },
                  ),
                  SizedBox(height: 6.w),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Change Mobile No.",
                          style: TextStyle(
                              color: color.xTextColorSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_APP_BAR),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      ],
                    ),
                    onTap: () {
                      Mixin.navigate(context, IProfile());
                    },
                  ),
                  SizedBox(height: 6.w),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Terms & Conditions",
                          style: TextStyle(
                              color: color.xTextColorSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_APP_BAR),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      ],
                    ),
                    onTap: () {
                      Mixin.navigate(context, const ITerms());
                    },
                  ),
                  SizedBox(height: 6.w),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Contact Us",
                          style: TextStyle(
                              color: color.xTextColorSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_APP_BAR),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      ],
                    ),
                    onTap: () {
                      Mixin.navigate(context, const IContactUs());
                    },
                  ),
                  SizedBox(height: 6.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sign out",
                        style: TextStyle(
                            color: color.xTextColorSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_APP_BAR),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).colorScheme.tertiary,
                      )
                    ],
                  )
                ],
              ),
            )),
            Image.asset('assets/images/icon.png'),
            SizedBox(
              width: 193.w,
              child: Text(
                  "Designed & Developed in Nairobi.© 2025 Wink Technologies Limited.Closed Beta V1.0.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: FONT_13)),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

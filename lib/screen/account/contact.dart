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

class IContactUs extends StatefulWidget {
  const IContactUs({Key? key}) : super(key: key);

  @override
  State<IContactUs> createState() => _IContactUsState();
}

class _IContactUsState extends State<IContactUs> {

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
          title:Text("Contact us", style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
         ),
      backgroundColor: color.xPrimaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: SizedBox.shrink()),
              SizedBox(
                width: 258.w,
                child: Image.asset(
                  'assets/images/icon.png',
                  fit: BoxFit.cover, // Adjust the image's scaling
                ),
              ),
              Text(" info@wink.com\n"
                  "Tel +254 700225822\n"
                  "P.O. Box 50410-10\n"
                  "Nairobi, Kenya.\n",
                  textAlign: TextAlign.center,
                  style: TextStyle( fontWeight: FontWeight.bold, color: color.xTrailing, fontSize: FONT_MEDIUM,letterSpacing: 1,wordSpacing: 3)),
              SizedBox(height: 16.h),
              Text("www.winksy.co.ke",
                  textAlign: TextAlign.center,
                  style: TextStyle( fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary, fontSize: FONT_MEDIUM)),
              SizedBox(height: 40.h),
            ],
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

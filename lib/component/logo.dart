import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/popup.dart';
import '../mixin/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ILogo extends StatelessWidget {
  const ILogo({Key? key, this.title = 'SHOPIC'}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      "SHOPIC",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 30.sp,
          color: Colors.blue,
          fontFamily: GoogleFonts.gamjaFlower().fontFamily,
      ),
    );
  }
}

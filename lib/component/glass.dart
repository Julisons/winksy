import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Glass extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final TextStyle textStyle;

  const Glass({
    super.key,
    required this.text,
    this.width = 300,
    this.height = 200,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            //width: width,
           // height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Padding(
                padding:  EdgeInsets.only(right: 8.w,left: 8.w,bottom: 4.h,top: 4.h),
                child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: textStyle
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
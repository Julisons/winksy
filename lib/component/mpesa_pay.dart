import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibration/vibration.dart';
import '../mixin/constants.dart';
import '../theme/custom_colors.dart';

class IMpesaPay extends StatelessWidget {
  final bool isDisabled;
  final bool isBlack;
  final double padding;
  final onPress;
  final Color color;
  final Color textColor;
  final bool hasDynamicWidth;
  final double width;
  final double height;
  final double font;
  final FontWeight fontWeight;

  const IMpesaPay(
      {Key? key,
      required this.onPress,
      this.hasDynamicWidth = false,
      this.isDisabled = false,
      this.isBlack = false,
      this.textColor = Colors.black,
      this.padding = 0,
        this.color = Colors.black,
        this.width = 0.0,
        this.height = 45,
        this.font = 10,
        this.fontWeight = FontWeight.w500})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.w),
      child: InkWell(
        onTap: isDisabled
            ? () {}
            : () {
          Vibration.vibrate(duration: 1, amplitude: 8);
                onPress();
              },
        child: Container(
           height:height,
            decoration: BoxDecoration(
                color: /*isDisabled
                    ? xDisabledColor
                    : isBlack
                        ?*/ color,
                       // : xBlueColor,
                borderRadius: BorderRadius.circular(4.r)),
            child: hasDynamicWidth
                ? buttonContent(context)
                : SizedBox(
                    width:width == 0.0 ? MediaQuery.of(context).size.width : width,
                    height: 28.h,
                    child: Center(child: buttonContent(context)))),
      ),
    );
  }

  Widget buttonContent(context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pay With',
              style: TextStyle(
                fontFamily: 'Work Sans',
                fontSize: font == 10 ? FONT_13 : font,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 10,),
            Image.asset('assets/images/mpesa.png',
              width: 70.w,
              height: 30.h,
              fit: BoxFit.cover, // Adjust the image's scaling
            ),
            SizedBox(width: 10,),
          ],
        ));
  }
}

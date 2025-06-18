import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibration/vibration.dart';
import '../mixin/constants.dart';

class IButton extends StatelessWidget {
  final bool isDisabled;
  final bool isBlack;
  final double padding;
  final onPress;
  final String text;
  final Color color;
  final Color textColor;
  final bool hasDynamicWidth;
  final double width;
  final double height;
  final double font;
  final Widget? icon;
  final FontWeight fontWeight;

  const IButton(
      {Key? key,
      required this.onPress,
      required this.text,
      this.hasDynamicWidth = false,
      this.isDisabled = false,
      this.isBlack = false,
      this.textColor = Colors.black,
      this.padding = 0,
        this.color = xBlueColor,
        this.width = 0.0,
        this.height = 45,
        this.font = 10,
        this.fontWeight = FontWeight.w500,  this.icon})
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: icon!,
              ),
            Text(text,
              style: TextStyle(
                //fontFamily: 'Work Sans',
                fontSize: font == 10 ? FONT_13 : font,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}

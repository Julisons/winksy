import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/custom_colors.dart';
import 'button.dart';

class ProfileProgressWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double completion; // between 0 and 1
  final bool isVerified;

  const ProfileProgressWidget({
    required this.imageUrl,
    required this.name,
    required this.completion,
    this.isVerified = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: color.xTextColorSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Text('${(completion * 100).toInt()}% complete',
          style: TextStyle(fontSize: 14.sp, color: color.xTextColor),
        ),
        SizedBox(height: 16.h),
        SizedBox(
         // color: Colors.blue,
         height: 133.h,
         width: 143.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 118.w,
                height: 118.w,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: completion),
                  duration: Duration(milliseconds: 4800),
                  builder: (context, value, _) => CircularProgressIndicator(
                    value: value,
                    strokeWidth: 2,
                    backgroundColor: color.xSecondaryColor,
                    color: color.xTrailingAlt, // blue accent color
                  ),
                ),
              ),
              CircleAvatar(
                radius: 56.w,
                backgroundImage: CachedNetworkImageProvider(imageUrl),
              ),
              Positioned(
                bottom: -1,
                child: IButton(
                  color: color.xTrailing,
                  onPress: () {
                    // handle edit
                  },
                  isBlack: true,
                  text: "Edit",
                  width: 60.w,
                  height: 28.h,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h), // Push verified label further down
        if (isVerified)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: color.xTrailingAlt, size: 20.r),
              SizedBox(width: 6.w),
              Text(
                "Verified profile",
                style: TextStyle(
                  color: color.xTextColor,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

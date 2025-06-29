import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/screen/account/editor/stepper.dart';

import '../mixin/mixins.dart';
import '../request/urls.dart';
import '../screen/account/editor/account.dart';
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
     // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //SizedBox(height: 40.h), // Add top padding
        SizedBox(
          width: 140.w, // Width based on circle + button
          height: 160.h, // Height to accommodate circle + button
          child: Stack(
            children: [
              // Progress ring container - positioned at top center
              Positioned(
                top: 0,
                left: 5.w, // Center the 130w progress ring in 140w container
                child: SizedBox(
                  width: 130.w,
                  height: 130.w,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: completion),
                    duration: Duration(milliseconds: 3000),
                    builder: (context, value, _) => CircularProgressIndicator(
                      value: value,
                      strokeWidth: 3.r,
                      backgroundColor: color.xSecondaryColor,
                      color: color.xTrailingAlt, // blue accent color
                    ),
                  ),
                ),
              ),
              // Profile image perfectly centered in progress ring
              Positioned(
                top: 10.w, // (130w - 110w) / 2 = 10w offset from progress ring
                left: 15.w, // 5w (ring offset) + 10w (centering) = 15w
                child: CircleAvatar(
                  radius: 55.w, // 110w diameter fits nicely in 130w progress ring
                  backgroundColor: color.xPrimaryColor,
                  backgroundImage: CachedNetworkImageProvider(
                    imageUrl.startsWith('http') ? imageUrl : '${IUrls.IMAGE_URL}/file/secured/$imageUrl',
                  ),
                ),
              ),
              // Edit button anchored to bottom of circle
              Positioned(
                bottom: 0, // Position at bottom of the SizedBox
                left: 0,
                right: 0,
                child: Center(
                  child: IButton(
                    color: color.xTrailing,
                    onPress: () {
                      Mixin.navigate(context, IStepper());
                    },
                    isBlack: true,
                    text: "Edit",
                    icon: Icon(Icons.edit, color: Colors.white, size: 16.r),
                    width: 90.w,
                    height: 35.h,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h), // Normal spacing since button is now contained
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

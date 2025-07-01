import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/screen/account/editor/stepper.dart';

import '../mixin/constants.dart';
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
                child: GestureDetector(
                  onTap: () => _showImagePopup(context),
                  child: CircleAvatar(
                    radius: 55.w, // 110w diameter fits nicely in 130w progress ring
                    backgroundColor: color.xPrimaryColor,
                    backgroundImage: CachedNetworkImageProvider(
                      imageUrl.startsWith('http') ? imageUrl : '${IUrls.IMAGE_URL}/file/secured/$imageUrl',
                    ),
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

  void _showImagePopup(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Profile Photo Viewer',
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          )),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              )),
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background glass effect
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.xPrimaryColor.withOpacity(0.1),
                            color.xSecondaryColor.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    // Main image container
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height * 0.8,
                      padding: EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl.startsWith('http') ? imageUrl : '${IUrls.IMAGE_URL}/file/secured/$imageUrl',
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    color.xPrimaryColor.withOpacity(0.8),
                                    color.xSecondaryColor.withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(color.xTrailing),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Loading profile photo...',
                                      style: TextStyle(
                                        color: color.xTextColorSecondary,
                                        fontSize: FONT_13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    color.xPrimaryColor.withOpacity(0.8),
                                    Colors.red.withOpacity(0.3),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: color.xTextColor,
                                        size: 50,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Failed to load profile photo',
                                      style: TextStyle(
                                        color: color.xTextColor,
                                        fontSize: FONT_13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Enhanced close button
                    Positioned(
                      top: 30,
                      right: 30,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    // Profile info overlay
                    Positioned(
                      bottom: 30,
                      left: 30,
                      right: 30,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: FONT_13,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.xTrailing.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${(completion * 100).toInt()}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

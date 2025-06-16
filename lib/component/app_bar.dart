import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/popup.dart';
import '../mixin/constants.dart';
import '../theme/custom_colors.dart';

class IAppBar extends StatelessWidget implements PreferredSizeWidget  {
  const IAppBar({Key? key, this.title = 'Winksy'}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return AppBar(
      backgroundColor: color.xPrimaryColor,
      title: Transform(
        transform: Matrix4.translationValues(10, 0.0, 0.0),
        child: SizedBox(
            width: 310.w,
            height: 120.h,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Text(title,
                  style: GoogleFonts.poppins(
                    color: color.xTrailing, fontSize: 34, fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: color.xSecondaryColor
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

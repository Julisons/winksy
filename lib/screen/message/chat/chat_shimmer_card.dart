import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../component/button.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/invoice.dart';
import '../../../request/urls.dart';
import '../../../model/notification.dart' as n;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/custom_colors.dart';

class IChatShimmerCard extends StatelessWidget {
  const IChatShimmerCard({super.key,});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.h,
      margin: EdgeInsets.only(left: 16.0.h,right: 16.0.h,top: 8.0.h),
      child: ClipRect(
        child: Shimmer.fromColors(
          baseColor: color.xSecondaryColor,
          highlightColor: color.xPrimaryColor,
          direction: ShimmerDirection.ttb,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme/custom_colors.dart';


class ITreatShimmerCard extends StatelessWidget {
  const ITreatShimmerCard({super.key,});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Card(
      elevation: 4,
      color: color.xSecondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100.h,
        child: ClipRect(
          child: Shimmer.fromColors(
            baseColor: color.xSecondaryColor,
            highlightColor: color.xPrimaryColor,
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
      ),
    );
  }
}

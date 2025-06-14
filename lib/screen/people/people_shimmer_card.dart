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

class IPeopleShimmerCard extends StatelessWidget {
  const IPeopleShimmerCard({super.key,});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width/1.5,
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
    );
  }
}

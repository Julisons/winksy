import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../component/loading.dart';
import '../../../component/no_result.dart';
import '../../../mixin/constants.dart';
import 'package:provider/provider.dart';
import '../../../mixin/mixins.dart';
import '../../../theme/custom_colors.dart';
import 'photo_shimmer_card.dart';

class IPhotoShimmer extends StatelessWidget {
  const IPhotoShimmer({super.key});

  @override
  Widget build(context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xSecondaryColor,
      body:Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(
                  bottom: 6,
                  top: 6,
                  right: 6,
                  left: 6),
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Mixin.isTab(context) ? 3 : 2, // Number of items per row
                crossAxisSpacing: 6.0, // Spacing between columns
                mainAxisSpacing: 6.0, // Spacing between rows
                childAspectRatio: .7, // Aspect ratio of each grid item
              ),
              itemBuilder: (context, index) {
                return IPhotoShimmerCard();
              },
              itemCount: 100
            )
          ),
        ],
      ),
    );
  }
}
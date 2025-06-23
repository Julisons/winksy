import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../mixin/mixins.dart';
import '../../../../theme/custom_colors.dart';
import 'treats_shimmer_card.dart';

class ITreatShimmer extends StatelessWidget {
  const ITreatShimmer({super.key});

  @override
  Widget build(context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
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
                  crossAxisCount: Mixin.isTab(context) ? 6 : 3, // Number of items per row
                  crossAxisSpacing: .0, // Spacing between columns
                  mainAxisSpacing: 6.0, // Spacing between rows
                  childAspectRatio: .99, // Aspect ratio of each grid item
                ),
              itemBuilder: (context, index) {
                return ITreatShimmerCard();
              },
              itemCount: 100
            )
          ),
        ],
      ),
    );
  }
}
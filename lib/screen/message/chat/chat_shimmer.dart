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
import 'chat_shimmer_card.dart';

class IChatShimmer extends StatelessWidget {
  const IChatShimmer({super.key});

  @override
  Widget build(context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      body:Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 6,
                  top: 6,
                  right: 6,
                  left: 6),
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return IChatShimmerCard();
              },
              itemCount: 100
            )
          ),
        ],
      ),
    );
  }
}
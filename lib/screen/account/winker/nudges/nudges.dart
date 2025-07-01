import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';

import 'package:winksy/mixin/mixins.dart';
import 'package:winksy/provider/nudge/nudge_sound_provider.dart';
import 'package:winksy/screen/account/winker/nudges/nudges_card.dart';

import '../../../../component/loader.dart';
import '../../../../mixin/constants.dart';
import '../../../../theme/custom_colors.dart';

class INudges extends StatefulWidget {
  const INudges({super.key});

  @override
  State<INudges> createState() => _INudgesState();
}

class _INudgesState extends State<INudges> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Consumer<INudgeSoundProvider>(
        builder: (context, provider, child) {

          return provider.isLoading() ?

              Center(
                child: Loading(
                  dotColor: color.xTrailing,
                ),
              ) :

          Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: color.xTrailing,
                          size: 24.r,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Nudge Sounds',
                          style: TextStyle(
                            fontSize: FONT_TITLE,
                            fontWeight: FontWeight.w600,
                            color: color.xTextColorSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Wake them up with a gentle sound! 🔔\nPerfect for getting someone\'s attention when words aren\'t enough',
                      style: TextStyle(
                        fontSize: FONT_13,
                        fontWeight: FontWeight.w400,
                        color: color.xTextColor,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                    color: color.xTrailing,
                    backgroundColor: color.xPrimaryColor,
                    onRefresh: () => provider.refresh('',true),
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
                        crossAxisCount: Mixin.isTab(context) ? 4 : 2, // Number of items per row
                        crossAxisSpacing: 8.0, // Spacing between columns
                        mainAxisSpacing: 8.0, // Spacing between rows
                        childAspectRatio: 1.2, // Aspect ratio of each grid item
                      ),
                      itemBuilder: (context, index) {
                        return INudgeCard(
                          nudgeSound: provider.list[index],
                        );
                      },
                      itemCount: provider.getCount(),
                    )),
              ),

              if(provider.isLoadingMore())
                Container(
                    padding: EdgeInsets.all(14.h),
                    child: Loading(dotColor: color.xTrailing))
            ],
          );
        });
  }
}
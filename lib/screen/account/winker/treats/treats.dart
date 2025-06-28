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
import 'package:winksy/provider/gift/treat_provider.dart';
import 'package:winksy/screen/account/winker/treats/treats_card.dart';
import 'package:winksy/screen/account/winker/treats/treats_shimmer.dart';
import '../../../../component/loader.dart';
import '../../../../mixin/constants.dart';
import '../../../../theme/custom_colors.dart';


class ITreats extends StatefulWidget {
  const ITreats({super.key});

  @override
  State<ITreats> createState() => _ITreatsState();
}

class _ITreatsState extends State<ITreats> {

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

    return Consumer<ITreatProvider>(
        builder: (context, provider, child) {

          return provider.isLoading() ? const ITreatShimmer() :
          Column(
            children: [
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
                        crossAxisCount: Mixin.isTab(context) ? 6 : 3, // Number of items per row
                        crossAxisSpacing: .0, // Spacing between columns
                        mainAxisSpacing: 6.0, // Spacing between rows
                        childAspectRatio: .99, // Aspect ratio of each grid item
                      ),
                      itemBuilder: (context, index) {
                        return ITreatCard(
                          treat: provider.list[index],
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
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
import 'package:winksy/provider/like_me_provider.dart';
import 'package:winksy/provider/match_provider.dart';
import 'package:winksy/screen/people/people_shimmer.dart';
import '../../../component/popup.dart';
import '../../../mixin/constants.dart';

import '../../../theme/custom_colors.dart';
import 'match_card.dart';


class IMatch extends StatefulWidget {
  const IMatch({super.key});

  @override
  State<IMatch> createState() => _IMatchState();
}

class _IMatchState extends State<IMatch> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body:
      Container(
        padding: EdgeInsets.only(top: 10.h),
        child: Consumer<IMatchProvider>(
            builder: (context, provider, child) {
              return provider.isLoading() ? const IPeopleShimmer() : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: RefreshIndicator(
                    color: color.xTrailing,
                    backgroundColor: color.xPrimaryColor,
                    onRefresh: () => provider.refresh(''),
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
                        crossAxisSpacing: .0, // Spacing between columns
                        mainAxisSpacing: 6.0, // Spacing between rows
                        childAspectRatio: .7, // Aspect ratio of each grid item
                      ),
                      itemBuilder: (context, index) {
                        return IMatchCard(
                          user: provider.list[index],
                          onRefresh: () {
                            setState(() {});
                          },
                          text: 'View Details',
                        );
                      },
                      itemCount: provider.getCount(),
                    )),
              );
            }),
      ),
    );
  }
}
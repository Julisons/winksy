import 'dart:developer';
import 'dart:ui';
//https://www.youtube.com/watch?v=_nTGniudiNg&list=RDGMEMXgf4aZ1jiRpvQxoF1ssvBg&index=5
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/model/interest.dart';
import 'package:winksy/screen/people/people.dart';
import '../../component/popup.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_colors.dart';
import '../interest/interests.dart';
import '../interest/like/like.dart';
import '../interest/match/match.dart';

class IDashboard extends StatefulWidget {
  const IDashboard({super.key});

  @override
  State<IDashboard> createState() => _IDashboardState();
}

class _IDashboardState extends State<IDashboard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin  {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {

    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    super.build(context);
    final color = Theme.of(context).extension<CustomColors>()!;

    return VisibilityDetector(
      key: const Key('IDashboard'),
      onVisibilityChanged: (visibilityInfo) {
        if ((visibilityInfo.visibleFraction * 100) > 0) {
         // Mixin.kiurator = null;
        }
      },
      child: Scaffold(
        backgroundColor: color.xPrimaryColor,
        appBar:

        AppBar(
          surfaceTintColor: color.xPrimaryColor,
          shadowColor: color.xPrimaryColor,
          bottom: TabBar(
            controller: _tabController, // Attach the TabController here
            isScrollable: false,
            tabs: [
              Tab(
                  child: Text(
                    "PLAY",
                    style: TextStyle(
                        fontSize: FONT_13,
                        fontWeight: FontWeight.bold),
                  )),
              Tab(
                  child: Text(
                    "LIKES YOU",
                    style: TextStyle(
                        fontSize: FONT_13,
                        fontWeight: FontWeight.bold),
                  )),
              Tab(
                  child: Text(
                    "MATCHES",
                    style: TextStyle(
                        fontSize: FONT_13,
                        fontWeight: FontWeight.bold),
                  )),
            ],
            labelColor: color.xTextColor,
            unselectedLabelColor: color.xTextColorTertiary,
            indicator: BoxDecoration(
              color: color.xSecondaryColor,
              borderRadius: BorderRadius.circular(30.h),

            ),
            dividerHeight: 0,
            dividerColor:  color.xTrailing,
            labelStyle: const TextStyle(overflow: TextOverflow.clip),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          automaticallyImplyLeading: false,
          title: Transform(
            transform: Matrix4.translationValues(10, 0.0, 0.0),
            child: SizedBox(
              width: 210.w,
              height: 120.h,
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Text('Play',
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
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          actions: [IPopup()],
        ),
        body:TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(), // <-- disable swipe
          children: <Widget>[
            IInterest(),
            ILike(),
            IMatch(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

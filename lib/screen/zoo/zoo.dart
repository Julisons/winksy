import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../component/popup.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import 'home/browse/browse.dart';
import 'home/home.dart';
import 'home/pet/pet.dart';
import 'home/rank/rank.dart';
import 'home/wish/wish.dart';

class IZoo extends StatefulWidget {

  @override
  _IZooState createState() =>  _IZooState();
}

class _IZooState extends State<IZoo> {
  ScrollController scrollController =  ScrollController();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: color.xPrimaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: color.xPrimaryColor,
          title: Transform(
            transform: Matrix4.translationValues(10, 0.0, 0.0),
        child: SizedBox(
            width: 310.w,
            height: 120.h,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Text('Friend Zoo',
                  style: GoogleFonts.poppins(
                    color: color.xTrailing, fontSize: FONT_APP_BAR, fontWeight: FontWeight.bold,
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
          bottom: TabBar(
            isScrollable: false,
            tabs: [
              Tab(child: Text("Home", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold))),
              Tab(child: Text("Browse", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold))),
              Tab(child: Text("Rankings", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold))),
            ],
            labelColor: color.xTextColor,
            unselectedLabelColor: color.xTextColorTertiary,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3.0, color: color.xTrailing),
            ),
            dividerHeight: 0,
            dividerColor: color.xPrimaryColor,
            labelStyle: TextStyle(overflow: TextOverflow.clip),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            IPetHome(),
            IBrowse(),
            IRank(),
          ],
        ),
      ),
    );
  }
}
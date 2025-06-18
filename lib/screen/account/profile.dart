import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../component/popup.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../component/profile_icon.dart';



class IProfile extends StatefulWidget {

  @override
  _IProfileState createState() =>  _IProfileState();
}

class _IProfileState extends State<IProfile> {
  ScrollController scrollController =  ScrollController();
  double profileCompletion = 0.75; // e.g., 75% complete

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return  DefaultTabController(
      length: 4,
      child:  Scaffold(
        backgroundColor: color.xPrimaryColor,
        appBar: AppBar(
            surfaceTintColor: color.xPrimaryColor,
            centerTitle: true,
            backgroundColor: color.xPrimaryColor,
            title: Text('',
              style: TextStyle(color: color.xTextColor, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[IPopup()]),
        body:  NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  pinned: true,
                  expandedHeight: 340.0.h,
                  floating: true,
                  surfaceTintColor: color.xPrimaryColor,
                  backgroundColor: color.xPrimaryColor,
                  forceElevated: innerBoxIsScrolled,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 340.h,
                  title: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: MediaQuery.of(context).size.width,
                    height: 340.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),
                        SizedBox(
                          height: 250.h,
                          child: ProfileProgressWidget(
                              name: '${Mixin.user?.usrFullNames}',
                              imageUrl:'${Mixin.user?.usrImage}',
                              completion: profileCompletion),
                        ),
                        SizedBox(height: 10.h),
                        /*Text('${Mixin.user?.usrFullNames}',
                          style: TextStyle(
                              color: color.xTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_APP_BAR),
                        ),*/
                        SizedBox(height: 10.h),
                        SizedBox(height: 10.h),
                        Text('${Mixin.user?.usrMobileNumber}',
                          style: TextStyle(
                              color: color.xTextColorTertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_TITLE),
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: false,
                    tabs: [
                      Tab(child: Text("Links", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                      Tab(child: Text("Folders",style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                      Tab(child: Text("Followers", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                      Tab(child: Text("Following", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                    ],
                    labelColor: color.xTextColor,
                    unselectedLabelColor: color.xTextColorTertiary,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3.0, color:  color.xTrailing,), // Line thickness and color
                    ),
                    dividerHeight: 0,
                    dividerColor: color.xPrimaryColor,
                    labelStyle: TextStyle(overflow: TextOverflow.clip),
                    indicatorSize: TabBarIndicatorSize.tab, // Indicator matches text width
                  )),
            ];
          },
          body: TabBarView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Container(),
              Container(),
              Container(),
              Container(),

             /* ILink(),
              IMyFolders(),
              IFollower(),
              IFollowing()*/
            ],
          ),
        ),
      ),
    );
  }
}
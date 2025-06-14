import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:winksy/screen/zoo/home/pet/pet.dart';
import 'package:winksy/screen/zoo/home/wish/wish.dart';

import '../../../component/popup.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/pet.dart';
import '../../../provider/pet/pet_provider.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import 'owned/owned.dart';



class IPetHome extends StatefulWidget {

  @override
  _IPetHomeState createState() =>  _IPetHomeState();
}

class _IPetHomeState extends State<IPetHome> {
  ScrollController scrollController =  ScrollController();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return  DefaultTabController(
      length: 3,
      child:  Scaffold(
        backgroundColor: color.xPrimaryColor,
        body:  NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  pinned: true,
                  expandedHeight: 300.0.h,
                  floating: true,
                  surfaceTintColor: color.xPrimaryColor,
                  backgroundColor: color.xPrimaryColor,
                  forceElevated: innerBoxIsScrolled,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 300.h,
                  title: Container(
                    margin: EdgeInsets.only(bottom: 16.h,top: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 200.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150.w,
                          width: 150.w,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            child: Mixin.user?.usrImage != null  ?
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: '${Mixin.user?.usrImage}',
                                fit: BoxFit.cover,
                                height: 150.w,
                                width: 150.w,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: color.xPrimaryColor,
                                  highlightColor: color.xPrimaryColor,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>  CircleAvatar(
                                    backgroundColor: color.xSecondaryColor,
                                    child: Icon(Icons.person, size: 50,color:color.xPrimaryColor,)),
                              ),
                            )
                                : Icon(Icons.person, size: 50,color: Theme.of(context).colorScheme.tertiary,),
                          ),
                        ),
                       // Expanded(child: SizedBox.shrink(),),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${Mixin.user?.usrFullNames}',
                                  style: TextStyle(
                                      color: color.xTextColorSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: FONT_APP_BAR),
                                ),
                                SizedBox(width: 3,),
                                Visibility(
                                  visible: true,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue, // Background color for the badge
                                    ),
                                    padding: EdgeInsets.all(2), // Padding for the circle
                                    child: Icon(
                                      Icons.verified,
                                      color: Colors.white, // Checkmark color
                                      size: 16, // Adjust size as needed
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.h),
                              width: MediaQuery.of(context).size.width/2,
                              child: Consumer<IPetProvider>(
                              builder: (context, provider, child) {

                                if (provider.isLoading()) {
                                  return Shimmer.fromColors(
                                    baseColor: color.xPrimaryColor,
                                    highlightColor: color.xPrimaryColor,
                                    child: Container(
                                      height: 20.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }

                                Pet pet = provider.getPet();
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10.h),
                                    SizedBox(height: 10.h),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('Value: ',
                                            style: TextStyle(
                                              color: color.xTextColor,
                                              fontWeight: FontWeight.normal,
                                              fontSize: FONT_TITLE,
                                            ),
                                          ),
                                          Text( '${pet.petValue} wnks',
                                            style: TextStyle(
                                              color: color.xTrailing,
                                              fontWeight: FontWeight.bold,
                                              fontSize: FONT_TITLE,
                                            ),
                                          ),
                                        ],
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Cash: ',
                                          style: TextStyle(
                                            color: color.xTextColor,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONT_TITLE,
                                          ),
                                        ),
                                        Text( '${'${pet.petCash}'.kes()} wnks',
                                          style: TextStyle(
                                            color: color.xTrailing,
                                            fontWeight: FontWeight.bold,
                                            fontSize: FONT_TITLE,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Assets: ',
                                          style: TextStyle(
                                            color: color.xTextColor,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONT_TITLE,
                                          ),
                                        ),
                                        Text( "${'${pet.petCash}'.kes()} wnks",
                                          style: TextStyle(
                                            color: color.xTrailing,
                                            fontWeight: FontWeight.bold,
                                            fontSize: FONT_TITLE,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Last Active: ',
                                          style: TextStyle(
                                            color: color.xTextColor,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONT_TITLE,
                                          ),
                                        ),
                                        Text( timeago.format(DateTime.parse(pet.petLastActiveTime)),
                                          style: TextStyle(
                                            color: color.xTrailing,
                                            fontWeight: FontWeight.bold,
                                            fontSize: FONT_TITLE,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Owned By: ',
                                          style: TextStyle(
                                            color: color.xTextColor,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONT_TITLE,
                                          ),
                                        ),
                                        Text( '${pet.usrOwner}',
                                          style: TextStyle(
                                            color: color.xTrailing,
                                            fontWeight: FontWeight.bold,
                                            fontSize: FONT_TITLE,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );}
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: false,
                    tabs: [
                      Tab(child: Text("My Pets", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                      Tab(child: Text("Recently Owned",style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                      Tab(child: Text("Wish List", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),))
                    ],
                    labelColor: color.xTextColor,
                    unselectedLabelColor: color.xTextColorTertiary,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3.0, color:  color.xSecondaryColor,), // Line thickness and color
                    ),
                    dividerHeight: 0,
                    dividerColor: color.xPrimaryColor,
                    labelStyle: TextStyle(overflow: TextOverflow.clip),
                    indicatorSize: TabBarIndicatorSize.tab,
                    // Indicator matches text width
                  )),
            ];
          },
          body: TabBarView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              IPet(),
              IOwned(),
              IWish()
            ],
          ),
        ),
      ),
    );
  }
}
extension on String {
  String kes() {
    return NumberFormat.currency(
      locale: 'en_KE',
      symbol: 'KES ',
      decimalDigits: 0, // Set to 0 decimal places
    ).format(int.parse(this));
  }
}
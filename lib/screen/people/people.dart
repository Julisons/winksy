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
import 'package:winksy/screen/people/people_card.dart';
import 'package:winksy/screen/people/people_shimmer.dart';
import '../../../mixin/constants.dart';
import '../../component/loader.dart';
import '../../component/online_status_indicator.dart';
import '../../component/popup.dart';
import '../../provider/user_provider.dart';
import '../../theme/custom_colors.dart';


class IPeople extends StatefulWidget {
  const IPeople({super.key, required this.showTitle});
  final bool showTitle;

  @override
  State<IPeople> createState() => _IPeopleState();
}

class _IPeopleState extends State<IPeople> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          Provider.of<IUsersProvider>(context, listen: false).loadMore(_searchController.text);
        }}});
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
      appBar:  widget.showTitle ? AppBar(
        surfaceTintColor: color.xPrimaryColor,
        shadowColor: color.xPrimaryColor,
        automaticallyImplyLeading: false,
        title: Transform(
          transform: Matrix4.translationValues(10, 0.0, 0.0),
          child: SizedBox(
              width: 310.w,
              height: 120.h,
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('People',
                        style: GoogleFonts.quicksand(
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
                      SizedBox(width: 12.w),
                      OnlineUsersCounter(
                        textStyle: TextStyle(
                          color: color.xTextColor,
                          fontSize: FONT_SMALL,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              )
          ),
        ),
        centerTitle: false,
        backgroundColor: color.xPrimaryColor,
        actions: [IPopup()],
      ) : null,
      backgroundColor: color.xPrimaryColor,
      body:
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 10.h),
        child:


        Consumer<IUsersProvider>(
            builder: (context, provider, child) {
              return provider.isLoading() ? const IPeopleShimmer() :
              Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                        color: color.xTrailing,
                        backgroundColor: color.xPrimaryColor,
                        onRefresh: () => provider.refresh(''),
                        child: GridView.builder(
                          controller: _scrollController,
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
                            return IPeopleCard(
                              user: provider.list[index],
                              onRefresh: () {
                                setState(() {});
                              },
                              text: 'View Details',
                            );
                          },
                          itemCount: provider.getCount(),
                        )),
                  ),

                  if(provider.isLoadingMore())
                    Container(
                      color: Colors.transparent,
                        padding: EdgeInsets.all(14.h),
                        child: Loading(dotColor: color.xTrailing))
                ],
              );
            }),
      ),
    );
  }
}
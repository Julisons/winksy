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
import 'package:winksy/provider/friend_provider.dart';
import '../../../mixin/constants.dart';
import '../../component/empty_state_widget.dart';
import '../../component/loader.dart';
import '../../component/popup.dart';
import '../../provider/friends_provider.dart';
import '../../provider/user_provider.dart';
import '../../theme/custom_colors.dart';
import 'friend_card.dart';


class IFriend extends StatefulWidget {
  const IFriend({super.key, required this.showTitle});
  final bool showTitle;

  @override
  State<IFriend> createState() => _IFriendState();
}

class _IFriendState extends State<IFriend> {
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
                  Text('People',
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


        Consumer<IFriendsProvider>(
            builder: (context, provider, child) {
              return provider.isLoading() ?

                  Center(
                    child: Loading(
                      dotColor: color.xTrailing,
                    ),
                  )

                  : provider.list.isEmpty ?
              EmptyStateWidget(
                type: EmptyStateType.users,
                showCreate: false,
                description: 'People who match with you will appear here.',
                title: 'No matches yet - keep playing!',
                onReload: () async {
                  provider.refresh('', true);
                },
              ) :
              Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                        color: color.xTrailing,
                        backgroundColor: color.xPrimaryColor,
                        onRefresh: () => provider.refresh('', true),
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
                            return IFriendCard(
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
                        padding: EdgeInsets.all(14.h),
                        child: Loading(dotColor: color.xTrailing))
                ],
              );
            }),
      ),
    );
  }
}
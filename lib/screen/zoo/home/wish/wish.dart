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
import 'package:winksy/provider/pet/owned_provider.dart';
import 'package:winksy/screen/zoo/home/pet/pet_card.dart';

import '../../../../component/empty_state_widget.dart';
import '../../../../component/loader.dart';
import '../../../../provider/pet/wish_provider.dart';
import '../../../../theme/custom_colors.dart';
import '../../../people/people_shimmer.dart';
import 'wish_card.dart';




class IWish extends StatefulWidget {
  const IWish({super.key});


  @override
  State<IWish> createState() => _IWishState();
}

class _IWishState extends State<IWish> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          Provider.of<IOwnedProvider>(context, listen: false).loadMore(_searchController.text);
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

    return  Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 10.h),
        child: Consumer<IWishProvider>(
            builder: (context, provider, child) {
              return provider.isLoading() ?
                  Center(
                    child: Loading(dotColor: color.xTrailing,),
                  )
                  : provider.list.isEmpty ?
              EmptyStateWidget(
                type: EmptyStateType.users,
                showCreate: false,
                description: 'These lovable companions are waiting for you to make a move',
                title: '🐾 Pets on Your Radar',
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
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                              bottom: 60,
                              top: 6,
                              right: 6,
                              left: 6),
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return IWishCard(
                              pet: provider.list[index],
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
      );
  }
}
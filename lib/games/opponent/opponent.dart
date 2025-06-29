import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';
import 'package:winksy/component/app_bar.dart';
import 'package:winksy/component/loader.dart';
import 'package:winksy/mixin/mixins.dart';
import 'package:winksy/provider/friends_provider.dart';
import 'package:winksy/provider/like_me_provider.dart';
import '../../../component/empty_state_widget.dart';
import '../../../component/popup.dart';
import '../../../mixin/constants.dart';
import '../../../theme/custom_colors.dart';
import '../../provider/opponents_provider.dart';
import 'opponent_card.dart';


class IOpponent extends StatefulWidget {
  const IOpponent({super.key, this.quadType =''});
  final String quadType;

  @override
  State<IOpponent> createState() => _IOpponentState();
}

class _IOpponentState extends State<IOpponent> {
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
      backgroundColor: color.xSecondaryColor,
      appBar: IAppBar(leading: true, title: 'Recent Opponents'),
      body:
      Container(
        color: color.xPrimaryColor,
        padding: EdgeInsets.only(top: 10.h),
        child: Consumer<IOpponentProvider>(
            builder: (context, provider, child) {
              return provider.isLoading() ?

                  Center(
                    child: Loading(
                      dotColor: color.xTrailing,
                    ),
                  )

                  : provider.list.isEmpty ?
              EmptyStateWidget(
                type: EmptyStateType.games,
                showCreate: false,
                description: 'Your recent opponents will show up here.',
                title: '🎮 Recent Opponents',
                onReload: () async {
                  provider.refresh('',widget.quadType, true);
                },
              ) : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: RefreshIndicator(
                    color: color.xTrailing,
                    backgroundColor: color.xPrimaryColor,
                    onRefresh: () => provider.refresh('',widget.quadType,true),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          bottom: 6,
                          top: 6,
                          right: 6,
                          left: 6),
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return IOpponentCard(
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../provider/fame_hall_provider.dart';
import '../../../theme/custom_colors.dart';
import '../../component/glow2.dart';
import '../../component/loader.dart';
import '../../mixin/constants.dart';
import 'fame_hall_card.dart';


class IQuadrixFameHall extends StatefulWidget {
  const IQuadrixFameHall({super.key, required this.quadType});
  final quadType;

  @override
  State<IQuadrixFameHall> createState() => _IQuadrixFameHallState();
}

class _IQuadrixFameHallState extends State<IQuadrixFameHall> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          Provider.of<IFameHallProvider>(context, listen: false).loadMore(_searchController.text,widget.quadType);
        }}});

    Future.delayed(Duration(seconds: 1), () {
      Provider.of<IFameHallProvider>(context, listen: false).refresh('', true,widget.quadType);
    });
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
      backgroundColor: color.xPrimaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.xSecondaryColor,
              color.xPrimaryColor,
            ],
          ),
        ),
        padding: EdgeInsets.all(10.h),
        child: Column(
          children: [
            SizedBox(height: 100.h,),
            AnimatedGlowingLetter(
              letter: 'HALL OF FAME',
              size: GAME_TITLE,
              color: color.xTrailingAlt,
              animationType: AnimationType.breathe,
            ),
            SizedBox(height: 26.h,),
            Text.rich(
              TextSpan(
                text: '🏆 Hall of Fame\n\nCelebrating the top players who have achieved the highest number of wins in ',
                style: TextStyle(fontSize: FONT_13, color: color.xTextColorSecondary, fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: '${widget.quadType}'.replaceAll('_', ' '),
                    style: TextStyle(fontSize: FONT_13, color: color.xTrailing, fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: '. Only the best make it here — play smart, climb the ranks, and earn your place among the legends!',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 26.h,),
            Flexible(
              child: Consumer<IFameHallProvider>(
                  builder: (context, provider, child) {
                    return provider.isLoading() ? Center(child: Loading(dotColor: color.xTrailing)) :
                    Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                              color: color.xTrailing,
                              backgroundColor: color.xPrimaryColor,
                              onRefresh: () => provider.refresh('',true, widget.quadType),
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.only(
                                    bottom: 6,
                                    top: 6,
                                    right: 6,
                                    left: 6),
                                scrollDirection: Axis.vertical,
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return IFameHallCard(
                                    user: provider.list[index],
                                    onRefresh: () {
                                      setState(() {});
                                    },
                                    text: 'View Details',
                                  );},
                                itemCount: provider.getCount(),
                              )),
                        ),

                        if(provider.isLoadingMore())
                          Container(
                              padding: EdgeInsets.all(14.h),
                              child: CircularProgressIndicator(color: color.xTrailing,strokeWidth: 1,))
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:winksy/provider/pet/owned_provider.dart';
import 'package:winksy/provider/pet/wish_provider.dart';
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
  _IPetHomeState createState() => _IPetHomeState();
}

class _IPetHomeState extends State<IPetHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            Provider.of<IPetProvider>(context, listen: false).refresh('', false);
            break;
          case 1:
            Provider.of<IOwnedProvider>(context, listen: false).refresh('', false);
            break;
          case 2:
            Provider.of<IWishProvider>(context, listen: false).refresh('', false);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 280.0.h,
              floating: true,
              surfaceTintColor: color.xPrimaryColor,
              backgroundColor: color.xPrimaryColor,
              forceElevated: innerBoxIsScrolled,
              automaticallyImplyLeading: false,
              toolbarHeight: 280.h,
              title: Container(
                margin: EdgeInsets.only(bottom: 16.h, top: 20),
                width: MediaQuery.of(context).size.width,
                height: 200.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150.r,
                      height: 150.r,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        child: Mixin.user?.usrImage != null
                            ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                            '${Mixin.user?.usrImage}'.startsWith('http') ? '${Mixin.user?.usrImage}' : '${IUrls.IMAGE_URL}/file/secured/${Mixin.user?.usrImage}',
                            fit: BoxFit.cover,
                            width: 150.r,
                            height: 150.r,
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
                            errorWidget: (context, url, error) => CircleAvatar(
                                backgroundColor: color.xSecondaryColor,
                                child: Icon(Icons.person, size: 50, color: color.xPrimaryColor)),
                          ),
                        )
                            : Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${Mixin.user?.usrFullNames}',
                                style: TextStyle(
                                    color: color.xTextColorSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: FONT_APP_BAR),
                              ),
                              SizedBox(width: 3),
                              Visibility(
                                visible: true,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Icon(Icons.verified, color: Colors.white, size: 16),
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: 10.h),
                              child: Consumer<IPetProvider>(builder: (context, provider, child) {
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Value:', style: TextStyle(color: color.xTextColor, fontSize: FONT_TITLE)),
                                        Text('${pet.petValue} wnks',
                                            style: TextStyle(color: color.xTrailing, fontWeight: FontWeight.bold, fontSize: FONT_TITLE)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Cash:', style: TextStyle(color: color.xTextColor, fontSize: FONT_TITLE)),
                                        Text('${'${pet.petCash}'.kes()} wnks',
                                            style: TextStyle(color: color.xTrailing, fontWeight: FontWeight.bold, fontSize: FONT_TITLE)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Assets:', style: TextStyle(color: color.xTextColor, fontSize: FONT_TITLE)),
                                        Text('${'${pet.petAssets}'.kes()} wnks',
                                            style: TextStyle(color: color.xTrailing, fontWeight: FontWeight.bold, fontSize: FONT_TITLE)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Owned By:',
                                            style: TextStyle(color: color.xTextColor, fontSize: FONT_TITLE)),
                                        Text('${pet.usrOwner}',
                                            style: TextStyle(color: color.xTrailing, fontWeight: FontWeight.bold, fontSize: FONT_TITLE)),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(child: Text("My Pets",maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONT_13))),
                    Tab(child: Text("Recently Owned",maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONT_13))),
                    Tab(child: Text("Wish List", maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONT_13))),
                  ],
                  labelColor: color.xTextColor,
                  unselectedLabelColor: color.xTextColorTertiary,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: color.xSecondaryColor),
                  ),
                  dividerColor: color.xPrimaryColor,
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            IPet(showCreate: false,),
            IOwned(),
            IWish(),
          ],
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
      decimalDigits: 0,
    ).format(int.parse(this));
  }
}
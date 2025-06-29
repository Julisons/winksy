import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:winksy/mixin/extentions.dart';
import 'package:winksy/model/user.dart';
import 'package:winksy/screen/account/photo/photo.dart';

import '../../../component/popup.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../component/profile_card.dart';
import '../../component/profile_icon.dart';
import '../../provider/friend_provider.dart';
import '../../provider/friends_provider.dart';
import '../../provider/friend_request_provider.dart';
import '../../provider/gift/gift_provider.dart';
import '../../provider/pet/pet_provider.dart';
import '../../provider/photo_provider.dart';
import '../interest/like/like.dart';
import '../notification/notification.dart';
import '../zoo/home/home.dart';
import '../zoo/home/pet/pet.dart';
import 'friend/my_friend.dart';
import 'friend/friends_with_requests.dart';
import 'info/professional_info_tab.dart';

class IProfile extends StatefulWidget {
  @override
  _IProfileState createState() => _IProfileState();
}

class _IProfileState extends State<IProfile> with TickerProviderStateMixin {
  late TabController _tabController;
  ScrollController scrollController = ScrollController();
  double profileCompletion = 0.75;
  var height = 380.h;

  @override
  void initState() {
    super.initState();

    Mixin.winkser = User()
       ..usrId = Mixin.user?.usrId;

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
        switch(_tabController.index){
          case 1:
            Provider.of<IFriendsProvider>(context, listen: false).refresh('', false);
            Provider.of<IFriendRequestProvider>(context, listen: false).refresh('', false);
            break;
          case 2:
            Provider.of<IPhotoProvider>(context, listen: false).refresh('', false);
            break;
          case 3:
            Provider.of<IPetProvider>(context, listen: false).refresh('', false);
            break;
        }
    });

    Future.delayed(Duration(seconds: 1), () {
      Provider.of<IGiftProvider>(context, listen: false).refresh('', false);
      Provider.of<IFriendsProvider>(context, listen: false).refresh('',false);
      Provider.of<IPhotoProvider>(context, listen: false).refresh('',false);
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
      appBar: AppBar(
        surfaceTintColor: color.xPrimaryColor,
        centerTitle: true,
        leading: Stack(
          children: [
            IconButton(
              icon: Padding(
                padding: EdgeInsets.only(left: 18.h),
                child: Icon(Icons.notifications_outlined,
                    size: 28.r, color: color.xTextColorSecondary),
              ),
              onPressed: () {
                Mixin.navigate(context, const INotifications());
              },
            ),
            Positioned(
              right: 0,
              top: 8,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color.xPrimaryColor,
        title: Column(
          children: [
            Text('${Mixin.user?.usrFullNames}',
                style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.w600,
                    color: color.xTextColorSecondary)),
            SizedBox(height: 4.h),
            Text('${(profileCompletion * 100).toInt()}% complete',
                style: TextStyle(fontSize: FONT_13, color: color.xTextColor)),
          ],
        ),
        actions: <Widget>[IPopup()],
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: height,
                floating: true,
                surfaceTintColor: color.xPrimaryColor,
                backgroundColor: color.xPrimaryColor,
                forceElevated: innerBoxIsScrolled,
                automaticallyImplyLeading: false,
                toolbarHeight: height,
                title: ProfileProgressWidget(
                  name: '${Mixin.user?.usrFullNames}',
                  imageUrl: '${Mixin.user?.usrImage}',
                  completion: profileCompletion,
                ),
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.person, size: 20.r),
                      child: Text("Info", style: TextStyle(fontSize: FONT_13, fontWeight: FontWeight.bold)),
                    ),
                    Tab(
                      icon: Icon(Icons.people, size: 20.r),
                      child: Text("Friends", style: TextStyle(fontSize: FONT_13, fontWeight: FontWeight.bold)),
                    ),
                    Tab(
                      icon: Icon(Icons.photo_library, size: 20.r),
                      child: Text("Photos", style: TextStyle(fontSize: FONT_13, fontWeight: FontWeight.bold)),
                    ),
                    Tab(
                      icon: Icon(Icons.pets, size: 20.r),
                      child: Text("Zoo", style: TextStyle(fontSize: FONT_13, fontWeight: FontWeight.bold)),
                    ),
                  ],
                  labelColor: color.xTextColor,
                  unselectedLabelColor: color.xTextColorTertiary,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: color.xTrailing),
                  ),
                  dividerHeight: 0,
                  dividerColor: color.xPrimaryColor,
                  labelStyle: const TextStyle(overflow: TextOverflow.clip),
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CORNER * 8),
              ),
              elevation: ELEVATION,
              color: color.xSecondaryColor,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: TabBarView(
                  controller: _tabController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    ProfessionalInfoTab(),
                    IFriendsWithRequests(),
                    IPhotos(showFab: true),
                    IPet(),
                  ],
                ),
              ),
            ),
          ),
        ),

    );
  }
}

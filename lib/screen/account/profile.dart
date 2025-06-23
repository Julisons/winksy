import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:winksy/mixin/extentions.dart';
import 'package:winksy/screen/account/photo/photo.dart';

import '../../../component/popup.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../component/profile_card.dart';
import '../../component/profile_icon.dart';
import '../../provider/friends_provider.dart';
import '../../provider/gift/gift_provider.dart';
import '../../provider/photo_provider.dart';
import '../interest/like/like.dart';
import '../notification/notification.dart';
import '../zoo/home/home.dart';
import '../zoo/home/pet/pet.dart';
import 'friend/my_friend.dart';



class IProfile extends StatefulWidget {

  @override
  _IProfileState createState() =>  _IProfileState();
}

class _IProfileState extends State<IProfile> {
  ScrollController scrollController =  ScrollController();
  double profileCompletion = 0.75; // e.g., 75% complete
  var height = 380.h;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), (){
      Provider.of<IGiftProvider>(context, listen: false).refresh('', true);
      Provider.of<IPhotoProvider>(context, listen: false).refresh('', false);
      Provider.of<IFriendsProvider>(context, listen: false).refresh('', true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: color.xPrimaryColor,
        appBar: AppBar(
            surfaceTintColor: color.xPrimaryColor,
            centerTitle: true,
            leading: Stack(
              children: [
                IconButton(
                  icon: Padding(
                    padding:  EdgeInsets.only(left: 18.h),
                    child: Icon(Icons.notifications_outlined, size : 28.r,color: color.xTextColorSecondary),
                  ),
                  onPressed: () {
                    // Handle notification tap
                    Mixin.navigate(context, const INotifications());
                  },
                ),
                Positioned(
                  right: 0,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
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
                    color: color.xTextColorSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                  Text('${(profileCompletion * 100).toInt()}% complete',
                  style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                ),
              ],
            ),
            actions: <Widget>[IPopup()]),
        body:  NestedScrollView(
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
                  title: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: MediaQuery.of(context).size.width,
                    height: 340.h,
                    padding: EdgeInsets.only(top: 8.h),
                    child:  Column(
                      children: [
                        SizedBox(
                          height: 100.h, // 50% of parent height
                          child: Consumer<IGiftProvider>(
                              builder: (context, provider, child) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: provider.getCount(),
                                  itemBuilder: (context, index) {
                                    final item = provider.list[index];
                                    return Container(
                                      width: 50.w,
                                      height: 50.w,
                                      margin: EdgeInsets.all(8),
                                      child: CachedNetworkImage(
                                        imageUrl:  item.giftPath.startsWith('http')
                                            ? item.giftPath
                                            : '${IUrls.IMAGE_URL}/file/secured/${item.giftPath}',
                                        width: 50.w,
                                        height: 50.w,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => Shimmer.fromColors(
                                          baseColor: xShimmerBase,
                                          highlightColor: xShimmerHighlight,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width/2,
                                            //  height: MediaQuery.of(context).size.width/2,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => CircleAvatar(
                                          backgroundColor: color.xSecondaryColor,
                                          child: Icon(Icons.person, size: 50, color: color.xPrimaryColor),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                        ),
                        ProfileProgressWidget(
                                  name: '${Mixin.user?.usrFullNames}',
                                  imageUrl:'${Mixin.user?.usrImage}',
                                  completion: profileCompletion),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: false,
                    tabs: [
                      Tab(child: Text("Details", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                      Tab(child: Text("Friends",style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                      Tab(child: Text("Photos",style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                      Tab(child: Text("Friend Zoo", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CORNER*8),
              ),
              elevation: ELEVATION,
              color: color.xSecondaryColor,
              child: Padding(
                padding:  EdgeInsets.all(12.r),
                child: TabBarView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(34.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileField(label: 'Name : ', value: Mixin.user?.usrFullNames ?? ''),
                            ProfileField(label: 'Email : ', value: Mixin.user?.usrEmail ?? ''),
                            ProfileField(label: 'Age : ', value: '${'${Mixin.user?.usrDob}'.age()} Years'),
                            ProfileField(label: 'Gender : ', value: '${Mixin.user?.usrGender}' ?? ''),
                            ProfileField(label: 'Phone : ', value: Mixin.user?.usrMobileNumber ?? ''),
                            ProfileField(label: 'Place : ', value: '${Mixin.user?.usrCountry}, ${Mixin.user?.usrAdministrativeArea}'),
                            ProfileField(label: 'About me : ', value:' '),
                            Text( Mixin.user?.usrDesc ??'', style: TextStyle(fontSize: FONT_13), ),
                          ],
                        ),
                      ),
                    ),
                    IMyFriend(),
                    IPhotos(showFab: true,),
                    IPet(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
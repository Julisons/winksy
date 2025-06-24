
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:winksy/mixin/extentions.dart';
import 'package:winksy/model/friend.dart';
import 'package:winksy/provider/friend_provider.dart';
import 'package:winksy/provider/gift/gift_provider.dart';
import 'package:winksy/provider/photo_provider.dart';
import 'package:winksy/screen/account/photo/photo.dart';
import 'package:winksy/screen/account/winker/treats/treats.dart';
import '../../../../mixin/constants.dart';
import '../../../../mixin/mixins.dart';
import '../../../../request/urls.dart';
import '../../../component/button.dart';
import '../../../component/popup.dart';
import '../../../component/profile_card.dart';
import '../../../games/games.dart';
import '../../../model/chat.dart';
import '../../../model/interest.dart';
import '../../../model/user.dart';
import '../../../provider/friends_provider.dart';
import '../../../provider/like_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../request/posts.dart';
import '../../../theme/custom_colors.dart';
import '../../message/message.dart';
import '../../zoo/home/pet/pet.dart';
import '../friend/my_friend.dart';

final List<ListItem> gifts = [
  ListItem(title: 'Nudge', desc: '', icon: FaIcon(FontAwesomeIcons.handPointLeft)),
  ListItem(title: 'Message', desc: '', icon: FaIcon(FontAwesomeIcons.envelope)),
  ListItem(title: 'Gift', desc: '', icon: FaIcon(FontAwesomeIcons.gift)),
];

class IWinkser extends StatefulWidget {

  @override
  _IWinkserState createState() =>  _IWinkserState();
}

class _IWinkserState extends State<IWinkser> {
  User? user;
  bool light = true;
  Chat chat = Chat();
  late Friend _friend;
  var height = 480.h;
  bool isVerified = true;
  var _isLoading = false;
  ScrollController scrollController =  ScrollController();

  @override
  void initState() {
    super.initState();

     chat = Chat()
      ..chatReceiverId = Mixin.winkser?.usrId
      ..chatSenderId = Mixin.user?.usrId
      ..usrReceiver = Mixin.winkser?.usrFullNames;

    Future.delayed(Duration(seconds: 1), () {
      Provider.of<IGiftProvider>(context, listen: false).refresh('', true);
      Provider.of<IFriendProvider>(context, listen: false).refresh('',true);
      Provider.of<IFriendsProvider>(context, listen: false).refresh('',true);
      Provider.of<IPhotoProvider>(context, listen: false).refresh('',false);
    });
  }

  @override
  Widget build(BuildContext context) {

    final color = Theme.of(context).extension<CustomColors>()!;

    return  AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: color.xPrimaryColor, // or Colors.transparent
        statusBarIconBrightness: Brightness.dark, // 👈 black icons
        statusBarBrightness: Brightness.light, // for iOS
      ),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: color.xPrimaryColor,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon:  Icon(Icons.arrow_back_ios_new_rounded, color: color.xTrailing,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              surfaceTintColor: color.xPrimaryColor,
              centerTitle: true,
              iconTheme: IconThemeData(color: color.xTrailing),
              backgroundColor: Colors.transparent,
              title:
                Text('${Mixin.winkser?.usrFullNames}   ',
                style: TextStyle(color: color.xTextColor, fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[IPopup()]),
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
                    toolbarHeight: height,
                    automaticallyImplyLeading: false,
                    title: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 16.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          Stack(
                            children: [
                              Mixin.winkser?.usrImage != null
                                  ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: '${Mixin.winkser?.usrImage}'.startsWith('http') ?Mixin.winkser?.usrImage
                                      : '${IUrls.IMAGE_URL}/file/secured/${Mixin.winkser?.usrImage}',
                                  fit: BoxFit.cover,
                                  height: 150.w,
                                  width: 150.w,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                        baseColor: color.xSecondaryColor,
                                        highlightColor: color.xSecondaryColor,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.0),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          backgroundColor: color.xSecondaryColor,
                                          child: Icon(Icons.person, size: 50,color:color.xPrimaryColor)),
                                ),
                              ) : Icon(Icons.person, size: 50, color: color.xPrimaryColor,),
                              Positioned(
                                right: 30,
                                bottom: 3.r,
                                child: Container(
                                  width: 15.r,
                                  height: 15.r,
                                  decoration: BoxDecoration(
                                    color: Colors.green, // Online indicator color
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1), // Border to match avatar
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h,),
                          if (isVerified)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.verified, color: color.xTrailingAlt, size: 20.r),
                                SizedBox(width: 6.w),
                                Text(
                                  "Verified profile",
                                  style: TextStyle(
                                    color: color.xTextColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 20.h,),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:List.generate(gifts.length, (index) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 12.0.r,right: 12.0.r),
                                    child: FloatingActionButton(
                                      elevation: ELEVATION,
                                      mini: false,
                                      tooltip: gifts[index].title,
                                      backgroundColor: color.xTrailing,
                                      onPressed: () {
                                        if (gifts[index].title == 'Message') {
                                          Chat chat = Chat()
                                            ..chatReceiverId = Mixin.winkser?.usrId
                                            ..chatSenderId = Mixin.user?.usrId
                                            ..chatCreatedBy = Mixin.user?.usrId
                                            ..usrReceiver = Mixin.winkser?.usrFullNames;
                                          Mixin.navigate(context,  IMessage(chat: chat, showTitle: true,));
                                        } else if (gifts[index].title == 'Nudge') {

                                        } else if (gifts[index].title == 'Gift') {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: 200,
                                                child:  ITreats(),
                                              );
                                            },
                                          );
                                        }
                                       },
                                      child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          if (gifts[index].title == 'Message') {
                                            Chat chat = Chat()
                                              ..chatReceiverId = Mixin.winkser?.usrId
                                              ..chatSenderId = Mixin.user?.usrId
                                              ..chatCreatedBy = Mixin.user?.usrId
                                              ..usrReceiver = Mixin.winkser?.usrFullNames;
                                            Mixin.navigate(context,  IMessage(chat: chat, showTitle: true,));
                                          } else if (gifts[index].title == 'Nudge') {

                                          } else if (gifts[index].title == 'Gift') {
                                            showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: MediaQuery.of(context).size.height/1.2,
                                                  width: MediaQuery.of(context).size.width,
                                                  child:  ITreats(),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        icon: gifts[index].icon,
                                        iconSize: 24.r,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(height: 20.h,),
                              Consumer<IFriendProvider>(
                                  builder: (context, provider, child) {
                                    return _isLoading ? Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).colorScheme.tertiary,
                                      )):
                                    SizedBox(
                                      height: 40.h,
                                      width: 156.h,
                                      child: FloatingActionButton.extended(
                                        elevation: ELEVATION,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(136.r),
                                        ),
                                        backgroundColor: provider.getCount() > 0 ? color.xSecondaryColor : color.xTrailing,
                                        onPressed: (){

                                          setState(() {_isLoading = true;});

                                          _friend = Friend()
                                            ..frndUsrId = Mixin.user?.usrId
                                            ..frndFolId = Mixin.winkser?.usrId
                                            ..frndDesc = 'Liked ${Mixin.winkser?.usrFullNames}'
                                            ..frndStatus = 'Requested'
                                            ..frndCode = 'LIKE'
                                            ..frndInstId = Mixin.user?.usrInstId
                                            ..frndType = 'USER';

                                          IPost.postData(_friend, (state, res, value) {setState(() {
                                            if (state) {
                                              setState(() {_isLoading = false;});
                                              Provider.of<IFriendProvider>(context, listen: false).refresh('', false);
                                            } else {Mixin.errorDialog(context, 'ERROR', res);
                                            }});}, IUrls.FRIEND());

                                        },
                                        label: Text(provider.getCount() > 0 ? provider.list[0].frndStatus : 'Add Friend',
                                        style: TextStyle(fontSize: FONT_13, color:provider.getCount() > 0 ? color.xTextColor : Colors.white)),
                                        icon: IconButton(
                                          color: provider.getCount() > 0 ? color.xTextColor : Colors.white,
                                          onPressed: () {

                                          },
                                          icon: FaIcon(provider.getCount() > 0 ? FontAwesomeIcons.userCheck : FontAwesomeIcons.userPlus),
                                          iconSize: 20.r,
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(child: Text("Details", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                        Tab(child: Text("Photos",style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                        Tab(child: Text("Friends",style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                        Tab(child: Text("Friend Zoo", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),))
                      ],
                      labelColor: color.xTextColor,
                      unselectedLabelColor: color.xTextColorTertiary,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 3.0, color: color.xTrailing, style: BorderStyle.solid),
                      ),
                      dividerHeight: 0,
                      dividerColor: color.xPrimaryColor,
                      labelStyle: TextStyle(overflow: TextOverflow.visible),
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
                      Container(
                        padding: EdgeInsets.all(34.h),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileField(label: 'Name : ', value: Mixin.winkser?.usrFullNames ?? ''),
                              ProfileField(label: 'Email : ', value: Mixin.winkser?.usrEmail ?? ''),
                              ProfileField(label: 'Age : ', value: '${'${Mixin.winkser?.usrDob}'.age()} Years'),
                              ProfileField(label: 'Gender : ', value: '${Mixin.winkser?.usrGender}' ?? ''),
                              ProfileField(label: 'Phone : ', value: Mixin.winkser?.usrMobileNumber ?? ''),
                              ProfileField(label: 'Place : ', value: '${Mixin.winkser?.usrCountry}, ${Mixin.winkser?.usrAdministrativeArea}'),
                              ProfileField(label: 'Bio : ', value:' '),
                              Text( Mixin.winkser?.usrDesc ??'', style: TextStyle(fontSize: FONT_13, color: color.xTextColorSecondary), ),
                            ],
                          ),
                        ),
                      ),

                      IPhotos(showFab: false,),
                      IMyFriend(),
                      IPet(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
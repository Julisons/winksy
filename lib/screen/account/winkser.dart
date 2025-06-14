
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../request/urls.dart';
import '../../component/button.dart';
import '../../component/popup.dart';
import '../../model/chat.dart';
import '../../model/interest.dart';
import '../../model/user.dart';
import '../../provider/like_provider.dart';
import '../../provider/user_provider.dart';
import '../../request/posts.dart';
import '../../theme/custom_colors.dart';
import '../message/message.dart';


class IWinkser extends StatefulWidget {

  @override
  _IWinkserState createState() =>  _IWinkserState();
}

class _IWinkserState extends State<IWinkser> {
  User? user;
  bool light = true;
  Chat chat = Chat();
  late Interest _interest;

  var _isLoading = false;
  ScrollController scrollController =  ScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<ILikeProvider>(context, listen: false).refresh('');
     chat = Chat()
      ..chatReceiverId = Mixin.winkser?.usrId
      ..chatSenderId = Mixin.user?.usrId
      ..usrReceiver = Mixin.winkser?.usrFullNames;
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
        length: 3,
        child: Scaffold(
          backgroundColor: color.xPrimaryColor,
          appBar: AppBar(
              surfaceTintColor: color.xPrimaryColor,
              centerTitle: true,
              iconTheme: IconThemeData(color: color.xTrailing),
              backgroundColor: Colors.transparent,
              title: Text('${Mixin.winkser?.usrFullNames}',
                style: TextStyle(color: color.xTextColor, fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[IPopup()]),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    pinned: true,
                    expandedHeight: 340.0.h,
                    floating: true,
                    surfaceTintColor: color.xPrimaryColor,
                    backgroundColor: color.xPrimaryColor,
                    forceElevated: innerBoxIsScrolled,
                    toolbarHeight: 540.h,
                    automaticallyImplyLeading: false,
                    title: Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      width: MediaQuery.of(context).size.width,
                      height:540.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Mixin.winkser?.usrImage != null
                              ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: '${Mixin.winkser?.usrImage.toString()}',
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
                              )
                              : Icon(Icons.person, size: 50, color: color.xPrimaryColor,),
                          SizedBox(
                            height: 40.h,
                          ),
                          Consumer<ILikeProvider>(
                              builder: (context, provider, child) {
                                return _isLoading ? Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).colorScheme.tertiary,
                                  ),) : IButton(
                                  onPress: () {
                                    setState(() {_isLoading = true;});
                                      _interest = Interest()
                                        ..intUsrId = Mixin.user?.usrId
                                        ..intFolId = Mixin.winkser?.usrId
                                        ..intDesc = 'Liked ${Mixin.winkser?.usrFullNames}'
                                        ..intStatus = 'ACTIVE'
                                        ..intCode = 'LIKE'
                                        ..intInstId = Mixin.user?.usrInstId
                                        ..intType = 'USER';

                                      IPost.postData(_interest, (state, res, value) {setState(() {
                                      if (state) {
                                        setState(() {_isLoading = false;});
                                        Provider.of<ILikeProvider>(context, listen: false).refresh('');
                                      } else {Mixin.errorDialog(context, 'ERROR', res);
                                      }});}, IUrls.INTEREST());
                                  },
                                  isBlack: false,
                                  text: provider.getCount() > 0 ? 'Liked' : 'Like',
                                  color: provider.getCount() > 0 ? color.xSecondaryColor : color.xTrailing,
                                  textColor: provider.getCount() > 0 ? color.xTextColor : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  width: 140,
                                  height: 35,
                                );
                              }),
                        ],
                      ),
                    ),
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(child: Text("Details", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                        Tab(child: Text("Zoo", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
                        Tab(child: Text("Messages", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold),)),
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
            body: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CORNER*8),
              ),
              elevation: ELEVATION,
              color: color.xSecondaryColor,
              child: TabBarView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  Container(),
                  Container(),
                  IMessage(chat: chat, showTitle: false,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
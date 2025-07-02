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
import 'package:winksy/provider/pet/pet_provider.dart';
import 'package:winksy/provider/photo_provider.dart';
import 'package:winksy/screen/account/photo/photo.dart';
import 'package:winksy/screen/account/winker/treats/treats.dart';
import 'package:winksy/screen/account/winker/nudges/nudges.dart';
import 'package:winksy/screen/account/winker/winker_info_tab.dart';
import '../../../../mixin/constants.dart';
import '../../../../mixin/mixins.dart';
import '../../../../request/urls.dart';
import '../../../component/button.dart';
import '../../../component/loader.dart';
import '../../../component/online_status_indicator.dart';
import '../../../component/popup.dart';
import '../../../component/profile_card.dart';
import '../../../games/games.dart';
import '../../../model/chat.dart';
import '../../../model/interest.dart';
import '../../../model/user.dart';
import '../../../provider/friends_provider.dart';
import '../../../provider/like_provider.dart';
import '../../../provider/nudge/nudge_sound_provider.dart';
import '../../../provider/user/online_status_provider.dart';
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
  _IWinkserState createState() => _IWinkserState();
}

class _IWinkserState extends State<IWinkser> with SingleTickerProviderStateMixin {
  User? user;
  bool light = true;
  Chat chat = Chat();
  late Friend _friend;
  var height = 480.h;
  bool isVerified = true;
  var _isLoading = false;
  ScrollController scrollController = ScrollController();
  late TabController _tabController;

  // Add Navigator reference for safe async operations
  NavigatorState? _navigator;
  BuildContext? _currentContext;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);

    chat = Chat()
      ..chatReceiverId = Mixin.winkser?.usrId
      ..chatSenderId = Mixin.user?.usrId
      ..usrReceiver = Mixin.winkser?.usrFullNames;

    _refreshInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store navigator reference for safe async operations
    _navigator = Navigator.of(context);
    _currentContext = context;
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;

    switch (_tabController.index) {
      case 1: // Photos tab
        Provider.of<IPhotoProvider>(context, listen: false).refresh('',false);
        break;
      case 2: // Friends tab
        Provider.of<IFriendsProvider>(context, listen: false).refresh('',true);
        break;
      case 3: // Friend Zoo tab
        Provider.of<IPetProvider>(context, listen: false).refresh('',true);
        break;
    }
  }

  void _refreshInitialData() {
    // Check if mounted before proceeding with async operations
    if (!mounted) return;

    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;

      Provider.of<IGiftProvider>(context, listen: false).refresh('', true);
      Provider.of<IFriendProvider>(context, listen: false).refresh('',true);
      Provider.of<IFriendsProvider>(context, listen: false).refresh('',true);
      Provider.of<IPhotoProvider>(context, listen: false).refresh('',false);
      Provider.of<INudgeSoundProvider>(context, listen: false).refresh('',true);

      // Get online status for this user
      if (Mixin.winkser?.usrId != null) {
        Provider.of<OnlineStatusProvider>(context, listen: false).requestUserStatus(Mixin.winkser!.usrId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // Safe navigation helper method
  void _safeNavigate(Widget page) {
    if (mounted && _currentContext != null) {
      Mixin.navigate(_currentContext!, page);
    }
  }

  // Safe modal bottom sheet helper method
  void _safeShowModalBottomSheet({required Widget child, double? height}) {
    if (mounted && _currentContext != null) {
      showModalBottomSheet<void>(
        context: _currentContext!,
        builder: (BuildContext context) {
          return SizedBox(
            height: height ?? MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            child: child,
          );
        },
      );
    }
  }

  void _handleActionPress(String action) {
    switch (action) {
      case 'Message':
        Chat chat = Chat()
          ..chatReceiverId = Mixin.winkser?.usrId
          ..chatSenderId = Mixin.user?.usrId
          ..chatCreatedBy = Mixin.user?.usrId
          ..usrReceiver = Mixin.winkser?.usrFullNames;
        _safeNavigate(IMessage(chat: chat, showTitle: true));
        break;
      case 'Nudge':
        _safeShowModalBottomSheet(child: INudges());
        break;
      case 'Gift':
        _safeShowModalBottomSheet(child: ITreats(), height: MediaQuery.of(context).size.height / 1.2);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    // Update current context reference
    _currentContext = context;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: color.xPrimaryColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: color.xPrimaryColor,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: color.xTrailing,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            surfaceTintColor: color.xPrimaryColor,
            centerTitle: true,
            iconTheme: IconThemeData(color: color.xTrailing),
            backgroundColor: Colors.transparent,
            title: Text('${Mixin.winkser?.usrFullNames}   ',
              style: TextStyle(color: color.xTextColor, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),
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
                          height: 100.h,
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
                                        imageUrl: item.giftPath.startsWith('http')
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
                                ? GestureDetector(
                              onTap: () => _showImagePopup(context),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: '${Mixin.winkser?.usrImage}'.startsWith('http')
                                      ? Mixin.winkser?.usrImage ?? ''
                                      : '${IUrls.IMAGE_URL}/file/secured/${Mixin.winkser?.usrImage}',
                                  fit: BoxFit.cover,
                                  height: 150.w,
                                  width: 150.w,
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          backgroundColor: color.xSecondaryColor,
                                          child: Icon(Icons.person, size: 50,color:color.xPrimaryColor)),
                                ),
                              ),
                            ) : Icon(Icons.person, size: 50, color: color.xPrimaryColor,),
                            Positioned(
                              right: 25,
                              bottom: 3.r,
                              child: OnlineStatusIndicator(
                                userId: Mixin.winkser?.usrId,
                                size: 15.0,
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
                        SizedBox(height: 6.h),
                        OnlineStatusIndicator(
                          userId: Mixin.winkser?.usrId,
                          size: 16.0,
                          showText: true,
                        ),
                        SizedBox(height: 16.h,),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(gifts.length, (index) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 12.0.r,right: 12.0.r),
                                  child: SizedBox(
                                    height: 45.h,
                                    width: 45.h,
                                    child: FloatingActionButton(
                                      elevation: ELEVATION,
                                      mini: false,
                                      tooltip: gifts[index].title,
                                      backgroundColor: color.xTrailing,
                                      onPressed: () => _handleActionPress(gifts[index].title),
                                      child: IconButton(
                                        color: Colors.white,
                                        onPressed: () => _handleActionPress(gifts[index].title),
                                        icon: gifts[index].icon,
                                        iconSize: 20.r,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 20.h,),
                            Consumer<IFriendProvider>(
                                builder: (context, provider, child) {
                                  return _isLoading ? Center(
                                      child: Loading(
                                        dotColor: color.xTrailing,)) :
                                  SizedBox(
                                    height: 40.h,
                                    width: 149.w,
                                    child: FloatingActionButton.extended(
                                      elevation: ELEVATION,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(136.r),
                                      ),
                                      backgroundColor: provider.getCount() > 0 ? color.xSecondaryColor : color.xTrailing,
                                      onPressed: () => _handleFriendAction(provider),
                                      label: SizedBox(
                                        width: 100.h,
                                        child: Text(
                                            textAlign: TextAlign.start,
                                            provider.getCount() > 0 ? provider.list[0].frndStatus : 'Add Friend',
                                            style: TextStyle(fontSize: FONT_13,
                                                color:provider.getCount() > 0 ? color.xTextColor : Colors.white)),
                                      ),
                                      icon: Padding(
                                        padding: EdgeInsets.only(left: 20.h),
                                        child: IconButton(
                                          color: provider.getCount() > 0 ? color.xTextColor : Colors.white,
                                          onPressed: () {},
                                          icon: FaIcon(provider.getCount() > 0 ? FontAwesomeIcons.userCheck : FontAwesomeIcons.userPlus),
                                          iconSize: 20.r,
                                        ),
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
                    controller: _tabController,
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
                    indicatorSize: TabBarIndicatorSize.tab,
                  )),
            ];
          },
          body: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(CORNER),
            ),
            elevation: ELEVATION,
            color: color.xSecondaryColor,
            margin: EdgeInsets.all(16.r),
            child: TabBarView(
              controller: _tabController,
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                WinkerInfoTab(),
                IPhotos(showFab: false,),
                IMyFriend(),
                IPet(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleFriendAction(IFriendProvider provider) {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    _friend = Friend()
      ..frndUsrId = Mixin.user?.usrId
      ..frndFolId = Mixin.winkser?.usrId
      ..frndDesc = 'Liked ${Mixin.winkser?.usrFullNames}'
      ..frndStatus = 'FRIENDS'
      ..frndCode = 'LIKE'
      ..frndInstId = Mixin.user?.usrInstId
      ..frndType = 'USER';

    IPost.postData(_friend, (state, res, value) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        if (state) {
          Provider.of<IFriendProvider>(context, listen: false).refresh('', false);
        } else {
          if (mounted) {
            Mixin.errorDialog(context, 'ERROR', res);
          }
        }
      });
    }, IUrls.FRIEND());
  }

  void _showImagePopup(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Profile Photo Viewer',
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          )),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              )),
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background glass effect
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.xPrimaryColor.withOpacity(0.1),
                            color.xSecondaryColor.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    // Main image container
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height * 0.8,
                      padding: EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: '${Mixin.winkser?.usrImage}'.startsWith('http')
                                ? Mixin.winkser?.usrImage ?? ''
                                : '${IUrls.IMAGE_URL}/file/secured/${Mixin.winkser?.usrImage}',
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    color.xPrimaryColor.withOpacity(0.8),
                                    color.xSecondaryColor.withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(color.xTrailing),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Loading profile photo...',
                                      style: TextStyle(
                                        color: color.xTextColorSecondary,
                                        fontSize: FONT_13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    color.xPrimaryColor.withOpacity(0.8),
                                    Colors.red.withOpacity(0.3),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: color.xTextColor,
                                        size: 50,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Failed to load profile photo',
                                      style: TextStyle(
                                        color: color.xTextColor,
                                        fontSize: FONT_13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Enhanced close button
                    Positioned(
                      top: 30,
                      right: 30,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    // Profile info overlay
                    Positioned(
                      bottom: 30,
                      left: 30,
                      right: 30,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${Mixin.winkser?.usrFullNames}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: FONT_13,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Online',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
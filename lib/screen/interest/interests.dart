
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:winksy/component/glass_coat.dart';
import 'package:winksy/mixin/extentions.dart';
import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../component/popup.dart';
import '../../mixin/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../model/chat.dart';
import '../../model/interest.dart';
import '../../model/user.dart';
import '../../provider/interest_provider.dart';
import '../../provider/user_provider.dart';
import '../../request/posts.dart';
import '../../request/urls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/custom_colors.dart';
import '../message/message.dart';
import '../splash/splash_screen.dart';

class IInterest extends StatefulWidget {
  const IInterest({super.key});

  @override
  State<IInterest> createState() => _IInterestState();
}

class _IInterestState extends State<IInterest> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  final CardSwiperController _cardController = CardSwiperController();
  late final CurvedAnimation _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  late User _user;
  late  Chat chat;
  late var _currentIndex = 0;
  late Interest _interest;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      body: Container(
        padding: EdgeInsets.only(top: 10.h),
        child: Consumer<IInterestProvider>(builder: (context, provider, child) {

          return provider.isLoading()
              ? Center(
                  child: FadeTransition(
                    opacity: _animation,
                    child: Transform(
                        transform: Matrix4.translationValues(10, 0.0, 0.0),
                        child: Icon(
                          Icons.favorite,
                          color: color.xTrailing,
                          size: 250,
                        )),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Flexible(
                        child: CardSwiper(
                            controller: _cardController,
                            onSwipe: _onSwipe,
                            onUndo: _onUndo,
                            numberOfCardsDisplayed: 3,
                            backCardOffset: const Offset(40, 40),
                            padding: const EdgeInsets.all(24.0),
                            cardsCount: provider.list.length,
                            cardBuilder: (context, index, percentThresholdX,
                                percentThresholdY) {
                               _user = provider.list[index];
                              return Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      16), // Rounded corners for the card
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners for the image
                                      child: CachedNetworkImage(
                                        imageUrl: '${_user.usrImage}'.startsWith('http') ? _user.usrImage
                                            : '${IUrls.IMAGE_URL}/file/secured/${_user.usrImage}',
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: xShimmerBase,
                                          highlightColor: xShimmerHighlight,
                                          child: Container(
                                            width: 140.0,
                                            height: 140.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          backgroundColor: color.xSecondaryColor,
                                          child: Icon(Icons.person,
                                              size: 50, color: color.xPrimaryColor),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      child: GlassCoat(
                                        borderRadius: CORNER,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("${_user.usrFirstName}, ${'${_user.usrDob}'.age()}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: FONT_TITLE,
                                                    shadows: [
                                                      Shadow(
                                                          offset: Offset(0, 1),
                                                          blurRadius: 1.0,
                                                          color: Colors.black
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 3,),
                                                Visibility(
                                                  visible: true,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.blue, // Background color for the badge
                                                    ),
                                                    padding: EdgeInsets.all(2), // Padding for the circle
                                                    child: Icon(
                                                      Icons.verified,
                                                      color: Colors.white, // Checkmark color
                                                      size: 16, // Adjust size as needed
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                             Text((_user.usrDistance == null || _user.usrDistance.isEmpty
                                                  ? '${_user.usrLocality}'
                                                  : '${_user.usrDistance} (${_user.usrLocality})').replaceAll("null", ''),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: FONT_13,
                                                shadows: [
                                                  Shadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 10.0,
                                                      color: Colors.black
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              elevation: 12,
                              backgroundColor: color.xTrailing,
                              shape: const CircleBorder(), // Ensures circular shape
                              onPressed: () => _cardController
                                  .swipe(CardSwiperDirection.left),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 66.h,
                            ),
                            FloatingActionButton(
                              elevation: 12,
                              backgroundColor: Colors.blue,
                              shape:
                              const CircleBorder(), // Ensures circular shape
                              onPressed: () => {
                                Mixin.winkser = provider.list[_currentIndex],
                                 chat = Chat()
                                ..chatSenderId = Mixin.user?.usrId
                                ..chatReceiverId = Mixin.winkser?.usrId
                                ..usrReceiver = Mixin.winkser?.usrFullNames,
                                Mixin.navigate(context,  IMessage(chat: chat, showTitle: true,))
                              },
                              child: const Icon(
                                Icons.question_answer_outlined,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(width: 66.h,),
                            FloatingActionButton(
                              elevation: 12,
                              backgroundColor: xGreenPrimary,
                              shape: const CircleBorder(), // Ensures circular shape
                              onPressed: () => {
                                _cardController.swipe(CardSwiperDirection.right),
                                _like()
                              },
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  void _like(){
    _user =  Provider.of<IInterestProvider>(context, listen: false).list[_currentIndex];
    _interest = Interest()
    ..intUsrId = Mixin.user?.usrId
    ..intFolId = _user.usrId
    ..intDesc = 'Liked ${_user.usrFullNames}'
    ..intStatus = 'ACTIVE'
    ..intCode = 'LIKE'
    ..intInstId = _user.usrInstId
    ..intType = 'USER';

    IPost.postData(_interest, (state, res, value) {setState(() {
    if (state) {
    } else {Mixin.errorDialog(context, 'ERROR', res);
    }});}, IUrls.INTEREST());
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction) {
    _currentIndex = previousIndex;
    debugPrint('The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',);

    if(direction.name == 'right'){
      _like();
    }
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction) {
    _currentIndex = currentIndex;
    debugPrint('The card $currentIndex was undod from the ${direction.name}',);
    return true;
  }
}

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:winksy/mixin/extentions.dart';
import 'package:winksy/provider/pet/browse_provider.dart';
import 'package:winksy/provider/pet/owned_provider.dart';
import 'package:winksy/screen/message/chat/chat.dart';
import 'package:winksy/screen/zoo/home/home.dart';

import '../../../../component/button.dart';
import '../../../../component/loader.dart';
import '../../../../component/online_status_indicator.dart';
import '../../../../mixin/constants.dart';
import '../../../../mixin/mixins.dart';
import '../../../../model/pet.dart';
import '../../../../model/transaction.dart';
import '../../../../model/user.dart';
import '../../../../model/wish.dart';
import '../../../../request/posts.dart';
import '../../../../request/urls.dart';
import '../../../../theme/custom_colors.dart';
import '../../../account/winker/winker.dart';


class IBrowseCard extends StatefulWidget {
  const IBrowseCard({super.key, required this.pet, required this.onRefresh, required this.text});
  final Pet pet;
  final VoidCallback onRefresh;
  final String text;


  @override
  State<IBrowseCard> createState() => _IBrowseCardState();
}

class _IBrowseCardState extends State<IBrowseCard> {
  bool _isLoading = false;
  late Transaction _transaction;
  late Wish _wish;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return InkWell(
      onTap: () {
        Mixin.winkser = User.fromJson(widget.pet.toJson());
        log("Winkser: ${Mixin.winkser?.usrId}");
        Mixin.navigate(context, IWinkser());
      },
      child: Card(
        elevation: ELEVATION,
        color: color.xSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(CORNER)) ,
        ),
        child: Row(
          children: [
            SizedBox(width: 3,),
            OnlineStatusBadge(
              userId: widget.pet.usrId,
              badgeSize: 16.0,
              alignment: Alignment.topRight,
              child: ClipOval(
                child: InkWell(
                  onTap: () {
                    Mixin.winkser = User.fromJson(widget.pet.toJson());
                    log("Winkser: ${Mixin.winkser?.usrId}");
                    Mixin.navigate(context, IWinkser());
                  },
                  child: CachedNetworkImage(
                    imageUrl: '${widget.pet.usrImage}'.startsWith('http') ? widget.pet.usrImage
                        : '${IUrls.IMAGE_URL}/file/secured/${widget.pet.usrImage}',
                    width: 150.h,
                    height: 150.h,
                    fit: BoxFit.fitHeight,
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
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20,top: 8,right: 8,bottom: 8),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.pet.usrFullNames}",
                          style: TextStyle(
                            color: color.xTextColorSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_13,
                          ),
                        ),
                        SizedBox(width: 3,),
                        Flexible(
                          child: Visibility(
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
                                size: 10.r, // Adjust size as needed
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Value: ',
                          style: TextStyle(
                            color: color.xTextColor,
                            fontWeight: FontWeight.normal,
                            fontSize: FONT_13,
                          ),
                        ),
                        Text( '${widget.pet.petValue} wnks',
                          style: TextStyle(
                            color: color.xTrailing,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Cash: ',
                          style: TextStyle(
                            color: color.xTextColor,
                            fontWeight: FontWeight.normal,
                            fontSize: FONT_13,
                          ),
                        ),
                        Flexible(
                          child: Text( '${'${widget.pet.petCash}'.kes()} wnks',
                            style: TextStyle(
                              color: color.xTrailing,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assets: ',
                          style: TextStyle(
                            color: color.xTextColor,
                            fontWeight: FontWeight.normal,
                            fontSize: FONT_13,
                          ),
                        ),
                        Flexible(
                          child: Text( "${'${widget.pet.petAssets}'.kes()} wnks",
                            style: TextStyle(
                              color: color.xTrailing,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Last Seen: ',
                          style: TextStyle(
                            color: color.xTextColor,
                            fontWeight: FontWeight.normal,
                            fontSize: FONT_13,
                          ),
                        ),
                        Text(widget.pet.usrLastSeen != null 
                            ? timeago.format(DateTime.parse(widget.pet.usrLastSeen))
                            : 'Never',
                          style: TextStyle(
                            color: color.xTrailing,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Owned By: ',
                          style: TextStyle(
                            color: color.xTextColor,
                            fontWeight: FontWeight.normal,
                            fontSize: FONT_13,
                          ),
                        ),
                        Text( '${widget.pet.usrOwner}',
                          style: TextStyle(
                            color: color.xTrailing,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    _isLoading ? SizedBox(
                      width: 120.w,
                      height: 40.h,
                      child: Center(
                          child: Loading(
                              dotColor: color.xTrailing)),
                    )
                        :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '${widget.pet.wishUsrId}' != Mixin.user?.usrId.toString() ?
                        Flexible(
                          child: IButton(
                            onPress: () {
                              setState(() {_isLoading = true;});
                              _wish = Wish()
                                ..wishPetId = widget.pet.usrId
                                ..wishUsrId = Mixin.user?.usrId;

                              IPost.postData(_wish, (state, res, value) {setState(() {
                                setState(() {_isLoading = false;});
                                  if (state) {
                                    Mixin.showToast(context, res, INFO);
                                    Provider.of<IBrowseProvider>(context, listen: false).refresh('', false);
                                  } else {
                                    Mixin.errorDialog(context, 'ERROR', res);
                                  }
                              });}, IUrls.WISH());
                            },
                            isBlack: false,
                            text: 'Add to wishlist',
                            color:  color.xPrimaryColor,
                            textColor:  color.xTextColor,
                            fontWeight: FontWeight.normal,
                            width: 121.w,
                            height: 35.h,
                            font: FONT_13,
                          ),
                        ) : SizedBox.shrink(),

                      Flexible(
                        child: IButton(
                          onPress: () {
                            setState(() {_isLoading = true;});
                            _transaction = Transaction()
                            ..txnPetUsrId = widget.pet.usrId
                            ..txnBuyerUsrId = Mixin.user?.usrId
                            ..txnAmount = widget.pet.petValue;

                            IPost.postData(_transaction, (state, res, value) {setState(() {
                              setState(() {_isLoading = false;});
                                if (state) {
                                  Mixin.showToast(context, res, INFO);
                                  Provider.of<IBrowseProvider>(context, listen: false).refresh('', false);
                                } else {
                                  Mixin.info(context, 'INFO', res);
                                }
                            });}, IUrls.TRANSACTION());
                          },
                          isBlack: false,
                          text: 'Buy Now',
                          color:  color.xTrailing,
                          textColor:  Colors.white,
                          fontWeight: FontWeight.normal,
                          width: 120.w,
                          height: 35.h,
                          font: FONT_13,
                        ),
                      )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

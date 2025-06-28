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
import 'package:winksy/provider/pet/owned_provider.dart';
import 'package:winksy/provider/pet/wish_provider.dart';
import 'package:winksy/screen/message/chat/chat.dart';

import '../../../../component/button.dart';
import '../../../../component/loader.dart';
import '../../../../mixin/constants.dart';
import '../../../../mixin/mixins.dart';
import '../../../../model/pet.dart';
import '../../../../model/transaction.dart';
import '../../../../model/wish.dart';
import '../../../../request/posts.dart';
import '../../../../request/urls.dart';
import '../../../../theme/custom_colors.dart';


class IRankCard extends StatefulWidget {
  const IRankCard({super.key, required this.pet, required this.onRefresh, required this.text});
  final Pet pet;
  final VoidCallback onRefresh;
  final String text;


  @override
  State<IRankCard> createState() => _IRankCardState();
}

class _IRankCardState extends State<IRankCard> {
  bool _isLoading = false;
  late Transaction _transaction;
  late Wish _wish;


  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return InkWell(
      onTap: () {

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
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.pet.usrImage.toString(),
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
                            fontSize: FONT_TITLE,
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
                            fontSize: FONT_TITLE,
                          ),
                        ),
                        Text( '${widget.pet.petValue} wnks',
                          style: TextStyle(
                            color: color.xTrailing,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_TITLE,
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
                            fontSize: FONT_TITLE,
                          ),
                        ),
                        Text( '${'${widget.pet.petCash}'.kes()} wnks',
                          style: TextStyle(
                            color: color.xTrailing,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_TITLE,
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
                            fontSize: FONT_TITLE,
                          ),
                        ),
                        Text( "${'${widget.pet.petAssets}'.kes()} wnks",
                          style: TextStyle(
                            color: color.xTrailing,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_TITLE,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Last Active: ',
                          style: TextStyle(
                            color: color.xTextColor,
                            fontWeight: FontWeight.normal,
                            fontSize: FONT_TITLE,
                          ),
                        ),
                        Text( timeago.format(DateTime.parse(widget.pet.petLastActiveTime)),
                          style: TextStyle(
                            color: color.xTrailing,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_TITLE,
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
                            fontSize: FONT_TITLE,
                          ),
                        ),
                        Text( '${widget.pet.usrOwner}',
                          style: TextStyle(
                            color: color.xTrailing,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_TITLE,
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
                        IButton(
                          onPress: () {
                            setState(() {_isLoading = true;});
                            _wish = Wish()
                              ..wishId = widget.pet.wishId
                              ..wishPetId = widget.pet.usrId
                              ..wishUsrId = Mixin.user?.usrId;

                            IPost.postData(_wish, (state, res, value) {setState(() {
                                setState(() {_isLoading = false;});
                                if (state) {
                                  Mixin.showToast(context, res, INFO);
                                  Provider.of<IWishProvider>(context, listen: false).refresh('', false);
                                } else {
                                  Mixin.errorDialog(context, 'ERROR', res);
                                }});}, IUrls.WISH());
                          },
                          isBlack: false,
                          text: 'Remove',
                          color:  color.xPrimaryColor,
                          textColor:  color.xTextColor,
                          fontWeight: FontWeight.normal,
                          width: 120.w,
                          height: 35.h,
                        ),
                      IButton(
                        onPress: () {
                          setState(() {_isLoading = true;});
                          _transaction = Transaction()
                          ..txnBuyerUsrId = Mixin.user?.usrId
                          ..txnPetUsrId = widget.pet.usrId;

                          IPost.postData(_transaction, (state, res, value) {setState(() {
                              setState(() {_isLoading = false;});
                              if (state) {
                                Mixin.showToast(context, res, INFO);
                                Provider.of<IWishProvider>(context, listen: false).refresh('', false);
                              } else {
                                Mixin.errorDialog(context, 'ERROR', res);
                              }});}, IUrls.TRANSACTION());
                        },
                        isBlack: false,
                        text: 'Buy Now',
                        color:  color.xTrailing,
                        textColor:  Colors.white,
                        fontWeight: FontWeight.normal,
                        width: 120.w,
                        height: 35.h,
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

extension on String {
  String kes() {
    return NumberFormat.currency(
      locale: 'en_KE',
      symbol: ' ',
      decimalDigits: 0, // Set to 0 decimal places
    ).format(int.parse(this));
  }
}

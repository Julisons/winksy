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
import 'package:winksy/screen/message/chat/chat.dart';

import '../../../../component/button.dart';
import '../../../../mixin/constants.dart';
import '../../../../mixin/mixins.dart';
import '../../../../model/pet.dart';
import '../../../../model/transaction.dart';
import '../../../../request/posts.dart';
import '../../../../request/urls.dart';
import '../../../../theme/custom_colors.dart';


class IWishCard extends StatefulWidget {
  const IWishCard({super.key, required this.pet, required this.onRefresh, required this.text});
  final Pet pet;
  final VoidCallback onRefresh;
  final String text;


  @override
  State<IWishCard> createState() => _IWishCardState();
}

class _IWishCardState extends State<IWishCard> {
  bool _isLoading = false;
  late Transaction _transaction;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IButton(
                          onPress: () {
                            setState(() {_isLoading = true;});
                            _transaction = Transaction();

                            IPost.postData(_transaction, (state, res, value) {setState(() {
                              if (state) {
                                setState(() {_isLoading = false;});
                                Provider.of<IOwnedProvider>(context, listen: false).refresh('');
                              } else {Mixin.errorDialog(context, 'ERROR', res);
                              }});}, IUrls.TRANSACTION());
                          },
                          isBlack: false,
                          text: 'Remove',
                          color:  color.xPrimaryColor,
                          textColor:  Colors.white,
                          fontWeight: FontWeight.normal,
                          width: 120.w,
                          height: 35.h,
                        ),
                      IButton(
                        onPress: () {
                          setState(() {_isLoading = true;});
                          _transaction = Transaction();

                          IPost.postData(_transaction, (state, res, value) {setState(() {
                            if (state) {
                              setState(() {_isLoading = false;});
                              Provider.of<IOwnedProvider>(context, listen: false).refresh('');
                            } else {Mixin.errorDialog(context, 'ERROR', res);
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
      symbol: 'KES ',
      decimalDigits: 0, // Set to 0 decimal places
    ).format(int.parse(this));
  }
}

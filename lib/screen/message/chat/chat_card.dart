import 'dart:convert';
import 'dart:developer';
import 'package:timeago/timeago.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/mixin/extentions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vibration/vibration.dart';
import '../../../../mixin/mixins.dart';
import '../../../../request/urls.dart';
import '../../../../theme/custom_colors.dart';
import '../../../model/chat.dart';
import '../../../model/user.dart';
import '../message.dart';


class IChatCard extends StatefulWidget {
  const IChatCard(
      {super.key,
      required this.chat,
      required this.text, this.onClick});

  final Chat chat;
  final String text;
  final VoidCallback? onClick; // Or use a custom function with params

  @override
  State<IChatCard> createState() => _IChatCardState();
}

class _IChatCardState extends State<IChatCard> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Card(
      elevation: ELEVATION,
      color: color.xPrimaryColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: color.xPrimaryColor, width: 0),
          borderRadius: BorderRadius.circular(CORNER)),
      child: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: SizedBox(
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: '${widget.chat.usrImage}'.startsWith('http') ? '${widget.chat.usrImage}' : '${IUrls.IMAGE_URL}/file/secured/${widget.chat.usrImage}',
                    fit: BoxFit.cover,
                    height: 70,
                    width: 70,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: color.xSecondaryColor,
                      highlightColor: color.xPrimaryColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text('${widget.chat.usrReceiver}',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle( fontWeight: FontWeight.bold, color: color.xTextColor, fontSize: FONT_TITLE)),
                          ),

                          if(widget.chat.msgCreatedTime != null)
                          Text(timeago.format(DateTime.parse(widget.chat.msgCreatedTime)),
                              textAlign: TextAlign.center,
                              style: TextStyle( fontWeight: FontWeight.normal, color: color.xTrailing, fontSize: FONT_SMALL),),
                        ],
                      ),
                      Flexible(
                          child: Row(
                            children: [
                              widget.chat.msgReceiverId.toString() != Mixin.user?.usrId.toString()  ?
                               Padding(
                                 padding: const EdgeInsets.only(right: 8),
                                 child: Icon(
                                  Icons.done_all,
                                  size: 18,
                                  color: widget.chat.msgStatus == 'SENT' ? Colors.grey : Colors.blueAccent, // Use Colors.blue if message is read
                                                               ),
                               ) :  SizedBox.shrink(),
                              Flexible(
                                child: Text('${widget.chat.msgText}',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: TextStyle( fontWeight: widget.chat.msgStatus == 'SENT' ? FontWeight.bold : FontWeight.normal,
                                        color: color.xTextColorSecondary, fontSize: FONT_13)),
                              ),
                              widget.chat.msgCount > 0 ? Container(
                                padding: EdgeInsets.all(8),
                                decoration:  BoxDecoration(
                                  color: color.xTrailing, // red background
                                  shape: BoxShape.circle, // makes it circular
                                ),
                                child: Text(
                                  '${widget.chat.msgCount}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white, // white text for contrast
                                    fontSize: 13,
                                  ),
                                ),
                              ) : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              widget.onClick!();
              Mixin.winkser = User()
              ..usrId = Mixin.user?.usrId == widget.chat.msgSenderId ? widget.chat.msgReceiverId : widget.chat.msgSenderId
              ..usrImage = widget.chat.usrImage;
              Mixin.navigate(context,  IMessage(chat: widget.chat, showTitle: true,));
            },
          ),
        ),
      ),
    );
  }
  
}

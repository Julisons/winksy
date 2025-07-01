import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/mixin/extentions.dart';
import 'package:winksy/screen/account/winker/winker.dart';
import 'package:winksy/screen/message/chat/chat.dart';
import '../../../component/button.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/chat.dart';
import '../../../model/user.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../message/message.dart';



class IFriendCard extends StatefulWidget {
  const IFriendCard({super.key, required this.user, required this.onRefresh, required this.text});
  final User user;
  final VoidCallback onRefresh;
  final String text;

  @override
  State<IFriendCard> createState() => _IFriendCardState();
}

class _IFriendCardState extends State<IFriendCard> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return InkWell(
      onTap: () {
        Mixin.winkser = widget.user;
        Mixin.navigate(context, IWinkser());
      },
      child: Card(
        elevation: ELEVATION,
        color: color.xSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CORNER),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: '${widget.user.usrImage}'.startsWith('http') ? widget.user.usrImage
                      : '${IUrls.IMAGE_URL}/file/secured/${widget.user.usrImage}',
                  width: IMAGE_RADIUS,
                  height: IMAGE_RADIUS,
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
              SizedBox(width: 30.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text("${widget.user.usrFullNames}, ${'${widget.user.usrDob}'.age()}",
                            style: TextStyle(
                              color: color.xTextColorSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_TITLE,
                            ),
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
                  Text(
                      (widget.user.usrDistance == null || widget.user.usrDistance.isEmpty
                          ? '${widget.user.usrLocality}'
                          : '${widget.user.usrDistance} (${widget.user.usrLocality})').replaceAll('null', ''),
                      style: TextStyle(
                        color: color.xTextColor,
                        fontWeight: FontWeight.normal,
                        fontSize: FONT_TITLE,
                      ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


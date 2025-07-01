import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/mixin/extentions.dart';
import 'package:winksy/screen/message/chat/chat.dart';
import '../../../component/button.dart';
import '../../../component/online_status_indicator.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/user.dart';
import '../../../request/urls.dart';
import '../../../screen/account/winker/winker.dart';
import '../../../theme/custom_colors.dart';


class IFameHallCard extends StatefulWidget {
  const IFameHallCard({super.key, required this.user, required this.onRefresh, required this.text});
  final User user;
  final VoidCallback onRefresh;
  final String text;

  @override
  State<IFameHallCard> createState() => _IFameHallCardState();
}

class _IFameHallCardState extends State<IFameHallCard> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return InkWell(
      onTap: () {
        Mixin.winkser = widget.user;
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
              userId: widget.user.usrId,
              badgeSize: 14.0,
              alignment: Alignment.topRight,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: '${widget.user.usrImage}'.startsWith('http') ? widget.user.usrImage
                      : '${IUrls.IMAGE_URL}/file/secured/${widget.user.usrImage}',
                  width: 100.r,
                  height: 100.r,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20,top: 8,right: 8,bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("${widget.user.usrFullNames}",
                            style: TextStyle(
                              color: color.xTextColorSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_TITLE,
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
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.xSecondaryColor, // Or use Colors.white, etc.
                          border: Border.all(color: color.xTextColorSecondary, width: 1),
                        ),
                        child: Text(
                          '${widget.user.usrCustId}',
                          style: TextStyle(
                            color: color.xTextColorSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_TITLE,
                          ),
                          textAlign: TextAlign.center,
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
    );
  }
}


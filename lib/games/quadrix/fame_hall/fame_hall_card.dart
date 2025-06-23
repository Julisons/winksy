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
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/user.dart';
import '../../../request/urls.dart';
import '../../../screen/account/winker/winkser.dart';
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
        log("Winkser: ${Mixin.winkser?.usrGender}");
        Mixin.navigate(context, IWinkser());
      },
      child: Card(
        elevation: ELEVATION,
        color: color.xSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CORNER),
        ),
        child: Padding(
          padding: EdgeInsets.all(.0.h),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(CORNER)) ,
                child: CachedNetworkImage(
                  imageUrl: '${widget.user.usrImage}'.startsWith('http') ? widget.user.usrImage
                      : '${IUrls.IMAGE_URL}/file/secured/${widget.user.usrImage}',
                  width: MediaQuery.of(context).size.width/2,
                  height: MediaQuery.of(context).size.width/1.2,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: color.xSecondaryColor,
                    highlightColor:color.xPrimaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                    //  height: MediaQuery.of(context).size.width/2,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: color.xSecondaryColor,
                    child: Icon(Icons.person, size: 50, color: color.xPrimaryColor),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 10,
                child:

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${widget.user.usrFirstName}, ${'${widget.user.usrDob}'.age()}",
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
                          size: 13.r, // Adjust size as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 10,
                child: Text(
                  (widget.user.usrDistance == null || widget.user.usrDistance.isEmpty
                      ? '${widget.user.usrLocality}'
                      : '${widget.user.usrDistance} (${widget.user.usrLocality})').replaceAll('null', ''),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}


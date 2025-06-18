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
import '../../../../component/button.dart';
import '../../../../mixin/mixins.dart';
import 'package:winksy/model/User.dart';
import '../../../../request/urls.dart';
import '../../../../theme/custom_colors.dart';
import '../../../mixin/constants.dart';
import '../../../model/chat.dart';
import '../../../model/photo.dart';
import '../winkser.dart';
import '../../message/message.dart';


class IPhotoCard extends StatefulWidget {
  const IPhotoCard({super.key, required this.photo, required this.onRefresh, required this.text});
  final Photo photo;
  final VoidCallback onRefresh;
  final String text;

  @override
  State<IPhotoCard> createState() => _IPhotoCardState();
}

class _IPhotoCardState extends State<IPhotoCard> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return InkWell(
      onTap: () {
        log('${IUrls.IMAGE_URL}${widget.photo.imgImage}');
      },
      child: Card(
        elevation: ELEVATION,
        color: color.xSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CORNER),
        ),
        child: Padding(
          padding: EdgeInsets.all(.0.h),
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: '${IUrls.IMAGE_URL}/file/secured/${widget.photo.imgImage}',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width/2,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          )
        ),
      ),
    );
  }
}


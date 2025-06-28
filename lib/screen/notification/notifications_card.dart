import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../model/notification.dart';
import '../../theme/custom_colors.dart';

class INotificationsCard extends StatefulWidget {
  const INotificationsCard({Key? key, required this.notification}) : super(key: key);
  final INotification notification;

  @override
  State<INotificationsCard> createState() => _INotificationsCardState();
}

class _INotificationsCardState extends State<INotificationsCard> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Container(
      height: 100.h,
      color: color.xPrimaryColor,
      margin: EdgeInsets.all(8.h),
      child: InkWell(
        child: Card(
          color: color.xSecondaryColor,
          elevation: ELEVATION,
          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CORNER),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.notification.notiTitle??'', style: TextStyle(fontSize: FONT_TITLE, color: color.xTextColor, fontWeight: FontWeight.bold),),
                    const SizedBox(width: 10),
                    Text( timeago.format(DateTime.parse(widget.notification.notiCreatedTime)),
                        style: GoogleFonts.workSans(fontSize: FONT_SMALL,fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(child: Text(widget.notification.notiMessage??'',
                  style: TextStyle( fontWeight: FontWeight.normal, color: color.xTextColor, fontSize: FONT_13),))
              ],
            ),
          ),
        ),
        onTap: () {
        },
      ),
    );
  }
}

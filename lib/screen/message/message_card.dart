import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../mixin/constants.dart';
import '../../../model/message.dart';
import '../../theme/custom_colors.dart';

class IMessageCard extends StatefulWidget {
  final Message message;
  final bool isSender;
  const IMessageCard(
      {Key? key,
      required this.animationController,
      required this.message,
      required this.isSender});
  final AnimationController animationController;

  @override
  State<IMessageCard> createState() => _IMessageCardState();
}

class _IMessageCardState extends State<IMessageCard> {
  String time = '';

  @override
  void initState() {
    super.initState();
    if (widget.message.msgCreatedTime != null) {
      try {
        var dt = DateTime.parse(widget.message.msgCreatedTime).toLocal();
        time = DateFormat('hh:mm a').format(dt);
      } catch (e) {
        // Fallback if parsing fails
        var now = DateTime.now();
        time = DateFormat('hh:mm a').format(now);
      }
    } else {
      var now = DateTime.now();
      time = DateFormat('hh:mm a').format(now);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(sizeFactor: CurvedAnimation(parent: widget.animationController, curve: Curves.easeOut),
        axisAlignment: 0.0, child: widget.isSender ? _sender() : _receiver());
  }

  Widget _receiver() {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, right: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    // Beautiful gradient for received messages - Cool blue to purple
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff3e5ff3).withOpacity(0.8),
                        Color(0xFF764ba2).withOpacity(0.8),
                        Color(0xFF8e44ad).withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(1.0),
                      topRight: Radius.circular(18.0),
                      bottomRight: Radius.circular(18.0),
                      bottomLeft: Radius.circular(18.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF667eea).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // Inner glass effect
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(1.0),
                        topRight: Radius.circular(18.0),
                        bottomRight: Radius.circular(18.0),
                        bottomLeft: Radius.circular(18.0),
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 12, left: 12, right: 12, bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.message.msgText ?? '',
                            style: TextStyle(
                               color: Colors.white,
                              fontSize: FONT_13,
                              fontWeight: FontWeight.w500,
                            )
                          ),
                          const SizedBox(height: 5),
                          Text(
                            time,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: FONT_13,
                                fontWeight: FontWeight.w400,
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sender() {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, left: 40, right: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    // Beautiful gradient for sent messages - Warm pink to orange
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffef5293).withOpacity(0.9),
                        Color(0xFFf5576c).withOpacity(0.8),
                        Color(0xFFff6b6b).withOpacity(0.9),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(1.0),
                      bottomRight: Radius.circular(18.0),
                      bottomLeft: Radius.circular(18.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFf5576c).withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // Inner glass effect
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(1.0),
                        bottomRight: Radius.circular(18.0),
                        bottomLeft: Radius.circular(18.0),
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12, left: 12, right: 12, bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.message.msgText ?? '',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: FONT_13,
                                fontWeight: FontWeight.w500,
                            )
                          ),
                          const SizedBox(height: 5),
                          Text(
                            time,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: FONT_13,
                                fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

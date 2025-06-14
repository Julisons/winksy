import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

    if(widget.message.msgCreatedTime != null) {
      var dt = DateTime.parse(widget.message.msgCreatedTime);
      time = DateFormat('hh:mm a').format(dt);
    }else{
      var dt = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
      time = DateFormat('hh:mm a').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: widget.animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: widget.isSender ? _sender() : _receiver());
  }

  Widget _receiver() {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, right: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.xTrailing.withAlpha(100),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(1.0),
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(18.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, left: 12, right: 12, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align content to left
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.message.msgText ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          time,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
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
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, left: 40, right: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.xSecondaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(1.0),
                      bottomRight: Radius.circular(18.0),
                      bottomLeft: Radius.circular(18.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, left: 12, right: 12, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end, // Align content to right
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.message.msgText ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          time,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
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

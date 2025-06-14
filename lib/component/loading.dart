import 'package:flutter/material.dart';

import '../mixin/constants.dart';

class ILoading extends StatefulWidget {
  const ILoading({Key? key, this.message = 'Loading...'}) : super(key: key);

  final String message ;

  @override
  State<ILoading> createState() => _ILoadingState();
}

class _ILoadingState extends State<ILoading> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: .9, color: lime,)),
          const SizedBox(
            width: 12,
          ),
          Text(
            widget.message,
            style:  TextStyle(
              letterSpacing: 1,
              /*  shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 70.0,
                    color: xBlueColor,
                  ),
                  Shadow(
                    offset: Offset(.0, .0),
                    blurRadius: 40.0,
                    color: xBlueColor,
                  ),
                  Shadow(
                    offset: Offset(.0, .0),
                    blurRadius: 30.0,
                    color: xBlueColor,
                  ),
                ],*/
                color: lime,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

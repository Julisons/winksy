import 'package:flutter/material.dart';

class IEmpty extends StatelessWidget {
  final onTap;
  const IEmpty({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: (){
          onTap();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children:  const [
            SizedBox(width: 30, height: 30, child: Icon(Icons.refresh)),
            SizedBox(
              width: 12,
            ),
            Text(
              'No data...',
              style: TextStyle(
                letterSpacing: 1,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 70.0,
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(.0, .0),
                      blurRadius: 40.0,
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(.0, .0),
                      blurRadius: 30.0,
                      color: Colors.white,
                    ),
                  ],
                  color: Colors.black38,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

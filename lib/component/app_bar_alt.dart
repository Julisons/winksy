import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../component/popup.dart';

class IAppBarAlt extends StatelessWidget {
  const IAppBarAlt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Image.asset('assets/ic_icon.png',
            fit: BoxFit.cover, width: 150, height: 56),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () {},
        ),
        const IPopup(),
      ],
    );
  }
}

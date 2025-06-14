import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../component/popup.dart';
import '../mixin/constants.dart';

class IAppBar extends StatelessWidget {
  const IAppBar({Key? key, this.title = 'VIDEOMED TELEMEDICINE'}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: xGreenPrimary,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      ),
      backgroundColor: xGreenPrimary,
      elevation: 4.0,
      foregroundColor: Colors.white,
      title: Text('     $title', style: const TextStyle(color: Colors.white)),
      actions: <Widget>[
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

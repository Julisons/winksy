import 'dart:core';
import 'package:flutter/material.dart';
import 'package:winksy/screen/account/profile.dart';
import '../mixin/constants.dart';
import '../mixin/mixins.dart';
import '../screen/account/contact.dart';
import '../screen/account/editor/stepper.dart';
import '../screen/account/logout.dart';
import '../screen/account/settings.dart';
import '../screen/account/terms.dart';
import '../screen/splash/splash_screen.dart';
import '../theme/custom_colors.dart';

class IPopup extends StatefulWidget {
  const IPopup({Key? key}) : super(key: key);

  @override
  State<IPopup> createState() => _IPopupState();
}

class _IPopupState extends State<IPopup> {
  late String auth = 'Log Out';
  @override
  void initState() {
    super.initState();

    Mixin.hasPref(key: CURR).then((value) => {
      if(!value){
        setState(() {
          auth = 'Login';
        })
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return PopupMenuButton<String>(
      color: color.xPrimaryColor,
      iconColor: lime,
      onSelected: (value) {
        handleClick(value, context);
      },
      itemBuilder: (BuildContext context) {
        return { 'Edit Profile','Terms & Conditions', 'Contact Us','Settings', auth,}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice, style: TextStyle(color: color.xTextColorSecondary),),
          );
        }).toList();
      },
    );
  }

  void handleClick(String value, BuildContext context) {
    switch (value) {
      case 'Sign out':
        Mixin.navigate(context, const ILogout());
        break;
      case 'Edit Profile':
        Mixin.navigate(context, IStepper());
        break;
      case 'Contact Us':
        Mixin.navigate(context, const IContactUs());
        break;
      case 'Terms & Conditions':
        Mixin.navigate(context, const ITerms());
        break;
      case 'Settings':
        Mixin.navigate(context, const ISettings());
        break;
    }
  }
}

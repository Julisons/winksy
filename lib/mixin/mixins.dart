import 'dart:convert';
import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:vibration/vibration.dart';
import '../../../../mixin/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component/button.dart';
import '../model/invoice.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/quad.dart';
import '../model/user.dart';
import '../screen/authenticate/sign_in.dart';
import '../theme/custom_colors.dart';

class Mixin {
  static DateFormat formatDate = DateFormat('dd-MM-yyyy');
  static DateFormat formatDateTime = DateFormat('yyyy-MM-dd hh:mm');
  static User? user;
  static User? winkser;
  static String? tab = 'All';
  static dynamic position;
  static bool? isPipActivated = false;
  static PlatformWebViewController? controller;
  static PlatformWebViewController ? webController;
  static PageController? pageController;
  static Map<String, num> positions = {};
  static Quad? quad ;
  static IO.Socket? quadrixSocket;
  static Invoice? invoice;
  static List<String>? tabs = ['All'];
  static String TYPE = '';
  static List<dynamic> docs = [];
  static String appStatus='';
  static PersistentTabController? persistentTabController;

  static Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(CURR)) {
      String? data = prefs.getString(CURR);
      if(data.toString() == 'null')
        {
          return null;
        }

      log('----------------DATA---$data');

      return User.fromJson(jsonDecode(data!));
    } else {
      return null;
    }
  }

  static bool isTab(BuildContext context) {
    final data = MediaQuery.of(context);
    final shortestSide = data.size.shortestSide;
    return shortestSide >= 600; // Common threshold for tablets
  }

  static showToast(BuildContext context, String message, int type) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: type == ERROR ? xRedColor : lime,
        textColor: Colors.white,
       // fontSize: 20,
    );
   vibrate();
  }

  static Future<void> errorDialog(
      BuildContext context, String title, String message) async {
    final color = Theme.of(context).extension<CustomColors>()!;
    vibrate();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:color.xPrimaryColor,
          title: Text(title, style:  TextStyle(color: color.xTrailing)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message, style: TextStyle(color:  color.xTextColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Retry', style: TextStyle(color:  color.xTrailing),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  static Future<void> info(
      BuildContext context, String title, String message) async {
    final color = Theme.of(context).extension<CustomColors>()!;
    vibrate();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.end,
          backgroundColor:color.xSecondaryColor,
          title: Text(title, style:  TextStyle(color: color.xTrailing)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message, style: TextStyle(color:  color.xTextColorSecondary)),
              ],
            ),
          ),
          actions: <Widget>[
            IButton(
              onPress: () {
                Navigator.of(context).pop();
              },
              isBlack: false,
              text: 'Ok',
              color:  color.xTrailing,
              textColor:  Colors.white,
              fontWeight: FontWeight.normal,
              width: 120.w,
              height: 35.h,
            )
          ],
        );
      },
    );
  }


  static Future<void> signIn(
      BuildContext context, String title, String message) async {
    final color = Theme.of(context).extension<CustomColors>()!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:color.xPrimaryColor,
          title: Text(title, style:  TextStyle(color: color.xTrailing)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message, style: TextStyle(color:  color.xTextColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Sign-In', style: TextStyle(color:  color.xTrailing),),
              onPressed: () {
                Navigator.of(context).pop();
                Mixin.navigate(context, const ISignIn());
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> logout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('LOGOUT', style: TextStyle(color: Colors.red)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                /*Tone().logout().then((value) {
                  Mixin.user = null;
                  Navigator.of(context).pop();
                });*/
              },
            ),
          ],
        );
      },
    );
  }


  static String phone(String phone) {
    if (phone.length == 9) {
      return '+254$phone';
    } else if (phone.length == 10) {
      return phone.replaceFirst('0', '+254');
    } else if (phone.length == 12) {
      return phone.replaceFirst('254', '+254');
    }
    return phone;
  }

  static prefString({required String pref, required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, pref);
  }

  static prefInt({required int pref, required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, pref);
  }

  static Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<bool> hasPref({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<String?> getPrefString({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.getString(key);
    } else {
      return '';
    }
  }

  static Future<bool> remove({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.remove(key);
    } else {
      return true;
    }
  }

  static navigate(BuildContext context, Widget widget){
   PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: widget,
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static pop(BuildContext context, Widget widget){
    Navigator.pushAndRemoveUntil(context,
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: widget,
          );
        }),  (route) => false);
  }

  static navigateWithTab(BuildContext context, Widget widget){
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: widget,
      withNavBar: true, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static void vibrate() async {
    if (await Vibration.hasCustomVibrationsSupport()) {
      Vibration.vibrate(duration: 80, amplitude: 8);
    } else {
      Vibration.vibrate();
      await Future.delayed(Duration(milliseconds: 500));
      Vibration.vibrate();
    }
  }
  static void vib() async {
    if (await Vibration.hasCustomVibrationsSupport()) {
      Vibration.vibrate(duration: 29, amplitude: 1);
    } else {
      Vibration.vibrate();
      await Future.delayed(Duration(milliseconds: 500));
      Vibration.vibrate();
    }
  }

  static Future<bool> initDoc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(DOCTOR);
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }
}

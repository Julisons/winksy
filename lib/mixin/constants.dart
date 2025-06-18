import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const Color xPrimaryColor = Color.fromRGBO(22,34,55,255);

//rgba(22,34,55,255)
const Color xPrimaryColorAlt = Color.fromRGBO(20,20,20,1);
const Color xShimmerBase = Color.fromRGBO(30,30,30,1);
const Color xShimmerHighlight = Color.fromRGBO(20,20,20,1);
const Color xSecondaryColor = Color.fromRGBO(255, 255, 255, 1);
const Color xPrimaryColorDoc = Color.fromRGBO(240, 240, 255, 1);
const Color xBlackColor = Color.fromRGBO(30, 25, 27, 1);
//const Color xGreenColor = Color(0xFF43A047);
const Color xRedColor = Color.fromRGBO(244, 26, 28, 1);
final navigatorKey = GlobalKey<NavigatorState>();
const url = 'https://videomed.co.ke/myimages/pixir/';
 Color lime = HexColor.fromHex('#e31512');
 Color greenLand = HexColor.fromHex('#811f28');
 Color ashGrey = HexColor.fromHex('#666666');
 Color darkAshGrey = HexColor.fromHex('#333333');
 Color mpesa = HexColor.fromHex('#0cb323');
 Color payless = HexColor.fromHex('#fb0414');

const List<String> scopes = <String>[
  'email'
];

const int _limePrimaryValue = 0xFF99CC99;

const MaterialColor limePrimary = MaterialColor(
  _limePrimaryValue,
  <int, Color>{
    50: Color(0xFFE6F4E6), // Very light lime
    100: Color(0xFFCDEACC), // Light lime
    200: Color(0xFFB3DFB3), // Softer lime
    300: Color(0xFF99D499), // Mid lime
    400: Color(0xFF80CA80), // Slightly vivid lime
    500: Color(_limePrimaryValue), // Primary lime color
    600: Color(0xFF85B985), // Slightly darker lime
    700: Color(0xFF75A675), // Moderate lime
    800: Color(0xFF669966), // Dark lime
    900: Color(0xFF4D734D), // Deep lime
  },
);


const Color xBlueColor = Color.fromRGBO(0,0,0,1);
const Color xGreyColor = Color.fromRGBO(247, 247, 247, 1);
const Color xBorderColor = Color.fromRGBO(198, 206, 208, 1);
const Color xDisabledColor = Color.fromRGBO(198, 206, 208, 1);
const Color xYellowColor = Color.fromRGBO(255, 182, 0, 1);
const Color xFontGrey = Color.fromRGBO(121, 137, 140, 1);

const String USER = "USER";
const String DOCTOR = "DOCTOR";
const String INTRO = "INTRO";
const String DECLINE = "DECLINE";
const String DECLINED = "DECLINE";
const String DIALOG_POPPED = "DIALOG_POPPED";
//const String USER_IS_ONLINE = "USER_IS_ONLINE";
const String ACCEPT = "ACCEPT";
const String ACCEPTED = "ACCEPT";
const String DATA = "DATA";
const String ACCOUNT = "ACCOUNT";
const String MESSAGE = "MESSAGE";
const String ACTION = "ACTION";
const double elevation = 0.0;
const String EMPTY = 'Search found 0 results ( click to refresh ) ';
const String CONNECTION = "Check your internet connection";
const int CONN = -1;
const String TOKEN = "TOKEN";
const String CURR = "USER";
const String DOC = "DOCTOR";
const String THEME = "THEME";
const String DARK = "DARK";
const String LIGHT = "LIGHT";
const String CONN_JOIN = "CONN_JOIN";
const String CONN_JOINED = "CONN_JOINED";
const String PRESCRIPTION = "Medication";
const bool leading = false;

final double FONT_START = 39.5.sp;
final double FONT_APP_BAR = 24.sp;
final double FONT_TITLE = 14.5.sp;
final double FONT_13 = 13.sp;
final double FONT_MEDIUM = 14.sp;
final double FONT_SMALL = 10.sp;

final double APP_BAR = 50.w;
final double TILE_HEIGHT = 110.w;
final double ELEVATION = 0.w;
final double CORNER = 5.w;

const int ERROR = 1;
const int INFO = 21;

const String True = "true";
const String False = "false";
const String MESSAGE_TO_ALL = 'MESSAGE_TO_ALL';
const String CHAT_CLICKED = 'CHAT_CLICKED';
const String USER_IS_ONLINE = 'USER_IS_ONLINE';

const String URGENT_CARE = "URGENT_CARE";
const String URGENT_CARE_NOW = "URGENT_CARE_NOW";
const String TALK_TO_A_THERAPIST_NOW = 'TALK_TO_A_THERAPIST_NOW';
const String TALK_TO_A_PSYCHIATRIST_NOW = 'TALK_TO_A_PSYCHIATRIST_NOW';
const String SELECT_OTHER_SPECIALITIES = 'SELECT_OTHER_SPECIALITIES';
const String PSYCHIATRY = 'PSYCHIATRY';
const String THERAPY_SESSIONS = 'THERAPY_SESSIONS';
const String MAKE_APPOINTMENT = 'MAKE_APPOINTMENT';
const String APPOINTMENT = 'APPOINTMENT';
const String CONSULTATION = 'CONSULTATION';
const String REMINDERS = 'REMINDERS';
const String MESSAGES = 'MESSAGES';
const String NOTIFICATIONS = 'NOTIFICATIONS';
const String APPOINTMENTS = 'APPOINTMENTS';
const String COMPLETED = 'COMPLETED';
const String PAID = 'PAID';
const String PENDING = 'PENDING';
const String PET_NOTIFICATION = 'PET_NOTIFICATION';
const String PET_NOTIFICATION_NORMAL = 'PET_NOTIFICATION_NORMAL';


const int _greenPrimaryValue = 0xFF4CAF50;
const MaterialColor xGreenPrimary = MaterialColor(
  _greenPrimaryValue,
  <int, Color>{
    50: Color(0xFFE8F5E9),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(_greenPrimaryValue),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  },
);

const MaterialColor xRedPrimary = MaterialColor(
  _redPrimaryValue,
  <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(_redPrimaryValue),
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  },
);
const int _redPrimaryValue = 0xFFF44336;
const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFF28288B),
    Color(0xFFB90A0A),
    Color(0xFF6D6D7E),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);


Future<void> permissionDialog(BuildContext context, String title, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.red)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(color:  Colors.red),),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          TextButton(
            child: const Text('Retry'),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
        ],
      );
    },
  );
}

extension HexColor on Color {
  /// Creates a Color from a hexadecimal string.
  /// The [hexString] should be in the format "RRGGBB" or "AARRGGBB",
  /// with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Converts a Color to a hexadecimal string representation.
  /// If [leadingHashSign] is set to `true`, prefixes the string with "#".
  String toHex({bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
        '${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

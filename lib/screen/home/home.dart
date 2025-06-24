import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_core/firebase_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:winksy/model/chat.dart';
import 'package:winksy/model/notification.dart';
import 'package:winksy/provider/payment_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:winksy/screen/message/chat/chat.dart';
import '../../component/button.dart';
import '../../games/games.dart';
import '../../main.dart';
import '../../mixin/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import '../../mixin/mixins.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winksy/model/message.dart' as sms;
import 'package:http/http.dart' as http;
import '../../model/user.dart';
import '../../request/posts.dart';
import '../../request/urls.dart';
import '../../theme/custom_colors.dart';
import '../account/profile.dart';
import '../dashboard/dashboard.dart';
import '../message/message.dart';
import '../people/people.dart';
import '../zoo/zoo.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late BuildContext gContext;

class IHome extends StatefulWidget {
  const IHome({super.key});

  @override
  State<IHome> createState() => _IHomeState();
}

class _IHomeState extends State<IHome> with WidgetsBindingObserver {
  PersistentTabController persistentTabController = PersistentTabController(initialIndex: 0,);
  bool pipAvailable = false;
  bool autoPipAvailable = false;
  bool autoPipSwitch = false;
  bool isPlaying = false;
  late AndroidNotificationChannel channel;

  PersistentBottomNavBarItem tabItem(title, {required Widget icon, screen}) {
    return PersistentBottomNavBarItem(
      textStyle: GoogleFonts.workSans(textStyle: TextStyle(fontSize: FONT_13, fontWeight: FontWeight.normal)),
      icon: icon,
      title: (title),
      activeColorSecondary: Colors.white,
      activeColorPrimary: Theme.of(context).extension<CustomColors>()!.xTrailing,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    );
  }


  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      tabItem('Home  ', icon: const Icon(Icons.dashboard_customize_outlined)),
      tabItem('People', icon: const Icon(Icons.favorite_border_rounded)),
      tabItem('Messages', icon: const Icon(Icons.question_answer_outlined)),
      tabItem('Games', icon: const Icon(Icons.sports_esports_outlined)),
      tabItem('Account', icon: const Icon(Icons.person_outline)),
    ];
  }

  List<Widget> screens = [
    IPeople(showTitle: true),
    IDashboard(),
    IChat(user: Mixin.user),
    IGames(),
    IProfile(),
  ];

  void logScreenInformation(BuildContext context) {
    print('Device Size:${Size(1.sw, 1.sh)}');
    print('Device pixel density:${ScreenUtil().pixelRatio}');
    print('Bottom safe zone distance dp:${ScreenUtil().bottomBarHeight}dp');
    print('Status bar height dp:${ScreenUtil().statusBarHeight}dp');
    print('The ratio of actual width to UI design:${ScreenUtil().scaleWidth}');
    print(
      'The ratio of actual height to UI design:${ScreenUtil().scaleHeight}',
    );
    print('System font scaling:${ScreenUtil().textScaleFactor}');
    print('0.5 times the screen width:${0.5.sw}dp');
    print('0.5 times the screen height:${0.5.sh}dp');
    print('--------------------Screen orientation:${ScreenUtil().orientation}');
  }

  @override
  Widget build(context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    gContext = context;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      body: SafeArea(
        child: PersistentTabView(
          context,
          navBarHeight: 65.h,
          controller: persistentTabController,
          screens: screens,
          onItemSelected: (value) async {
            if (value == 0) {
              // log('-------------------Home');
            } else if (value == 1) {
              // log('-------------------People');
            } else if (value == 2) {
              // log('-------------------Messages');
            } else if (value == 3) {
              // log('-------------------Games');
            } else if (value == 4) {
              // log('-------------------Account');
              Mixin.winkser = User()
                ..usrId = Mixin.user?.usrId
                ..usrImage = Mixin.user?.usrImage
                ..usrFullNames = Mixin.user?.usrFullNames;
            }
          },
          animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              duration: Duration(milliseconds: 200),
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
            ),
          ),
          backgroundColor: color.xPrimaryColor,
          items: navBarsItems(),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: color.xPrimaryColor,
          ),
          navBarStyle: NavBarStyle
              .style7, // Choose the nav bar style with this property.
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    FirebaseMessaging.instance.getToken().then(_updateToken);

    _buildFCM();
    _location();
  }

  void _updateToken(token) async {
        Mixin.user?.usrFirebaseToken = token;
        User data = User()
          ..usrId = Mixin.user?.usrId
          ..usrFirebaseToken = token;
        IPost.postData(data, (state, res, value) {
          log('-------------------------Token updated: $state, $res $token');
        }, IUrls.UPDATE_USER());
  }

  Future<void> _buildFCM() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // Initialize plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message,) {
      if (message != null) {}
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;
      RemoteNotification? notification = message.notification;
      _showNotification(notification, data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // log('-----------------------------------A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        '/message',
        arguments: const NotificationDetails(),
      );
    });
  }

  Future<void> _showBigPictureNotificationURL(
    RemoteNotification? notification,
    String id,
    String icon,
    String channel,
  ) async {
    icon = icon.startsWith('http')
        ? icon
        : '${IUrls.IMAGE_URL} ${icon.replaceFirst('.', '')}';
    final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
      await _getByteArrayFromUrl(icon),
    );
    final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
      await _getByteArrayFromUrl(icon),
    );

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
          bigPicture,
          largeIcon: largeIcon,
          contentTitle: notification?.title,
          htmlFormatContentTitle: true,
          summaryText: notification?.body,
          htmlFormatSummaryText: true,
        );

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          icon: 'ic_launcher',
          channel,
          channel,
          channelDescription: channel,
          styleInformation: bigPictureStyleInformation,
        );
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      int.parse(id),
      '${notification?.body}',
      '${notification?.body}',
      notificationDetails,
    );
  }



  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
       // log('-----------Resumed-${AppLifecycleState.resumed.name}');

        break;
      case AppLifecycleState.inactive:
      //  log('-----------Inactive');
        break;
      case AppLifecycleState.paused:
        // --
       // log('-----------this---Paused');
        break;
      case AppLifecycleState.detached:
        // --
       // log('-----------Detached');
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> _location() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).timeout(Duration(seconds: 10));

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];


    Mixin.user?.usrLat = position.latitude;
    Mixin.user?.usrLng = position.longitude;
    Mixin.user?.usrStreet = place.street;
    Mixin.user?.usrCounty = place.administrativeArea;
    Mixin.user?.usrIsoCountryCode = place.isoCountryCode;
    Mixin.user?.usrCountry = place.country;
    Mixin.user?.usrPostalCode = place.postalCode;
    Mixin.user?.usrAdministrativeArea = place.administrativeArea;
    Mixin.user?.usrSubAdministrativeArea = place.subAdministrativeArea;
    Mixin.user?.usrLocality = place.locality;
    Mixin.user?.usrSubLocality = place.subLocality;
    Mixin.user?.usrThoroughfare = place.thoroughfare;
    Mixin.user?.usrSubThoroughfare = place.subThoroughfare;

    IPost.postData(Mixin.user, (state, res, value) {
      if (state) {
       // Mixin.prefString(pref: jsonEncode(value), key: CURR);
      } else {
        Mixin.errorDialog(context, 'ERROR', res);
      }
    }, IUrls.USER());
  }
}

/*// Required for background handling (must be a top-level function)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  log('------------------------------------------------Notification tapped in background: ${response.id}');
 // _handleNotificationResponse(response);
}*/

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('-------------------------------notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }

  _handleNotificationResponse(notificationResponse);
}


void onNotificationResponse(NotificationResponse response) {
  _handleNotificationResponse(response);
}

@pragma('vm:entry-point') // Required for background
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await Firebase.initializeApp();
  Map<String, dynamic> data = message.data;
  RemoteNotification? notification = message.notification;
  _showNotification(notification, data);
}

_showNotification(RemoteNotification? notification, Map<String, dynamic> data) {
  String icon = data['icon'] ?? ''; // Access icon URL
  String payload = data['data'] ?? ''; // Access icon URL
  String channel = data['channel'] ?? 'message'; // Access icon URL
  String id = data['id']?.toString() ??
          DateTime.timestamp()
              .toString(); // Access ID and convert to string if necessary


 /* print(' body-----------------------: ${notification?.body}');
  print(' title-----------------------: ${notification?.title}');
  print('Icon URL-----------------------: $icon');
  print('payload-------------------: $payload');
  print('msgChatId-------------------: ${message.msgChatId}');*/
  if(channel == PET_NOTIFICATION){
    INotification notification = INotification.fromJson(json.decode(payload));
  _showBigPictureNotificationHiddenLargeIcon(notification, id,icon,channel);
    }
  else if(channel == PET_NOTIFICATION_NORMAL){
    INotification notification = INotification.fromJson(json.decode(payload));
    _showNormalNotification(notification, id,channel);
    }
  else if(channel == GIFT_NOTIFICATION){
    INotification notification = INotification.fromJson(json.decode(payload));
    _showNormalNotification(notification, id,channel);
    }
  else
      {
        sms.Message message = sms.Message.fromJson(json.decode(payload));
    showChatNotification( icon, channel, channel, message);
  }
}

Future<void> showChatNotification(
    imageUrl,
    channelId,
    channel,
    sms.Message message,
    ) async {
  final String largeIconPath = await _downloadAndSaveFile(imageUrl, 'john_doe.jpg',);

  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'chat_channel_id',
    'Chat Messages',
    groupKey: message.msgChatId.toString(),
    channelDescription: channel,
    importance: Importance.high,
    priority: Priority.high,
    icon: 'ic_launcher',
    setAsGroupSummary: true,
    color: Color(0xFF25D366), // WhatsApp green
    playSound: true,
    ticker: 'ticker',
    largeIcon: FilePathAndroidBitmap(
      largeIconPath,
    ), // This appears next to title
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        'reply', // Action ID
        'Reply',
        icon: DrawableResourceAndroidBitmap('ic_launcher'),
        inputs: [
          AndroidNotificationActionInput(label: 'Type your message...'),
        ],
        showsUserInterface: false,
      ),
      AndroidNotificationAction(
        'mark_as_read', // Action ID
        'Mark as read',
        icon: DrawableResourceAndroidBitmap('ic_launcher'),
        showsUserInterface: false,
      ),
      AndroidNotificationAction(
        'mute', // Action ID
        'Mute',
        icon: DrawableResourceAndroidBitmap('ic_launcher'),
        showsUserInterface: false,
      ),
    ],
  );

  NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    message.msgId.toString().hashCode,
    message.usrSender,
    message.msgText,
    notificationDetails,
    payload: jsonEncode(message.toJson()),
  );
}

/// Download image from URL and save locally
Future<String> _downloadAndSaveFile(String url, String fileName) async {
  url = url.startsWith('http') ? url : '${IUrls.IMAGE_URL}/file/secured/$url';
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/$fileName';
  final response = await http.get(Uri.parse(url));
  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

void _handleNotificationResponse(NotificationResponse response) {
  if (response.payload != null) {

    sms.Message message = sms.Message.fromJson(jsonDecode(response.payload.toString()));
    print("Notification actionId: ${response.actionId}");
    print("Notification id: ${response.id}");
    print("Notification data: ${response.data}");
    print("Notification Payload: ${response.payload}");

    switch (response.actionId) {
      case 'reply':
        print("User replied: ${response.input}"); // ✅ This is the reply!

        sms.Message newMessage = sms.Message();
        newMessage.msgText = response.input;
        newMessage.msgSenderId = message.msgReceiverId;
        newMessage.msgReceiverId = message.msgSenderId;
        newMessage.msgChatId = message.msgChatId;

         IPost.postData(message, (state, res, value) {
         }, IUrls.SAVE_MESSAGE());
        
        log('------ message.msgChatId,----------${ message.msgChatId}----');

        IO.Socket socket = IO.io(IUrls.NODE(), <String, dynamic>{
          'timeout': 5000,
          'transports': ['websocket'],
          'autoConnect': true,
          'query':
          {
            'room': message.msgChatId,
            'name': Mixin.user?.usrFullNames
          }
        });
        socket.on('connect_error', (c) {log(c.toString());});
        socket.connect();
        socket.onConnect((_) {
          log('connected to server--${message.msgChatId}');
          // Send both name and room when joining
          socket.emit('join', {
            'name': Mixin.user?.usrFullNames ?? 'GUEST',
            'room': message.msgChatId,
          });
        });
        socket.emit('chat message', jsonEncode(newMessage.toJson()));
        break;
      case 'mark_as_read':
        print("User marked as read");
        // Handle mark as read action
        break;
      case 'mute':
        print("User muted notifications");
        // Handle mute action
        break;
      default:
        {
          print("Unknown action: ${response.actionId}");
          Mixin.winkser = User()
            ..usrId = message.msgSenderId
            ..usrImage = message.usrImage;

        Chat chat = Chat()
        ..usrReceiver = message.usrSender
        ..chatReceiverId = message.msgReceiverId
        ..chatCreatedBy =  message.msgReceiverId
        ..chatSenderId = message.msgSenderId;
          Mixin.navigate(gContext,  IMessage(chat: chat, showTitle: true,));
        }

    }
  }

  if (response.input != null) {
    print("User typed message: ${response.input}"); // ✅ This is the reply!
    // You can now route it to chat, send to backend, etc.
  }
}


Future<void> _showBigPictureNotificationHiddenLargeIcon(
    INotification notification,
    String id,
    String icon,
    String channel,
    ) async {
  icon = icon.startsWith('http')
      ? icon
      : '${IUrls.IMAGE_URL} ${icon.replaceFirst('.', '')}';

  final String largeIconPath = await _downloadAndSaveFile(icon, 'largeIcon');
  final String bigPicturePath = await _downloadAndSaveFile(
    icon,
    'bigPicture',
  );
  final BigPictureStyleInformation bigPictureStyleInformation =
  BigPictureStyleInformation(
    FilePathAndroidBitmap(bigPicturePath),
    hideExpandedLargeIcon: true,
    contentTitle: notification.notiTitle,
    htmlFormatContentTitle: true,
    summaryText: notification.notiDesc,
    htmlFormatSummaryText: true,
  );
  final AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(
    icon: 'ic_launcher',
    channel,
    channel,
    channelDescription: notification.notiTitle,
    largeIcon: FilePathAndroidBitmap(largeIconPath),
    styleInformation: bigPictureStyleInformation,
  );
  final NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(
    notification.notiId.toString().hashCode,
    notification.notiTitle,
    notification.notiDesc,
    notificationDetails,
  );
}


Future<void> _showNormalNotification(INotification notification,
    String id,channel,) async {
  AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(
    icon: 'ic_launcher',
    id,
    'normal',
    channelDescription: 'normal',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecond,
    '${notification.notiTitle}',
    '${notification.notiDesc}',
    notificationDetails,
    payload: notification.toJson().toString(),
  );
}
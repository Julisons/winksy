import 'dart:developer';
import 'package:winksy/provider/chat_provider.dart';
import 'package:winksy/provider/interest_provider.dart';
import 'package:winksy/provider/like_me_provider.dart';
import 'package:winksy/provider/like_provider.dart';
import 'package:winksy/provider/match_provider.dart';
import 'package:winksy/provider/notification_provider.dart';
import 'package:winksy/provider/payment_provider.dart';
import 'package:winksy/provider/pet/browse_provider.dart';
import 'package:winksy/provider/pet/owned_provider.dart';
import 'package:winksy/provider/pet/pet_provider.dart';
import 'package:winksy/provider/pet/wish_provider.dart';
import 'package:winksy/provider/theme_provider.dart';
import 'package:winksy/provider/user_provider.dart';
import 'package:winksy/screen/authenticate/select/bio.dart';
import 'package:winksy/screen/authenticate/select/intro.dart';
import 'package:winksy/screen/authenticate/select/social_intro.dart';
import 'package:winksy/screen/home/home.dart';
import 'package:winksy/screen/message/chat/chat.dart';
import 'package:winksy/screen/splash/splash_screen.dart';
import 'package:winksy/theme/theme_data_style.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'component/splash_screen.dart';
import 'firebase_options.dart';
import 'games/games.dart';
import 'mixin/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize(); //add this line
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<IBrowseProvider>(
              create: (_) => IBrowseProvider().init()),
          ChangeNotifierProvider<IUsersProvider>(
              create: (_) => IUsersProvider().init()),
          ChangeNotifierProvider<IWishProvider>(
              create: (_) => IWishProvider().init()),
          ChangeNotifierProvider<IOwnedProvider>(
              create: (_) => IOwnedProvider().init()),
          ChangeNotifierProvider<IPetProvider>(
              create: (_) => IPetProvider().init()),
          ChangeNotifierProvider<ILikeProvider>(
              create: (_) => ILikeProvider()),
          ChangeNotifierProvider<IMatchProvider>(
              create: (_) => IMatchProvider().init()),
          ChangeNotifierProvider<ILikeMeProvider>(
              create: (_) => ILikeMeProvider().init()),
          ChangeNotifierProvider<IInterestProvider>(
              create: (_) => IInterestProvider().init()),
          ChangeNotifierProvider<INotificationsProvider>(
              create: (_) => INotificationsProvider().init()),
          ChangeNotifierProvider<IPaymentProvider>(
              create: (_) => IPaymentProvider().init()),
          ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider()),
          ChangeNotifierProvider<IChatProvider>(
              create: (_) => IChatProvider().init()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(490.9, 1075.0),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? child) {
              return MaterialApp(
                title: 'Winksy',
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                debugShowMaterialGrid: false,
                home: IGames(),
                theme: ThemeDataStyle.lighter,
                darkTheme: ThemeDataStyle.darker,
              );
            }));
  }
}

import 'package:winksy/games/chess/model/app_model.dart' show AppModel;
import 'package:winksy/provider/chat_provider.dart';
import 'package:winksy/provider/fame_hall_provider.dart';
import 'package:winksy/provider/friend_provider.dart';
import 'package:winksy/provider/friends_provider.dart';
import 'package:winksy/provider/friend_request_provider.dart';
import 'package:winksy/provider/gift/gift_provider.dart';
import 'package:winksy/provider/gift/spinner_provider.dart';
import 'package:winksy/provider/gift/treat_provider.dart';
import 'package:winksy/provider/interest_provider.dart';
import 'package:winksy/provider/like_me_provider.dart';
import 'package:winksy/provider/like_provider.dart';
import 'package:winksy/provider/match_provider.dart';
import 'package:winksy/provider/notification_provider.dart';
import 'package:winksy/provider/nudge/nudge_sound_provider.dart';
import 'package:winksy/provider/opponents_provider.dart';
import 'package:winksy/provider/payment_provider.dart';
import 'package:winksy/provider/pet/browse_provider.dart';
import 'package:winksy/provider/pet/owned_provider.dart';
import 'package:winksy/provider/pet/pet_provider.dart';
import 'package:winksy/provider/pet/wish_provider.dart';
import 'package:winksy/provider/photo_provider.dart';
import 'package:winksy/provider/theme_provider.dart';
import 'package:winksy/provider/user/online_status_provider.dart';
import 'package:winksy/provider/user_provider.dart';
import 'package:winksy/screen/splash/splash_screen.dart';
import 'package:winksy/theme/theme_data_style.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'mixin/constants.dart';
import 'mixin/mixins.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize(); //add this line
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Mixin.getUser().then((value) =>
  {
    if(value != null){
      Mixin.user = value,
    }
  });

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<IBrowseProvider>(
              create: (_) => IBrowseProvider().init()),
          ChangeNotifierProvider<IOpponentProvider>(
              create: (_) => IOpponentProvider().init()),
          ChangeNotifierProvider<ISpinnerProvider>(
              create: (_) => ISpinnerProvider().init()),
          ChangeNotifierProvider<IFriendProvider>(
              create: (_) => IFriendProvider().init()),
          ChangeNotifierProvider<ITreatProvider>(
              create: (_) => ITreatProvider().init()),
          ChangeNotifierProvider<INotificationProvider>(
              create: (_) => INotificationProvider().init()),
          ChangeNotifierProvider<IPhotoProvider>(
              create: (_) => IPhotoProvider().init()),
          ChangeNotifierProvider<IGiftProvider>(
              create: (_) => IGiftProvider().init()),
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
          ChangeNotifierProvider<IPaymentProvider>(
              create: (_) => IPaymentProvider().init()),
          ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider()),
          ChangeNotifierProvider<IChatProvider>(
              create: (_) => IChatProvider().init()),
          ChangeNotifierProvider<IFriendsProvider>(
              create: (_) => IFriendsProvider().init()),
          ChangeNotifierProvider<IFriendRequestProvider>(
              create: (_) => IFriendRequestProvider().init()),
          ChangeNotifierProvider<IFameHallProvider>(
              create: (_) => IFameHallProvider().init()),
          ChangeNotifierProvider<INudgeSoundProvider>(
              create: (_) => INudgeSoundProvider().init()),
          ChangeNotifierProvider<OnlineStatusProvider>(
              create: (_) => OnlineStatusProvider()),
          ChangeNotifierProvider(create: (context) => AppModel(),
          ),
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
                home: ISplashScreen(),
                theme: ThemeDataStyle.lighter,
                darkTheme: ThemeDataStyle.darker,
              );
            }));
  }
}
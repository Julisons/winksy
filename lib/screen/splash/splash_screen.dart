import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../component/logo.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';
import '../authenticate/select/intro.dart';
import '../authenticate/sign_up.dart';
import '../home/home.dart';

class ISplashScreen extends StatefulWidget {
  const ISplashScreen({Key? key}) : super(key: key);

  @override
  State<ISplashScreen> createState() => _ISplashScreenState();
}

class _ISplashScreenState extends State<ISplashScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late final CurvedAnimation _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  late Timer _timer;
  int _start = 8;
  late bool init = false;
  late var loading = '...';
  final String loading1 = '.';
  final String loading2 = '..';
  final String loading3 = '...';


  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            _updateUI();
            timer.cancel();
          });
        } else {
          setState(() {
            if (loading.isEmpty) {
              loading = loading1;
            } else if (loading.length == 1) {
              loading = loading2;
            } else if (loading.length == 2) {
              loading = loading3;
            } else if (loading.length == 3) {
              loading = '';
            }
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    Mixin.getUser().then((value) =>
    {
      if(value != null){
        Mixin.user = value,
      }
    });

    _startTimer();
  }

  _updateUI() {
    Mixin.hasPref(key: INTRO).then((value) => {
      if (value)
        {
          Mixin.hasPref(key: CURR).then((val) => {
            if (val)
              {
                Mixin.getUser().then((value) =>
                {
                  Mixin.user = value,
                  _permissions(true),
                }),
              }
            else
              {_permissions(true)}
          })
        }
      else
        {_permissions(true)}
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        //  systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: SizedBox.shrink()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 250.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/images/icon.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(flex: 1,child: SizedBox.shrink()),
            const SizedBox(height: 40),
            FadeTransition(
              opacity: _animation,
              child: SizedBox(
                  width: 166.w,
                  height: 120.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Winksy', style: TextStyle(color: color.xTrailing, fontSize: FONT_APP_BAR, fontWeight: FontWeight.bold),),
                      Text('®', style: TextStyle(color: color.xTrailing, fontSize: FONT_TITLE, fontWeight: FontWeight.bold),),
                    ],
                  )
              ),
            ),
            SizedBox(height: 60.h),
            SizedBox(
              width: 280.w,
              child: Text(
                  "Designed & Developed in Nairobi.\n© 2025 Wink Technologies Limited.\nClosed Beta V2.0.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: color.xTextColorSecondary,
                      fontSize: FONT_13)),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool _showDialog = false;

  _permissions(bool show) async {
    _showDialog = false;
    if (show) {
      Map<Permission, PermissionStatus> statuses =
      await [Permission.notification,Permission.location, Permission.locationWhenInUse].request();

      statuses.values.forEach((element) {
        log('-------------------------------------------------${element}');
      });

      statuses.keys.forEach((element) {
        print(
            '-------------------------${statuses[element]}------------------------${element}');
      });
    }

    if (await Permission.notification.isPermanentlyDenied ||
        await Permission.notification.isDenied || await Permission.location.isPermanentlyDenied ||
        await Permission.location.isDenied) {
      _showDialog = true;
    }

    if (_showDialog) {
      permissionDialog(context, 'PERMISSIONS', "The app won't function without these permissions.\n\nOpen settings to retry?");
    } else {
      Mixin.hasPref(key: INTRO).then((value) => {
        if (value)
          {Mixin.hasPref(key: CURR).then((val) => {
            if (val)
              {
                Mixin.getUser().then((value) =>
                {
                  Mixin.user = value,
                  if(Mixin.tabs != null){
                    Mixin.pop(context, const IHome())
                  }
                })
              }
            else
              {Mixin.navigate(context, const ISignUp())}
          })
          }
        else
          {Mixin.navigate(context, Intro())}
      });
    }
  }

  void logScreenInformation(BuildContext context) {
    log('Device Size:${Size(1.sw, 1.sh)}');
    log('Device pixel density:${ScreenUtil().pixelRatio}');
    log('Bottom safe zone distance dp:${ScreenUtil().bottomBarHeight}dp');
    log('Status bar height dp:${ScreenUtil().statusBarHeight}dp');
    log('The ratio of actual width to UI design:${ScreenUtil().scaleWidth}');
    log('The ratio of actual height to UI design:${ScreenUtil().scaleHeight}');
    log('System font scaling:${ScreenUtil().textScaleFactor}');
    log('0.5 times the screen width:${0.5.sw}dp');
    log('0.5 times the screen height:${0.5.sh}dp');
    log('--------------------Screen orientation:${ScreenUtil().orientation}');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_showDialog) {
          _permissions(true);
        }
        log('-${(!_showDialog)}----------Resumed-${AppLifecycleState.resumed.name}');
        break;
      case AppLifecycleState.inactive:
      // --
        log('-----------Inactive');
        break;
      case AppLifecycleState.paused:
      // --
        log('-----------Paused');
        break;
      case AppLifecycleState.detached:
      // --
        log('-----------Detached');
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
        break;
    }
  }
}

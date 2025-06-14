import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
//https://www.google.com/search?sxsrf=ALiCzsZ6BrU1Q5yVyq3Zh-eU_5n05BfVxg:1653107424119&q=patient+icon&tbm=isch&chips=q:patient+icon,g_1:vector:Jh8fCAlHjXA%3D&usg=AI4_-kStYnyVy43UM4gFl2-_OD7VF-jo2Q&sa=X&ved=2ahUKEwjn66iG4e_3AhVT4oUKHaHKA1kQgIoDKAR6BAgCEA4&biw=1536&bih=764&dpr=1.25#imgrc=tj_HwFO7UeFypM
import '../../../component/logo.dart';
import '../../../mixin/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../mixin/mixins.dart';
import '../sign_up.dart';

class IPermission extends StatefulWidget {
  const IPermission({Key? key}) : super(key: key);

  @override
  State<IPermission> createState() => _IPermissionState();
}

class _IPermissionState extends State<IPermission> with WidgetsBindingObserver {

  bool poped = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log('----------${state}-----');

      if(poped) {
        poped = false;
        _permissions(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark, // dark text for status bar
        statusBarColor: Colors.transparent));

    return Scaffold(
      body: Container(
        color: xGreenPrimary.shade50,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             const Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.center,
                  child: ILogo()),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width/1.5,
              child: Text('The app requires these permissions to function properly, kindly allow them ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.workSans(fontSize: FONT_MEDIUM)),
            ),
             SizedBox(height: 34.h),
            Container(
              width: MediaQuery.of(context).size.width/2,
              height: 45.h,
              decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius:  const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Colors.black.withOpacity(.09), width: .4)),
              child: InkWell(
                onTap: () {
                  _permissions(true);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                    Icon(Icons.ad_units_outlined,),
                    SizedBox(width: 20),
                    Text("Grant  permissions", style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
             SizedBox(height: 74.h),
          ],
        ),
      ),
    );
  }

  Future<void> _permissions(bool show) async {
    if(show){Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
      Permission.locationWhenInUse,
    ].request();

      statuses.values.forEach((element) {
        //log('-------------------------------------------------${element}');
      });

    statuses.keys.forEach((element) {
      print('-------------------------${statuses[element]}------------------------${element}');
    });

    }

    bool showDialog = false;
    if (await Permission.notification.isPermanentlyDenied || await Permission.notification.isDenied) {
      showDialog = true;
    }

    if(showDialog) {
     permissionDialog(context, 'PERMISSIONS', "The app won't function without these permissions.\n\nOpen settings to retry?");
    }else {
      Mixin.navigate(context, const ISignUp());
    }
  }
}
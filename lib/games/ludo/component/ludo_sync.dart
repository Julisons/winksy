import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/quadrix/core/game_screen.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/screen/zoo/zoo.dart';

import '../../../component/app_bar.dart';
import '../../../mixin/mixins.dart';
import '../../../model/quad.dart';
import '../../../model/user.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../chess/chess.dart';
import '../ludo_dashboard.dart';


class ILudoSync extends StatefulWidget {

  ILudoSync({super.key});

  @override
  State<ILudoSync> createState() => _ILudoSyncState();
}

class _ILudoSyncState extends State<ILudoSync> {
  late Timer _timer;
  late var _loading = '...';
  final String loading1 = '.';
  final String loading2 = '..';
  final String loading3 = '...';

  var _waiting = 'Waiting for opponent';

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec, (Timer timer) {
          setState(() {
            if (_loading.isEmpty) {
              _loading = '.';
            } else if (_loading.length == 1) {
              _loading = loading2;
            } else if (_loading.length == 2) {
              _loading = loading3;
            } else if (_loading.length == 3) {
              _loading = '';
            }
          });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initSocket();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final List<ListItem> items = [
/*    ListItem(title: 'Hall of Fame', desc: 'Manage your account settings', icon: Icons.account_circle_outlined),
    ListItem(title: 'How to play', desc: 'Players you recently competed against',  icon: Icons.group),
    ListItem(title: 'Game Settings', desc: 'Customize your gameplay preferences', icon: Icons.settings),*/
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar:IAppBar(title: 'LUDO', leading: true,),
      body: Padding(
        padding:  EdgeInsets.all(16.0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_waiting, style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary)),
                      SizedBox(
                          width: 30.w,
                          child: Text(_loading, style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary))),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'Welcome to Ludo! '
                        'Roll the dice and race your tokens to the finish in this classic board game. '
                        'Challenge friends or play solo as you strategize and outmaneuver your opponents. '
                        'Use smart moves and a bit of luck to send others home and claim victory. '
                        'Fun, fast, and full of surprises — every roll brings a new chance to win!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: FONT_13,
                      color: color.xTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: SizedBox.shrink())
          ],
        ),
      ),
    );
  }

  Future<void> _initSocket() async {
    if (Mixin.quadrixSocket != null) {
      Mixin.quadrixSocket?.disconnect();
      Mixin.quadrixSocket?.dispose();
      Mixin.quadrixSocket = null;
    }

    Mixin.quadrixSocket = IO.io(IUrls.NODE_QUADRIX(), <String, dynamic>{
      'timeout': 9000,
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
    });

    Mixin.quadrixSocket?.on('connect_error', (c) {
      log(c.toString());
    });

    Mixin.quadrixSocket?.connect();

    Mixin.quadrixSocket?.onConnect((_) {
       Mixin.quad = Quad()
         ..quadType = QUADRIX
         ..quadUser =  Mixin.user?.usrFirstName
         ..quadUsrId = Mixin.user?.usrId;
       Mixin.quadrixSocket?.emit('joinRoom', Mixin.quad?.toJson());
    });

    Mixin.quadrixSocket?.on('roomJoined', (message) {
      print(jsonEncode(message));
      Mixin.quad = Quad.fromJson(message);

      /**
      * I AM THE INITIATOR
      */
      if(Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString()) {
        Mixin.vibrate();
        if(Mixin.quad?.quadStatus == PAIRED){
          Mixin.winkser = User()
            ..usrId = Mixin.quad?.quadAgainstId
            ..usrFullNames = Mixin.quad?.quadAgainst;

          setState(() {
            _timer.cancel();
            _loading = '';
            _waiting = 'Gaming with ${Mixin.quad?.quadAgainst}';

            Future.delayed(Duration(seconds: 4), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const SecondScreen(selectedPlayerCount: 2),
                ),
              );
            });
          });
        }else {
          //WAITING IN ROOM
          return;
        }
      }else
        /**
         * I JOINED A WAITING USER
         */
      if(Mixin.user?.usrId.toString() == Mixin.quad?.quadAgainstId.toString()){
        Mixin.vibrate();
        Mixin.winkser = User()
          ..usrId = Mixin.quad?.quadUsrId
          ..usrFullNames = Mixin.quad?.quadUser;

        setState(() {
          _timer.cancel();
          _loading = '';
          _waiting = 'Gaming with ${Mixin.quad?.quadUser}';

          Future.delayed(Duration(seconds: 4), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const SecondScreen(selectedPlayerCount: 2),
              ),
            );
          });
        });

      }
    });
  }
}
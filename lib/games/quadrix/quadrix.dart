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

import '../../component/app_bar.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../model/user.dart';
import '../../request/posts.dart';
import '../../request/urls.dart';
import '../../theme/custom_colors.dart';



class ListItem {
  final String title;
  final String desc;
  final IconData icon;
  ListItem({required this.title, required this.desc, required this.icon});
}

class IQuadrix extends StatefulWidget {

  IQuadrix({super.key});

  @override
  State<IQuadrix> createState() => _IQuadrixState();
}

class _IQuadrixState extends State<IQuadrix> {
  late Timer _timer;
  late Timer? _aiFallbackTimer;
  late var _loading = '...';
  final String loading1 = '.';
  final String loading2 = '..';
  final String loading3 = '...';

  var _waiting = 'Waiting for opponent';
  bool _hasFoundOpponent = false;

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

  void _startAIFallbackTimer() {
    // Start 30-second timer for AI fallback
    _aiFallbackTimer = Timer(Duration(seconds: 30), () {
      if (!_hasFoundOpponent && mounted) {
        print('🤖 No opponent found in 30 seconds - creating AI Guest opponent');
        _createGuestOpponent();
      }
    });
  }

  void _createGuestOpponent() {
    if (_hasFoundOpponent) return; // Safety check
    
    _hasFoundOpponent = true;
    
    // Create Guest user (AI opponent)
    Mixin.winkser = User()
      ..usrId = 'GUEST_AI_OPPONENT'
      ..usrFullNames = 'Guest';
    
    // Set up quad for AI mode
    Mixin.quad = Quad()
      ..quadId =  Mixin.quad?.quadId
      ..quadType = 'AI_MODE'
      ..quadAgainst = 'Guest'
      ..quadUsrId = Mixin.user?.usrId
      ..quadAgainstId = '2732c12e-d4dd-40a8-97ac-186d6fd91159'
      ..quadFirstPlayerId = Mixin.user?.usrId
      ..quadStatus = 'PAIRED'
      ..quadDesc = 'Hard'; // Guest uses Hard difficulty (only mode available)

    IPost.postData(Mixin.quad, (state, res, value) {
      if (!state) {Mixin.errorDialog(context, 'ERROR', res);}
    }, IUrls.QUADRIX());

    setState(() {
      _timer.cancel();
      _aiFallbackTimer?.cancel();
      _loading = '';
      _waiting = 'Gaming with Guest';

      Future.delayed(Duration(seconds: 4), () {
        if (mounted) {
          Mixin.navigate(context, IQuadrixScreen());
        }
      });
    });

    // Disconnect socket since we're going AI mode
    Mixin.quadrixSocket?.disconnect();
    Mixin.quadrixSocket?.dispose();
    Mixin.quadrixSocket = null;
  }

  @override
  void initState() {
    super.initState();
    _initSocket();
    _startTimer();
    _startAIFallbackTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _aiFallbackTimer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar:IAppBar(title: 'Quadrix', leading: true,),
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
                      _waiting.contains('Gaming with') 
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Gaming with ',
                                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR, color: color.xTextColorSecondary),
                                ),
                                TextSpan(
                                  text: _waiting.substring('Gaming with '.length),
                                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR, color: color.xTrailing),
                                ),
                              ],
                            ),
                          )
                        : Text(_waiting, style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary)),
                      SizedBox(
                          width: 30.w,
                          child: Text(_loading, style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary))),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text('Welcome to Quadrix! This is a game where you can challenge your friends and family in a fun and strategic way. Choose from various game modes and customize your experience to suit your preferences.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
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
        if(Mixin.quad?.quadStatus == PAIRED){
          // Real opponent found - cancel AI fallback
          _hasFoundOpponent = true;
          _aiFallbackTimer?.cancel();
          
          Mixin.winkser = User()
            ..usrId = Mixin.quad?.quadAgainstId
            ..usrFullNames = Mixin.quad?.quadAgainst;

          setState(() {
            _timer.cancel();
            _loading = '';
            _waiting = 'Gaming with ${Mixin.quad?.quadAgainst}';

            Mixin.vibrate(duration: 130);
            Future.delayed(Duration(seconds: 5), () {
               Mixin.navigate(context,IQuadrixScreen());
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
        // Real opponent found - cancel AI fallback
        _hasFoundOpponent = true;
        _aiFallbackTimer?.cancel();
        
        Mixin.vibrate();
        Mixin.winkser = User()
          ..usrId = Mixin.quad?.quadUsrId
          ..usrFullNames = Mixin.quad?.quadUser;

        setState(() {
          _timer.cancel();
          _loading = '';
          _waiting = 'Gaming with ${Mixin.quad?.quadUser}';

          Mixin.vibrate(duration: 130);
          Future.delayed(Duration(seconds: 5), () {
              Mixin.navigate(context,IQuadrixScreen());
          });
        });

      }
    });
  }
}
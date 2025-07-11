import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/chess/chess_game.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/app_bar.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../model/user.dart';
import '../../request/urls.dart';
import '../../theme/custom_colors.dart';



class ListItem {
  final String title;
  final String desc;
  final IconData icon;
  ListItem({required this.title, required this.desc, required this.icon});
}

class IChess extends StatefulWidget {

  IChess({super.key});

  @override
  State<IChess> createState() => _IChessState();
}

class _IChessState extends State<IChess> {
  late Timer _timer;
  late Timer? _aiFallbackTimer;
  late var _loading = '...';
  final String loading1 = '.';
  final String loading2 = '..';
  final String loading3 = '...';
  bool _hasFoundOpponent = false;

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
      ..usrId = 'CHESS_GUEST_AI_OPPONENT'
      ..usrFullNames = 'Guest';
    
    // Set up quad for AI mode
    Mixin.quad = Quad()
      ..quadId = Mixin.quad?.quadId
      ..quadType = 'AI_MODE'
      ..quadAgainst = 'Guest'
      ..quadUsrId = Mixin.user?.usrId
      ..quadAgainstId = 'CHESS_GUEST_AI_OPPONENT'
      ..quadFirstPlayerId = Mixin.user?.usrId
      ..quadStatus = 'PAIRED'
      ..quadDesc = 'Medium'; // Guest uses Medium difficulty

    setState(() {
      _timer.cancel();
      _aiFallbackTimer?.cancel();
      _loading = '';
      _waiting = 'Gaming with Guest';

      Future.delayed(Duration(seconds: 4), () {
        if (mounted) {
          Mixin.navigate(context, IChessGame());
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
      appBar:IAppBar(title: 'Chess', leading: true,),
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
                  SizedBox(height: 20.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: _waiting.contains('Gaming with ') ? 'Gaming with ' : _waiting,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary),
                          children: _waiting.contains('Gaming with ') ? [
                            TextSpan(
                              text: _waiting.replaceFirst('Gaming with ', ''),
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTrailing),
                            ),
                          ] : [],
                        ),
                      ),
                      SizedBox(
                          width: 30.w,
                          child: Text(_loading, style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary))),
                    ],
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/1.5,
                    child: Text(
                      'Welcome to Chess! '
                          'Enter the battlefield of kings and queens in this ultimate strategy game. '
                          'Outsmart your opponent with clever tactics and masterful moves. '
                          'Play casually with friends or challenge yourself in competitive mode. '
                          'Think ahead, plan wisely — every move counts in the game of champions.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: FONT_13,
                        color: color.xTextColor,
                      ),
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
       ..quadType = CHESS
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
            ..usrFirstName = Mixin.quad?.quadAgainst;

          setState(() {
            _timer.cancel();
            _loading = '';
            _waiting = 'Gaming with ${Mixin.quad?.quadAgainst}';

            Future.delayed(Duration(seconds: 4), () {
               Mixin.navigate(context,IChessGame());
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

        Mixin.winkser = User()
          ..usrId = Mixin.quad?.quadUsrId
          ..usrFirstName = Mixin.quad?.quadUser;

        setState(() {
          _timer.cancel();
          _loading = '';
          _waiting = 'Gaming with ${Mixin.quad?.quadUser}';

          Future.delayed(Duration(seconds: 4), () {
              Mixin.navigate(context,IChessGame());
          });
        });

      }
    });
  }
}
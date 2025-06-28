import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:winksy/games/quadrix/quadrix_dashboard.dart';
import 'package:winksy/screen/home/home.dart';

import '../../../component/button.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/quad.dart';
import '../../../theme/custom_colors.dart';
import '../components/game_board.dart';
import '../components/player_turn_widget.dart';
import '../utils/game_logic.dart';

// ignore: must_be_immutable
class IQuadrixScreen extends StatefulWidget {
  IQuadrixScreen({super.key});

  @override
  State<IQuadrixScreen> createState() => _IQuadrixScreenState();
}

class _IQuadrixScreenState extends State<IQuadrixScreen> {

  GlobalKey<GameBoardState> gameBoardKey = GlobalKey<GameBoardState>();

  GlobalKey<PlayerTurnWidgetState> playerTurnKey = GlobalKey<PlayerTurnWidgetState>();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    var appBar = AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Transform(
        transform: Matrix4.translationValues(10, 0.0, 0.0),
        child: SizedBox(
            width: 310.w,
            height: 120.h,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Text("",
                  style: GoogleFonts.poppins(
                    color: color.xTrailing, fontSize: 34, fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'How to play?',
          onPressed: () {
            launchUrlString('https://en.wikipedia.org/wiki/Connect_Four');
          },
          icon: const Icon(
            Icons.info_outline_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.xPrimaryColor,
              color.xSecondaryColor,
            ],
            stops: const [0.45, 1],
          ),
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
            ),
            GameBoard(
              key: gameBoardKey,
              playerTurnKey: playerTurnKey,
              gameBoardKey: gameBoardKey,
              onRefresh: () {
                setState(() {});
              },
            ),
            Positioned(
              top: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  appBar.preferredSize.height) /
                  2 -
                  (MediaQuery.of(context).size.width - 20) / 2 -
                  50,
              child: PlayerTurnWidget(key: playerTurnKey),

            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Restart game',
        child: InkWell(
          onTap: () {
            setState(() {});
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Text("Do You Really Want To Restart ?"),
                    actions: [
                      TextButton(
                          onPressed: (() {
                            Navigator.pop(context);
                            return onRestart(
                              gameBoardKey: gameBoardKey,
                              playerTurnKey: playerTurnKey,
                              context: context,
                            );
                          }),
                          child: Text("Yes"))
                    ],
                  );
                });
          },
          child: InkWell(
            onTap: () {
              showDialog(context: context,
                builder: (context) {
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    backgroundColor: color.xSecondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    content: Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      padding: EdgeInsets.all(16.h),
                      child: Text('Quitting will end the game and count as a defeat!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: FONT_13,
                          color: color.xTextColorSecondary,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    title: Text(
                      'QUIT GAME',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color.xTextColorSecondary,
                        fontSize: FONT_TITLE,
                      ),
                    ),
                    actions: [
                      IButton(
                        text: "Resume",
                        color: color.xPrimaryColor,
                        textColor: Colors.white,
                        height: 40.h,
                        width: MediaQuery.of(context).size.width/3.5,
                        onPress:(){
                          Navigator.of(context).pop();
                        },
                      ),
                      IButton(
                        text: "Quit game",
                        color: color.xTrailingAlt,
                        height: 40.h,
                        width: MediaQuery.of(context).size.width/3.5,
                        textColor: color.xTextColor,
                        fontWeight: FontWeight.bold,
                        onPress: () {
                          dispose();
                          Mixin.pop(context, IHome());
                        },
                      )
                    ],
                  );
                },
              );
            },
            child: Container(
              width: 130,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: color.xPrimaryColor
              ),
              alignment: Alignment.center,
              child:  Text(
                'Give up',
                style: TextStyle(
                  color: color.xTextColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  @override
  void dispose() {
    super.dispose();
    gameBoardKey.currentState?.dispose();
    playerTurnKey.currentState?.dispose();
    return onRestart(
      gameBoardKey: gameBoardKey,
      playerTurnKey: playerTurnKey,
      context: context,
    );
  }
}

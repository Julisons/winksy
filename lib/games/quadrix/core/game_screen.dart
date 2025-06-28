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
                setState(() {
                  // This will trigger a rebuild when game state changes
                });
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
        message: end ? 'Play again' : 'Give up',
        child: InkWell(
          onTap: () {
            if (end) {
              // Game has ended - show play again dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    backgroundColor: color.xSecondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    content: Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      padding: EdgeInsets.all(16.h),
                      child: Text(_getGameEndMessage(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: FONT_13,
                          color: color.xTextColorSecondary,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    title: Text(
                      'GAME OVER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color.xTextColorSecondary,
                        fontSize: FONT_TITLE,
                      ),
                    ),
                    actions: [
                      IButton(
                        text: "Home",
                        color: color.xTrailingAlt,
                        height: 40.h,
                        width: MediaQuery.of(context).size.width/3.5,
                        textColor: color.xTextColor,
                        fontWeight: FontWeight.bold,
                        onPress: () {
                          dispose();
                          Mixin.pop(context, IHome());
                        },
                      ),
                      IButton(
                        text: "Play Again",
                        color: color.xPrimaryColor,
                        textColor: Colors.white,
                        height: 40.h,
                        width: MediaQuery.of(context).size.width/3.5,
                        onPress: () {
                          Navigator.of(context).pop();
                          Mixin.pop(context, IQuadrixDashboard());
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              // Game is ongoing - show quit dialog
              showDialog(
                context: context,
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
            }
          },
          child: Container(
            width: 130.w,
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: end ? color.xTrailing : color.xPrimaryColor
            ),
            alignment: Alignment.center,
            child: Text(
              end ? 'Play Again' : 'Give up',
              style: TextStyle(
                color: Colors.white,
                fontSize: FONT_13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getGameEndMessage() {
    final result = didEnd();
    if (result == Result.draw) {
      return "It's a draw! Well played!";
    } else if (result == Result.player1) {
      return Mixin.quad?.quadFirstPlayerId.toString() == Mixin.user?.usrId.toString()
          ? "Congratulations! You won!"
          : "${Mixin.quad?.quadUser ?? 'Player 1'} wins!";
    } else if (result == Result.player2) {
      return Mixin.quad?.quadFirstPlayerId.toString() != Mixin.user?.usrId.toString()
          ? "Congratulations! You won!"
          : "${Mixin.quad?.quadAgainst ?? 'Player 2'} wins!";
    }
    return "Game Over!";
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
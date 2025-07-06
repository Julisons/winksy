import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../theme/theme_data_style.dart';
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
    final color = ThemeDataStyle.darker.extension<CustomColors>()!;
    return WillPopScope(
      onWillPop: () async {
        return await _showGiveUpDialog(context);
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background/quadrix.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 PlayerTurnWidget(key: playerTurnKey),
                 SafeArea(
                   child: GameBoard(
                    key: gameBoardKey,
                    playerTurnKey: playerTurnKey,
                    gameBoardKey: gameBoardKey,
                    onRefresh: () {
                      setState(() {
                        // This will trigger a rebuild when game state changes
                      });
                    }),
                 ),

                Align(
                  alignment: Alignment.center,
                  child: Tooltip(
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
                                    color: color.xSecondaryColor,
                                    height: 40.h,
                                    width: MediaQuery.of(context).size.width/3.5,
                                    textColor: color.xTextColor,
                                    fontWeight: FontWeight.bold,
                                    onPress: () {
                                      onRestart(
                                        gameBoardKey: gameBoardKey,
                                        playerTurnKey: playerTurnKey,
                                        context: context,
                                      );
                                      Mixin.pop(context, IHome());
                                    },
                                  ),
                                  IButton(
                                    text: "Play Again",
                                    color: color.xSecondaryColor,
                                    textColor: color.xTrailing,
                                    height: 40.h,
                                    width: MediaQuery.of(context).size.width/3.5,
                                    onPress: () {
                                      onRestart(
                                        gameBoardKey: gameBoardKey,
                                        playerTurnKey: playerTurnKey,
                                        context: context,);
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
                                    color: color.xSecondaryColor,
                                    textColor: color.xTextColor,
                                    height: 40.h,
                                    width: MediaQuery.of(context).size.width/3.5,
                                    onPress:(){
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  IButton(
                                    text: "Quit game",
                                    color: color.xSecondaryColor,
                                    height: 40.h,
                                    width: MediaQuery.of(context).size.width/3.5,
                                    textColor: color.xTrailing,
                                    fontWeight: FontWeight.bold,
                                    onPress: () {

                                      Quad quad = Quad()
                                        ..quadState = 'GAVE_UP'
                                        ..quadWinnerId = Mixin.user?.usrId == Mixin.quad?.quadUsrId ? Mixin.quad?.quadAgainstId : Mixin.quad?.quadUsrId
                                        ..quadId = Mixin.quad?.quadId;

                                      Mixin.quadrixSocket?.emit('give_up', quad.toJson());

                                      onRestart(
                                          gameBoardKey: gameBoardKey,
                                          playerTurnKey: playerTurnKey,
                                          context: context);

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
                        padding: EdgeInsets.symmetric(horizontal: 10.w, ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: end ? color.xTrailing : color.xPrimaryColor
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          end ? 'Play Again' : 'Give up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: FONT_13,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ]),
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
      // Check if this is AI mode
      if (Mixin.quad?.quadType == 'AI_MODE') {
        return "Congratulations! You won!";
      } else {
        return Mixin.quad?.quadFirstPlayerId.toString() == Mixin.user?.usrId.toString()
            ? "Congratulations! You won!"
            : "${Mixin.quad?.quadUser ?? 'Player 1'} wins!";
      }
    } else if (result == Result.player2) {
      // Check if this is AI mode
      if (Mixin.quad?.quadType == 'AI_MODE') {
        return "${Mixin.quad?.quadAgainst ?? 'Guest'} wins!";
      } else {
        return Mixin.quad?.quadFirstPlayerId.toString() != Mixin.user?.usrId.toString()
            ?  "${Mixin.quad?.quadAgainst ?? 'Player 2'} wins!"
            : "Congratulations! You won!";
      }
    }
    return "Game Over!";
  }

  @override
  void initState() {
    super.initState();
    // Hide status bar and navigation bar for full immersion
   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  @override
  void dispose() {
    super.dispose();
    // Restore system UI when leaving the game
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return onRestart(
      gameBoardKey: gameBoardKey,
      playerTurnKey: playerTurnKey,
      context: context,
    );
  }

  Future<bool> _showGiveUpDialog(BuildContext context) async {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          backgroundColor: color.xSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          title: Text(
            'Give Up Game?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color.xTextColor,
              fontSize: FONT_TITLE,
            ),
          ),
          content: Text(
            'Are you sure you want to quit the game? This will count as a loss.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FONT_13,
              color: color.xTextColorSecondary,
              fontWeight: FontWeight.w300,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop()
              },
              child: Text(
                'Continue Playing',
                style: TextStyle(color: color.xTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Mixin.pop(context, IHome());
              },
              child: Text(
                'Give Up',
                style: TextStyle(color: color.xTrailing),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }
}
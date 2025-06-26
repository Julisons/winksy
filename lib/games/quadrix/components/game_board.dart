import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../component/button.dart';
import '../../../component/game_button.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/quad.dart';
import '../../../theme/custom_colors.dart';
import '../core/game_screen.dart';
import '../models/coin.dart';
import '../quadrix_dashboard.dart';
import '../utils/game_logic.dart';
import 'game_coin_widget.dart';

// ignore: must_be_immutable
class GameBoard extends StatefulWidget {
  GameBoard({super.key, required this.playerTurnKey, required this.gameBoardKey});
  GlobalKey gameBoardKey;
  GlobalKey playerTurnKey;

  @override
  State<GameBoard> createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  late Quad _quad = Quad();
  bool play = true;

  @override
  void initState() {
    super.initState();

    if(Mixin.quad?.quadFirstPlayerId.toString() == Mixin.user?.usrId.toString()){
      quadPlayer = "You start";
    }else{
      quadPlayer = Mixin.quad?.quadPlayer+" starts";
    }

    _play();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      height: MediaQuery.of(context).size.width - 20,
      width: MediaQuery.of(context).size.width - 20,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: gameState.map((row) {
          return Row(
            children: row.map((coin) {
              return InkWell(
                onTap: () async {
                  if (end == false) {

                    /**
                     *
                     * IF ITS NOT YOUR TURN , DON'T PLAY
                     */
                    if(_quad.quadPlayerId == null){
                      if (Mixin.user?.usrId.toString() != Mixin.quad?.quadFirstPlayerId.toString()) {
                        return;
                      }
                    }else {
                      if (Mixin.user?.usrId.toString() != _quad.quadPlayerId.toString()) {
                        return;
                      }
                    }

                    if(!play){
                      log('$play');
                      return;
                    }

                    if(play) {
                      play = false;
                    }

                    if(Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString()) {
                      quadPlayer = '${Mixin.quad?.quadAgainst}\'s turn';
                    }else {
                      quadPlayer = '${Mixin.quad?.quadUser}\'s turn';
                    }

                    await onPlay(
                        coin: Coin(
                          row: coin['row'] as int,
                          column: coin['column'] as int,
                          selected: false,
                          color: color.xSecondaryColor,
                        ),
                        playerTurnKey: widget.playerTurnKey,
                        gameBoardKey: widget.gameBoardKey);

                    Quad quad = Quad()
                      ..quadRow = coin['row'] as int
                      ..quadColumn =  coin['column'] as int
                      ..quadUsrId = Mixin.user?.usrId
                      ..quadPlayer = Mixin.user?.usrFullNames
                      ..quadPlayerId = Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString() ?  Mixin.quad?.quadAgainstId : Mixin.quad?.quadUsrId
                      ..quadId = Mixin.quad?.quadId;

                    Result result = didEnd();
                    _end(result);

                    Mixin.quadrixSocket?.emit('played', quad.toJson());

                    //stop the game if the game has ended
                    if (result != Result.play) {
                      setState(() {});
                      showDialog(context: context,
                        builder: (context) {

                          Quad quad = Quad()
                            ..quadState = result.name.toString().toUpperCase()
                            ..quadWinnerId = (result == Result.player1) ? Mixin.user?.usrId : Mixin.quad?.quadId
                            ..quadId = Mixin.quad?.quadId;

                          Mixin.quadrixSocket?.emit('win', quad.toJson());

                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            backgroundColor: color.xSecondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            content: Container(
                              width: MediaQuery.of(context).size.width-20,
                              padding: EdgeInsets.all(16.h),
                              child: Text('You Win',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: FONT_13,
                                  color: color.xTextColorSecondary,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            title: Text(
                              'GAME OVER!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: color.xTextColor,
                                fontSize: FONT_TITLE,
                              ),
                            ),
                            actions: [
                              IButton(
                                text: "Hall of Fame",
                                color: color.xPrimaryColor,
                                textColor: Colors.white,
                                height: 40.h,
                                width: MediaQuery.of(context).size.width/3.5,
                                onPress:(){
                                  Navigator.of(context).pop();
                                  // Mixin.pop(context,IQuadrixFameHall());
                                },
                              ),
                              IButton(
                                text: "Play Again",
                                color: color.xTrailingAlt,
                                height: 40.h,
                                width: MediaQuery.of(context).size.width/3.5,
                                textColor: Colors.white,
                                onPress: () {
                                  // Navigator.of(context).pop();
                                  Mixin.navigate(context,IQuadrixScreen());
                                },
                              )
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Game Over!',
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        backgroundColor: Colors.black,
                      ),
                    );
                  }
                },
                child: GameCoinWidget(
                  coin: (coin['value'] == 0)
                      ? Coin(
                    row: coin['row'] as int,
                    column: coin['column'] as int,
                    selected: false,
                    color: color.xSecondaryColor,
                  )
                      : (coin['value'] == 1)
                      ? Coin(
                    row: coin['row'] as int,
                    column: coin['column'] as int,
                    selected: true,
                    color: playerOneColor,
                  )
                      : (coin['value'] == 2)
                      ? Coin(
                    row: coin['row'] as int,
                    column: coin['column'] as int,
                    selected: true,
                    color: playerTwoColor,
                  )
                      : Coin(
                    row: coin['row'] as int,
                    column: coin['column'] as int,
                    selected: true,
                    color: Colors.red,
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  void _play(){
      Mixin.quadrixSocket?.on('play', (message) async {

      print(jsonEncode(message));
      _quad = Quad.fromJson(message);

      /**
       * THIS MOVE IS FROM ME, SO JUST IGNORE
       */
      if(Mixin.user?.usrId.toString() == _quad.quadUsrId.toString()) {
        return;
      }

      if(Mixin.user?.usrId.toString() == _quad.quadPlayerId.toString()) {
        quadPlayer = 'Your turn';
      }else {
        quadPlayer = '${_quad.quadPlayer}\'s turn';
      }

      await onPlay(coin: Coin(
        row: int.parse(_quad.quadRow.toString()),
        column: int.parse(_quad.quadColumn.toString()),
        selected: false,
        color: Theme.of(context).extension<CustomColors>()!.xSecondaryColor,
      ),

      playerTurnKey: widget.playerTurnKey,
      gameBoardKey: widget.gameBoardKey);

      play = true;

      setState(()  {
        if (end == false) {
          Result result = didEnd();
          _end(result);
          //stop the game if the game has ended
          if (result != Result.play) {
            setState(() {});
            final color = Theme.of(context).extension<CustomColors>()!;
            showDialog(
              context: context,
              builder: (context) {
                var quadWinnerId = Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId ? Mixin.quad?.quadUsrId : Mixin.quad?.quadAgainstId;
                log('------------------------------$quadWinnerId------------------------------dwinder');

                Quad quad = Quad()
                  ..quadState = result.name.toUpperCase()
                  ..quadWinnerId = quadWinnerId
                  ..quadId = Mixin.quad?.quadId;

                Mixin.quadrixSocket?.emit('win', quad.toJson());

                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  backgroundColor: color.xSecondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  content: Container(
                    width: MediaQuery.of(context).size.width-20,
                    padding: EdgeInsets.all(16.h),
                    child: Text(
                      (result == Result.draw)
                          ? 'It\'s a tie'
                          : (result == Result.player1)
                          ? (Mixin.quad?.quadFirstPlayerId.toString() == Mixin.quad?.quadUsrId.toString()
                          ? '${Mixin.quad?.quadUser} Wins' : '${Mixin.quad?.quadAgainst} Wins')
                          : (Mixin.quad?.quadFirstPlayerId.toString() == Mixin.quad?.quadUsrId.toString()
                          ? '${Mixin.quad?.quadAgainst} Wins' : '${Mixin.quad?.quadUser} Wins'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FONT_13,
                        color: color.xTextColorSecondary,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  title: Text(
                    'GAME OVER!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color.xTextColor,
                      fontSize: FONT_TITLE,
                    ),
                  ),
                  actions: [
                    IButton(
                      text: "Hall of Fame",
                      color: color.xPrimaryColor,
                      textColor: Colors.white,
                      height: 40.h,
                      width: MediaQuery.of(context).size.width/3.5,
                      onPress:(){
                        Navigator.of(context).pop();
                        // Mixin.pop(context,IQuadrixFameHall());
                      },
                    ),
                    IButton(
                      text: "Play Again",
                      color: color.xTrailingAlt,
                      height: 40.h,
                      width: MediaQuery.of(context).size.width/3.5,
                      textColor: Colors.white,
                      onPress: () {
                        // Navigator.of(context).pop();
                        Mixin.navigate(context,IQuadrixScreen());
                      },
                    )
                  ],
                );
              },
            );
          }
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Game Over!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.black,
            ),
          );
        }
      });
    });
  }

  void _end(Result result){
    if(result == Result.draw) {
      Mixin.vib();
      AudioPlayer().play(AssetSource('audio/sound/win.wav')); // Your sound file
    }else if(result == Result.player1 || result == Result.player2){
      Mixin.vib();
      AudioPlayer().play(AssetSource('audio/sound/win2.wav')); // Your sound file
    }
  }
}
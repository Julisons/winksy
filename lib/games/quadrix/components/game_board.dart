import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../component/game_button.dart';
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

                    Mixin.quadrixSocket?.emit('played', quad.toJson());

                    Result result = didEnd();
                    //stop the game if the game has ended
                    if (result != Result.play) {
                      setState(() {});
                      showDialog(context: context,
                        builder: (context) {

                          print('--------$quadPlayer----------------_quad-------- ${_quad.toJson()}');

                          return AlertDialog(
                            backgroundColor: (result == Result.draw)
                                ? color.xSecondaryColor
                                : color.xTrailing,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            content: Text(
                              (result == Result.draw) ? 'It\'s a tie'
                                  : (result == Result.player1) ? (Mixin.quad?.quadFirstPlayerId.toString() == Mixin.user?.usrId.toString()
                                             ? 'You Win' : '') : 'You Win',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            title: Text(
                              'GAME OVER!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 28,
                              ),
                            ),
                            actions: [
                              GameButton(
                                text: "Hall of Fame",
                                onPressed: () {
                                  Mixin.pop(context,IQuadrixDashboard());
                                },
                              ),

                              GameButton(
                                text: "Play Again",
                                onPressed: () {
                                  // Your action here
                                  Mixin.pop(context,IQuadrixScreen());
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

      setState(()  {
        if (end == false) {
          Result result = didEnd();
          //stop the game if the game has ended
          if (result != Result.play) {
            setState(() {});
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: (result == Result.draw)
                      ? Theme.of(context).extension<CustomColors>()!.xSecondaryColor
                      : Theme.of(context).extension<CustomColors>()!.xTrailing,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  content: Text(
                    (result == Result.draw)
                        ? 'It\'s a tie'
                        : (result == Result.player1)
                        ? (Mixin.quad?.quadFirstPlayerId.toString() == Mixin.quad?.quadUsrId.toString()
                        ? '${Mixin.quad?.quadUser} Wins' : '${Mixin.quad?.quadAgainst} Wins')
                        : (Mixin.quad?.quadFirstPlayerId.toString() == Mixin.quad?.quadUsrId.toString()
                        ? '${Mixin.quad?.quadAgainst} Wins' : '${Mixin.quad?.quadUser} Wins'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  title: Text(
                    'GAME OVER!',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
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
}

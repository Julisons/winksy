import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/app_bar.dart';
import '../../component/glow2.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../theme/custom_colors.dart';



class ITicTacToeGame extends StatefulWidget {
  const ITicTacToeGame({super.key});

  @override
  _ITicTacToeGameState createState() => _ITicTacToeGameState();
}

class _ITicTacToeGameState extends State<ITicTacToeGame> {

  List<List<String>> board = [];
  String currentPlayer = '';
  late Quad _quad = Quad();
  String quadPlayer = '';
  @override
  void initState() {
    super.initState();

    if(Mixin.quad?.quadFirstPlayerId.toString() == Mixin.user?.usrId.toString()){
      quadPlayer = "You start";
    }else{
      quadPlayer = Mixin.quad?.quadPlayer+" starts";
    }

    _play();
    initializeGame();
  }

  void initializeGame() {
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = 'X';
    setState(() {

    });
  }

  void onCellTapped(int row, int col) {
    AudioPlayer().play(AssetSource('sound/tick.wav')); // Your sound file
    if (board[row][col].isEmpty) {
      setState(() {
        board[row][col] = currentPlayer;
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      });

      String winner = checkForWinner();

      if (winner.isNotEmpty) {

        Quad quad = Quad()
          ..quadState = winner.toUpperCase()
          ..quadWinnerId = (currentPlayer == 'X')  ? Mixin.user?.usrId : Mixin.quad?.quadId
          ..quadId = Mixin.quad?.quadId;

        Mixin.quadrixSocket?.emit('win', quad.toJson());

        _end(winner);
        showWinnerDialog(winner);
      }
    }
  }

  String checkForWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0].isNotEmpty) {
        return board[i][0];
      }
      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i].isNotEmpty) {
        return board[0][i];
      }
    }
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0].isNotEmpty) {
      return board[0][0];
    }
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2].isNotEmpty) {
      return board[0][2];
    }

    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          isDraw = false;
          break;
        }
      }
    }
    if (isDraw) {
      return 'Draw';
    }

    return '';
  }

  void showWinnerDialog(String winner) {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text(winner == 'Draw' ? 'It\'s a draw!' : 'Player $winner wins!'),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  textAlign: TextAlign.justify,
                  quadPlayer,
                  style: TextStyle(fontSize: FONT_APP_BAR, color: color.xTextColorSecondary),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final row = index ~/ 3;
                final col = index % 3;
                return GestureDetector(
                  onTap: () {

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

                    Quad quad = Quad()
                      ..quadRow = row
                      ..quadColumn = col
                      ..quadUsrId = Mixin.user?.usrId
                      ..quadPlayer = Mixin.user?.usrFullNames
                      ..quadPlayerId = Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString() ?  Mixin.quad?.quadAgainstId : Mixin.quad?.quadUsrId
                      ..quadId = Mixin.quad?.quadId;

                    Mixin.quadrixSocket?.emit('played', quad.toJson());
                    onCellTapped(row, col);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: color.xSecondaryColor
                    ),
                    child: Center(
                      child: board[row][col] == 'O' ?
                      AnimatedGlowingLetter(
                        letter: board[row][col],
                        size: 85.sp,
                        color: color.xTrailing,
                        animationType: AnimationType.breathe,
                      ) :
                      AnimatedGlowingLetter(
                        letter: board[row][col],
                        size: 85.sp,
                        color: color.xTrailingAlt,
                        animationType: AnimationType.breathe
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: resetGame,
              child: Text('Quit Game'),
            ),
          ),
        ],
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
      onCellTapped(int.parse(_quad.quadRow.toString()),int.parse(_quad.quadColumn.toString()));
    });
  }

  void _end(String winner){
    if(winner == 'Draw') {
      AudioPlayer().play(AssetSource('sound/win.wav')); // Your sound file
    }else {
      AudioPlayer().play(AssetSource('sound/win2.wav')); // Your sound file
    }
  }
}

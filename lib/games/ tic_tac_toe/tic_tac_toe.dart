import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../component/app_bar.dart';
import '../../component/glow2.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';



class ITicTacToe extends StatefulWidget {
  const ITicTacToe({super.key});

  @override
  _ITicTacToeState createState() => _ITicTacToeState();
}

class _ITicTacToeState extends State<ITicTacToe> {

  List<List<String>> board = [];
  String currentPlayer = '';

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = 'X';
    setState(() {

    });
  }

  void onCellTapped(int row, int col) {
    Mixin.playerSound.play(AssetSource('sound/tick.wav')); // Your sound file
    if (board[row][col].isEmpty) {
      setState(() {
        board[row][col] = currentPlayer;
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      });

      String winner = checkForWinner();
      if (winner.isNotEmpty) {
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
      appBar:IAppBar(title: 'Tic Tac Toe', leading: false,),
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
                  'Current Player: $currentPlayer',
                  style: TextStyle(fontSize: 24),
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
                  onTap: () => onCellTapped(row, col),
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
              child: Text('Reset Game'),
            ),
          ),
        ],
      ),
    );
  }

  void _end(String winner){
    if(winner == 'Draw') {
      Mixin.playerSound.play(AssetSource('sound/win.wav')); // Your sound file
    }else {
      Mixin.playerSound.play(AssetSource('sound/win2.wav')); // Your sound file
    }
  }
}

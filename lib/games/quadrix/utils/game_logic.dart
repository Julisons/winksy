import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:winksy/mixin/mixins.dart';
import '../models/coin.dart';



void playDropSound() {

}

Color playerOneColor = const Color(0xffff4d4d); // Vibrant Red
Color playerTwoColor = const Color(0xff2ecc71); // Lime Green

var currentPlayer = '';
//player = 1 if it's player 1's turn to play and 2 if it's player 2's turn to play
int player = 1;
String quadPlayer = '';
//count the number of turns
int turns = 0;
//end will be true if the game has ended
bool end = false;

//play means the game hasn't ended yet
//draw means the game is over and no one has won the game
//player1 means the game was won by player1
//player2 means the game was won by player2
enum Result { play, draw, player1, player2 }

List<int> fullColumns = [];

List<List<Map<String, int>>> gameState = [
  [
    {'row': 0, 'column': 0, 'value': 0},
    {'row': 0, 'column': 1, 'value': 0},
    {'row': 0, 'column': 2, 'value': 0},
    {'row': 0, 'column': 3, 'value': 0},
    {'row': 0, 'column': 4, 'value': 0},
    {'row': 0, 'column': 5, 'value': 0},
    {'row': 0, 'column': 6, 'value': 0},
  ],
  [
    {'row': 1, 'column': 0, 'value': 0},
    {'row': 1, 'column': 1, 'value': 0},
    {'row': 1, 'column': 2, 'value': 0},
    {'row': 1, 'column': 3, 'value': 0},
    {'row': 1, 'column': 4, 'value': 0},
    {'row': 1, 'column': 5, 'value': 0},
    {'row': 1, 'column': 6, 'value': 0},
  ],
  [
    {'row': 2, 'column': 0, 'value': 0},
    {'row': 2, 'column': 1, 'value': 0},
    {'row': 2, 'column': 2, 'value': 0},
    {'row': 2, 'column': 3, 'value': 0},
    {'row': 2, 'column': 4, 'value': 0},
    {'row': 2, 'column': 5, 'value': 0},
    {'row': 2, 'column': 6, 'value': 0},
  ],
  [
    {'row': 3, 'column': 0, 'value': 0},
    {'row': 3, 'column': 1, 'value': 0},
    {'row': 3, 'column': 2, 'value': 0},
    {'row': 3, 'column': 3, 'value': 0},
    {'row': 3, 'column': 4, 'value': 0},
    {'row': 3, 'column': 5, 'value': 0},
    {'row': 3, 'column': 6, 'value': 0},
  ],
  [
    {'row': 4, 'column': 0, 'value': 0},
    {'row': 4, 'column': 1, 'value': 0},
    {'row': 4, 'column': 2, 'value': 0},
    {'row': 4, 'column': 3, 'value': 0},
    {'row': 4, 'column': 4, 'value': 0},
    {'row': 4, 'column': 5, 'value': 0},
    {'row': 4, 'column': 6, 'value': 0},
  ],
  [
    {'row': 5, 'column': 0, 'value': 0},
    {'row': 5, 'column': 1, 'value': 0},
    {'row': 5, 'column': 2, 'value': 0},
    {'row': 5, 'column': 3, 'value': 0},
    {'row': 5, 'column': 4, 'value': 0},
    {'row': 5, 'column': 5, 'value': 0},
    {'row': 5, 'column': 6, 'value': 0},
  ],
  [
    {'row': 6, 'column': 0, 'value': 0},
    {'row': 6, 'column': 1, 'value': 0},
    {'row': 6, 'column': 2, 'value': 0},
    {'row': 6, 'column': 3, 'value': 0},
    {'row': 6, 'column': 4, 'value': 0},
    {'row': 6, 'column': 5, 'value': 0},
    {'row': 6, 'column': 6, 'value': 0},
  ],
];

void switchPlayer() {
  player = (player == 1) ? 2 : 1;
}

Future<void> playAnimation(
    {required int row,
    required int col,
    required GlobalKey gameBoardKey,
    required int player}) async {
  //play the coin dropping animation till row - 1 slot
  print(row);
  int i = 0;
  while (i < row) {
    gameState[i][col]['value'] = player;
    // ignore: invalid_use_of_protected_member
    gameBoardKey.currentState!.setState(() {});
    await Future.delayed(const Duration(milliseconds: 20)).then((val) {
      gameState[i][col]['value'] = 0;
      // ignore: invalid_use_of_protected_member
      gameBoardKey.currentState!.setState(() {});
      i++;
    });
  }

  //the bounce effect
  if (row >= 2) {
    i = row;
    while (i >= row - 2) {
      gameState[i][col]['value'] = player;
      // ignore: invalid_use_of_protected_member
      gameBoardKey.currentState!.setState(() {});
      await Future.delayed(const Duration(milliseconds: 30)).then((val) {
        gameState[i][col]['value'] = 0;
        // ignore: invalid_use_of_protected_member
        gameBoardKey.currentState!.setState(() {});
      });
      i--;
    }
    i += 2;
    gameState[i][col]['value'] = player;
    // ignore: invalid_use_of_protected_member
    gameBoardKey.currentState!.setState(() {});
    await Future.delayed(const Duration(milliseconds: 20)).then((val) {
      gameState[i][col]['value'] = 0;
      // ignore: invalid_use_of_protected_member
      gameBoardKey.currentState!.setState(() {});
    });
  }

  return Future.value();
}

Future<void> onPlay(
    {required Coin coin,
    required GlobalKey playerTurnKey,
    required GlobalKey gameBoardKey}) async {


  Mixin.vibe();

  int column = coin.column;
  int i = 6;

  //get the topmost position where we the coin will be dropped into
  while (i >= 0 && gameState[i][column]['value'] != 0) {
    i--;
  }

  if (i == 0)//full columns
  {
      fullColumns.add(column);
  }

  //if i < 0 that means that the column is full and no coin can be inserted in that column
  if (i >= 0) {
    await playAnimation(
      row: i,
      col: column,
      gameBoardKey: gameBoardKey,
      player: player,
    );

    FlameAudio.play('piece_moved.mp3');
    gameState[i][column]['value'] = player;
    turns++;
    switchPlayer();
  }

  // ignore: invalid_use_of_protected_member
  gameBoardKey.currentState!.setState(() {});
  // ignore: invalid_use_of_protected_member
  playerTurnKey.currentState!.setState(() {});

  return Future.value();
}

class WinningCombination {
  final List<Position> positions;
  final String direction;

  WinningCombination({required this.positions, required this.direction});
}

class Position {
  final int row;
  final int col;

  Position(this.row, this.col);

  @override
  String toString() => '($row, $col)';
}

// Add this as a class property to store winning combinations
List<WinningCombination> winningCombinations = [];

Result didEnd() {
  // Clear previous winning combinations
  winningCombinations.clear();

  if (turns == 49) {
    end = true;
    return Result.draw;
  }

  for (int i = 0; i < gameState.length; i++) {
    for (int j = 0; j < gameState[i].length; j++) {
      //left
      if (gameState[i][j]['value'] == 0) continue;
      if (j >= 3 &&
          j <= 6 &&
          gameState[i][j]['value'] == gameState[i][j - 1]['value'] &&
          gameState[i][j - 1]['value'] == gameState[i][j - 2]['value'] &&
          gameState[i][j - 2]['value'] == gameState[i][j - 3]['value']) {
        Result result;
        if (gameState[i][j]['value'] == 1) {
          end = true;
          result = Result.player1;
        } else {
          end = true;
          result = Result.player2;
        }

        // Store winning combination
        winningCombinations.add(WinningCombination(
            positions: [
              Position(i, j),
              Position(i, j - 1),
              Position(i, j - 2),
              Position(i, j - 3),
            ],
            direction: 'horizontal'
        ));

        gameState[i][j]['value'] = gameState[i][j - 1]['value'] =
        gameState[i][j - 2]['value'] = gameState[i][j - 3]['value'] = 3;
        return result;
      }

      //right
      else if (j >= 0 &&
          j <= 3 &&
          gameState[i][j]['value'] == gameState[i][j + 1]['value'] &&
          gameState[i][j + 1]['value'] == gameState[i][j + 2]['value'] &&
          gameState[i][j + 2]['value'] == gameState[i][j + 3]['value']) {
        Result result;
        if (gameState[i][j]['value'] == 1) {
          end = true;
          result = Result.player1;
        } else {
          end = true;
          result = Result.player2;
        }

        // Store winning combination
        winningCombinations.add(WinningCombination(
            positions: [
              Position(i, j),
              Position(i, j + 1),
              Position(i, j + 2),
              Position(i, j + 3),
            ],
            direction: 'horizontal'
        ));

        gameState[i][j]['value'] = gameState[i][j + 1]['value'] =
        gameState[i][j + 2]['value'] = gameState[i][j + 3]['value'] = 3;
        return result;
      }

      //up
      else if (i >= 3 &&
          i <= 6 &&
          gameState[i][j]['value'] == gameState[i - 1][j]['value'] &&
          gameState[i - 1][j]['value'] == gameState[i - 2][j]['value'] &&
          gameState[i - 2][j]['value'] == gameState[i - 3][j]['value']) {
        Result result;
        if (gameState[i][j]['value'] == 1) {
          end = true;
          result = Result.player1;
        } else {
          end = true;
          result = Result.player2;
        }

        // Store winning combination
        winningCombinations.add(WinningCombination(
            positions: [
              Position(i, j),
              Position(i - 1, j),
              Position(i - 2, j),
              Position(i - 3, j),
            ],
            direction: 'vertical'
        ));

        gameState[i][j]['value'] = gameState[i - 1][j]['value'] =
        gameState[i - 2][j]['value'] = gameState[i - 3][j]['value'] = 3;
        return result;
      }

      //down
      else if (i >= 0 &&
          i <= 3 &&
          gameState[i][j]['value'] == gameState[i + 1][j]['value'] &&
          gameState[i + 1][j]['value'] == gameState[i + 2][j]['value'] &&
          gameState[i + 2][j]['value'] == gameState[i + 3][j]['value']) {
        Result result;
        if (gameState[i][j]['value'] == 1) {
          end = true;
          result = Result.player1;
        } else {
          end = true;
          result = Result.player2;
        }

        // Store winning combination
        winningCombinations.add(WinningCombination(
            positions: [
              Position(i, j),
              Position(i + 1, j),
              Position(i + 2, j),
              Position(i + 3, j),
            ],
            direction: 'vertical'
        ));

        gameState[i][j]['value'] = gameState[i + 1][j]['value'] =
        gameState[i + 2][j]['value'] = gameState[i + 3][j]['value'] = 3;
        return result;
      }

      //up-left
      else if (i >= 3 &&
          j >= 3 &&
          i <= 6 &&
          j <= 6 &&
          gameState[i][j]['value'] == gameState[i - 1][j - 1]['value'] &&
          gameState[i - 1][j - 1]['value'] ==
              gameState[i - 2][j - 2]['value'] &&
          gameState[i - 2][j - 2]['value'] ==
              gameState[i - 3][j - 3]['value']) {
        Result result;
        if (gameState[i][j]['value'] == 1) {
          end = true;
          result = Result.player1;
        } else {
          end = true;
          result = Result.player2;
        }

        // Store winning combination
        winningCombinations.add(WinningCombination(
            positions: [
              Position(i, j),
              Position(i - 1, j - 1),
              Position(i - 2, j - 2),
              Position(i - 3, j - 3),
            ],
            direction: 'diagonal-up-left'
        ));

        gameState[i][j]['value'] = gameState[i - 1][j - 1]['value'] =
        gameState[i - 2][j - 2]['value'] =
        gameState[i - 3][j - 3]['value'] = 3;
        return result;
      }

      //up-right
      else if (i >= 3 &&
          j >= 0 &&
          i <= 6 &&
          j <= 3 &&
          gameState[i][j]['value'] == gameState[i - 1][j + 1]['value'] &&
          gameState[i - 1][j + 1]['value'] ==
              gameState[i - 2][j + 2]['value'] &&
          gameState[i - 2][j + 2]['value'] ==
              gameState[i - 3][j + 3]['value']) {
        Result result;
        if (gameState[i][j]['value'] == 1) {
          end = true;
          result = Result.player1;
        } else {
          end = true;
          result = Result.player2;
        }

        // Store winning combination
        winningCombinations.add(WinningCombination(
            positions: [
              Position(i, j),
              Position(i - 1, j + 1),
              Position(i - 2, j + 2),
              Position(i - 3, j + 3),
            ],
            direction: 'diagonal-up-right'
        ));

        gameState[i][j]['value'] = gameState[i - 1][j + 1]['value'] =
        gameState[i - 2][j + 2]['value'] =
        gameState[i - 3][j + 3]['value'] = 3;
        return result;
      }

      //down-right
      else if (i >= 0 &&
          i <= 3 &&
          j >= 0 &&
          j <= 3 &&
          gameState[i][j]['value'] == gameState[i + 1][j + 1]['value'] &&
          gameState[i + 1][j + 1]['value'] ==
              gameState[i + 2][j + 2]['value'] &&
          gameState[i + 2][j + 2]['value'] ==
              gameState[i + 3][j + 3]['value']) {
        Result result;
        if (gameState[i][j]['value'] == 1) {
          end = true;
          result = Result.player1;
        } else {
          end = true;
          result = Result.player2;
        }

        // Store winning combination
        winningCombinations.add(WinningCombination(
            positions: [
              Position(i, j),
              Position(i + 1, j + 1),
              Position(i + 2, j + 2),
              Position(i + 3, j + 3),
            ],
            direction: 'diagonal-down-right'
        ));

        gameState[i][j]['value'] = gameState[i + 1][j + 1]['value'] =
        gameState[i + 2][j + 2]['value'] =
        gameState[i + 3][j + 3]['value'] = 3;
        return result;
      }

      //down-left
      else if (i >= 0 &&
          i <= 3 &&
          j >= 3 &&
          j <= 6 &&
          gameState[i][j]['value'] == gameState[i + 1][j - 1]['value'] &&
          gameState[i + 1][j - 1]['value'] ==
              gameState[i + 2][j - 2]['value'] &&
          gameState[i + 2][j - 2]['value'] ==
              gameState[i + 3][j - 3]['value']) {
        Result result;
        if (gameState[i][j]['value'] == 1) {
          end = true;
          result = Result.player1;
        } else {
          end = true;
          result = Result.player2;
        }

        // Store winning combination
        winningCombinations.add(WinningCombination(
            positions: [
              Position(i, j),
              Position(i + 1, j - 1),
              Position(i + 2, j - 2),
              Position(i + 3, j - 3),
            ],
            direction: 'diagonal-down-left'
        ));

        gameState[i][j]['value'] = gameState[i + 1][j - 1]['value'] =
        gameState[i + 2][j - 2]['value'] =
        gameState[i + 3][j - 3]['value'] = 3;
        return result;
      }
    }
  }

  //if the control flow reaches here that means the game hasn't ended yet!
  return Result.play;
}

// Helper function to get winning positions for animation
List<Position> getWinningPositions() {
  List<Position> allPositions = [];
  for (var combination in winningCombinations) {
    allPositions.addAll(combination.positions);
  }
  return allPositions;
}

// Helper function to animate winning balls sequentially
void animateWinningBalls() {
  for (int i = 0; i < winningCombinations.length; i++) {
    var combination = winningCombinations[i];

    // Animate each position in the winning combination
    for (int j = 0; j < combination.positions.length; j++) {
      var position = combination.positions[j];

      // Add your animation logic here
      // Example: Delayed animation for each ball
      Future.delayed(Duration(milliseconds: j * 200), () {
        // Animate the ball at position (position.row, position.col)
        animateBallAt(position.row, position.col);
      });
    }
  }
}

// Placeholder for your animation function
void animateBallAt(int row, int col) {
  // Implement your ball animation logic here
  // This could involve scaling, color changes, pulsing, etc.
  print('----------------------------------Animating ball at position ($row, $col)');
}

void onRestart(
    {required GlobalKey gameBoardKey,
    required GlobalKey playerTurnKey,
    required BuildContext context}) {
  turns = 0;
  player = 1;
  end = false;

  for (int i = 0; i < gameState.length; i++) {
    for (int j = 0; j < gameState.length; j++) {
      gameState[i][j]['value'] = 0;
    }
  }
  if(gameBoardKey.currentState != null) {
    // ignore: invalid_use_of_protected_member
    gameBoardKey.currentState!.setState(() {});
  }

  if(playerTurnKey.currentState != null) {
    // ignore: invalid_use_of_protected_member
    playerTurnKey.currentState!.setState(() {});
  }
}

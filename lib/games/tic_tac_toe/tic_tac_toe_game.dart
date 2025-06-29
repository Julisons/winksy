import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/tic_tac_toe/tic_tac_toe_dashboard.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../component/glow2.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../theme/custom_colors.dart';
import '../fame_hall/fame_hall.dart';



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
  bool play = true;
  int _seconds = 15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = 15;

    if(Mixin.quad?.quadFirstPlayerId.toString() == Mixin.user?.usrId.toString()){
      quadPlayer = "You start";
      _startTimer();
    }else{
      quadPlayer = Mixin.quad?.quadPlayer+" starts";
    }
    _remotePlay();
    initializeGame();
  }

  void initializeGame() {
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = 'X';
    setState(() {

    });
  }

  void _startTimer() {
    debugPrint('--------------RETURNING -------------$board------NULLLLL--------------');
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      if (_seconds == 0) {
        autoPlayer();
      }
      debugPrint('--------$_seconds');
      if(quadPlayer.contains('You start')) {
        quadPlayer = 'You start $_seconds';
        setState(() {});
      }
      else if(quadPlayer.contains('Your turn')) {
        quadPlayer = 'Your turn $_seconds';
        setState(() {});
      }
    });
  }

  Map<String, int>? emptyCells() {
    final random = Random();
    final int maxAttempts = 100; // Avoid infinite loop
    final int rowCount = board.length;
    final int colCount = board[0].length;

    for (int i = 0; i < maxAttempts; i++) {
      int row = random.nextInt(rowCount);
      int col = random.nextInt(colCount);

      if (board[row][col].isEmpty) {
        return {"row": row, "col": col};
      }
    }
    return null;
  }


  void autoPlayer() {
    Map<String, int>? cell = emptyCells();
    var row = cell?['row'] ?? 0;
    var col = cell?['col'] ?? 0;

    if (board[row][col].isEmpty) {
      _localPlay(row, col);
    }else{
      debugPrint(" ----------IKO----$row-----coin--$col------------");
    }
  }

  void _localPlay(int row, int col) {
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
    Mixin.vibe();
    AudioPlayer().play(AssetSource('audio/sound/tick.wav')); // Your sound file

    if(Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString()) {
      quadPlayer = '${Mixin.quad?.quadAgainst}\'s turn';
    }else {
      quadPlayer = '${Mixin.quad?.quadUser}\'s turn';
    }

    Quad quad = Quad()
      ..quadRow = row
      ..quadColumn = col
      ..quadUsrId = Mixin.user?.usrId
      ..quadPlayer = Mixin.user?.usrFirstName
      ..quadPlayerId = Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString() ?  Mixin.quad?.quadAgainstId : Mixin.quad?.quadUsrId
      ..quadId = Mixin.quad?.quadId;

    Mixin.quadrixSocket?.emit('played', quad.toJson());

    /**
     * RESTART COUNTER
     */
    _timer?.cancel();
    _seconds = 15;

    if(!play){
      debugPrint('$play');
      return;
    }

    if(play) {
      play = false;
    }

    if (board[row][col].isEmpty) {
      setState(() {
        board[row][col] = currentPlayer;
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      });

      String winner = checkForWinner();

      if (winner.isNotEmpty) {

        Quad quad = Quad()
          ..quadState = winner.toUpperCase()
          ..quadWinnerId = Mixin.user?.usrId
          ..quadId = Mixin.quad?.quadId;

        Mixin.quadrixSocket?.emit('win', quad.toJson());

        _end(winner);
        showWinnerDialog(winner, LOCAL);
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

  void showWinnerDialog(String winner, String type) {
    final color = Theme.of(context).extension<CustomColors>()!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          backgroundColor: color.xSecondaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          content: Container(
            width: MediaQuery.of(context).size.width/1.2,
            padding: EdgeInsets.all(16.h),
            child: Text(
                winner == 'Draw'
                  ? 'It\'s a tie'
                  : type == LOCAL ? 'You Win' : ((winner == 'X')
                  ? (Mixin.quad?.quadFirstPlayerId.toString() == Mixin.quad?.quadUsrId.toString()
                  ? '${Mixin.quad?.quadUser} Wins' : '${Mixin.quad?.quadAgainst} Wins')
                  : (Mixin.quad?.quadFirstPlayerId.toString() == Mixin.quad?.quadUsrId.toString()
                  ? '${Mixin.quad?.quadAgainst} Wins' : '${Mixin.quad?.quadUser} Wins')),
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
              textColor: color.xTextColor,
              height: 40.h,
              width: MediaQuery.of(context).size.width/3.5,
              onPress:(){
                Navigator.of(context).pop();
                Mixin.pop(context,IFameHall(quadType: TIC_TAC_TOE,));
              },
            ),
            IButton(
              text: "Play Again",
              color: color.xTrailing,
              height: 40.h,
              width: MediaQuery.of(context).size.width/3.5,
              textColor: Colors.white,
              onPress: () {
                Navigator.of(context).pop();
                Mixin.pop(context,ITicTacToeDashboard());
              },
            )
          ],
        );
      },
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
              padding: const EdgeInsets.only(),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  textAlign: TextAlign.justify,
                  quadPlayer,
                  style: GoogleFonts.quicksand(
                    color: color.xTrailing,
                    fontWeight: FontWeight.bold,
                    fontSize: FONT_APP_BAR,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                      _localPlay(row, col);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.xSecondaryColor, // Background color
                        border: Border.all(
                          color: color.xPrimaryColor,     // Border color
                          width: 2.0,                 // Optional: border thickness
                        ),
                        borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
                      ),
                      child: Center(
                        child: board[row][col] == 'O' ?
                        AnimatedGlowingLetter(
                          letter: board[row][col],
                          size: 90.sp,
                          color: color.xTrailing,
                          animationType: AnimationType.breathe,
                        ) :
                        AnimatedGlowingLetter(
                          letter: board[row][col],
                          size: 90.sp,
                          color: color.xTrailingAlt,
                          animationType: AnimationType.breathe
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: IButton(
              onPress: resetGame,
              text: 'Quit Game',
              textColor: color.xTextColor,
              color: color.xSecondaryColor,
              width: 140.h,
            ),
          ),
        ],
      ),
    );
  }

  void _remotePlay(){
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
        play = true;
        _startTimer();
      }else {
        quadPlayer = '${_quad.quadPlayer}\'s turn';
      }

      int row = int.parse(_quad.quadRow.toString());
      int col = int.parse(_quad.quadColumn.toString());
      Mixin.vibe();
      AudioPlayer().play(AssetSource('audio/sound/tick.wav')); // Your sound file

      if (board[row][col].isEmpty) {
        setState(() {
          board[row][col] = currentPlayer;
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
        });

        String winner = checkForWinner();

        if (winner.isNotEmpty) {
          _end(winner);
          showWinnerDialog(winner, REMOTE);
        }
      }
    });
  }

  void _end(String winner){
    _timer?.cancel();
    if(winner == 'Draw') {
      Mixin.vibe();
      AudioPlayer().play(AssetSource('audio/sound/win.wav')); // Your sound file
    }else {
      Mixin.vibe();
      AudioPlayer().play(AssetSource('audio/sound/win2.wav')); // Your sound file
    }
  }
}

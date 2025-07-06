import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/games.dart';

import '../../../component/button.dart';
import '../../../component/game_button.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/quad.dart';
import '../../../theme/custom_colors.dart';
import '../../../theme/theme_data_style.dart';
import '../../fame_hall/fame_hall.dart';
import '../ai/ai.dart' as ai;
import '../core/game_screen.dart';
import '../models/coin.dart';
import '../quadrix_dashboard.dart';
import '../utils/game_logic.dart';
import 'game_coin_widget.dart';

// ignore: must_be_immutable
class GameBoard extends StatefulWidget {
  GameBoard({super.key, required this.playerTurnKey, required this.gameBoardKey, required this.onRefresh});
  GlobalKey gameBoardKey;
  GlobalKey playerTurnKey;
  final Function() onRefresh;

  @override
  State<GameBoard> createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  late Quad _quad = Quad();
  bool play = true;
  late int _seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    fullColumns.clear();
    
    // Check if this is AI mode or multiplayer mode
    if (Mixin.quad?.quadType == 'AI_MODE') {
      quadPlayer = "You start";
      _startTimer();
    } else {
      // Original multiplayer logic
      if(Mixin.quad?.quadFirstPlayerId.toString() == Mixin.user?.usrId.toString()){
        quadPlayer = "You start";
        _startTimer();
      }else{
        quadPlayer = Mixin.quad?.quadPlayer+" starts";
      }
      _remotePlay();
      _onGaveUpPlay();
    }
  }

  void _startTimer() {
    _seconds = 15;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      if (_seconds <= 5) {
        Mixin.vibe();
        AudioPlayer().play(AssetSource('audio/sound/warning.wav'));
      }
      if (_seconds == 0) {
        autoPlayer();
      }
      if(quadPlayer.contains('You start')) {
        quadPlayer = 'You start $_seconds';
        widget.onRefresh();
      }
      else if(quadPlayer.contains('Your turn')) {
        quadPlayer = 'Your turn $_seconds';
        widget.onRefresh();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final color = ThemeDataStyle.darker.extension<CustomColors>()!;
    return Container(
      height: MediaQuery.of(context).size.width - 20,
      width: MediaQuery.of(context).size.width - 20,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: gameState.map((row) {
          return Row(
            children: row.map((coin) {
              return Expanded(
                child: InkWell(
                onTap: () async {
                  _localPlay(coin,row);
                },
                child:
                GameCoinWidget(
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
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }


  int column(List<int> fullColumns, int start) {
    int max = 6;
    int min = 0;

    int offset = 0;

    while (true) {
      int candidate = start + offset;
      if (candidate <= max && !fullColumns.contains(candidate)) {
        return candidate;
      }

      if (offset != 0) {
        candidate = start - offset;
        if (candidate >= min && !fullColumns.contains(candidate)) {
          return candidate;
        }
      }

      offset++;
      if (start - offset < min && start + offset > max) {
        break; // all taken
      }
    }
    throw Exception('No available column'); // or return -1 if preferred
  }

  void autoPlayer() {

    int rand = 3;
    rand = column(fullColumns,rand);

    var row = gameState.toList()[rand];
    var coin = row.toList()[rand];

    debugPrint(" --------------$rand-------------------");
    _localPlay(coin,row);
  }

  Future<void> _localPlay(coin,row) async {

     final color = ThemeDataStyle.darker.extension<CustomColors>()!;
    if (end == false) {

      // Check if this is AI mode
      if (Mixin.quad?.quadType == 'AI_MODE') {
        // In AI mode, only allow player moves when it's their turn
        if (player != 1) {
          return;
        }
      } else {
        // Original multiplayer turn validation
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
      }

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

      // Set player turn message based on game mode
      if (Mixin.quad?.quadType == 'AI_MODE') {
        // Show opponent's name instead of "AI thinking"
        quadPlayer = '${Mixin.quad?.quadAgainst}\'s turn';
      } else {
        if(Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString()) {
          quadPlayer = '${Mixin.quad?.quadAgainst}\'s turn';
        }else {
          quadPlayer = '${Mixin.quad?.quadUser}\'s turn';
        }
      }

      //row----4-----column---5
      debugPrint('row----${coin['row']}-----column---${coin['column']}');

      await onPlay(
          coin: Coin(
            row: coin['row'] as int,
            column: coin['column'] as int,
            selected: false,
            color: color.xSecondaryColor,
          ),
          playerTurnKey: widget.playerTurnKey,
          gameBoardKey: widget.gameBoardKey);

      Result result = didEnd();

      // Handle AI mode vs multiplayer mode differently
      if (Mixin.quad?.quadType == 'AI_MODE') {
        _end(result);
        
        //stop the game if the game has ended
        if (result != Result.play) {
          setState(() {});
          if (result == Result.draw) {
            quadPlayer = 'It\'s a tie!';
          } else if (result == Result.player1) {
            quadPlayer = 'You won!';
          } else {
            // Show opponent's name instead of "AI won!"
            quadPlayer = '${Mixin.quad?.quadAgainst} won!';
          }
        } else {
          // AI makes a move - showing real computation time only
          _makeAIMove();
        }
      } else {
        // Original multiplayer logic
        Quad quad = Quad()
          ..quadRow = coin['row'] as int
          ..quadColumn =  coin['column'] as int
          ..quadUsrId = Mixin.user?.usrId
          ..quadState = result.name.toString().toUpperCase()
          ..quadPlayer = Mixin.user?.usrFirstName
          ..quadPlayerId = Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString() ?  Mixin.quad?.quadAgainstId : Mixin.quad?.quadUsrId
          ..quadId = Mixin.quad?.quadId;

        _end(result);
        Mixin.quadrixSocket?.emit('played', quad.toJson());

        //stop the game if the game has ended
        if (result != Result.play) {

          Quad quad = Quad()
            ..quadState = result.name.toString().toUpperCase()
            ..quadWinnerId = Mixin.user?.usrId
            ..quadId = Mixin.quad?.quadId;

          Mixin.quadrixSocket?.emit('win', quad.toJson());

          setState(() {});
          quadPlayer = 'You won';
        }
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
        _startTimer();
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
            // final color = ThemeDataStyle.darker.extension<CustomColors>()!;

            quadPlayer = (result == Result.draw)
                ? 'It\'s a tie'
                : (result == Result.player1)
                ? (Mixin.quad?.quadFirstPlayerId.toString() == Mixin.quad?.quadUsrId.toString()
                ? 'You lost' : 'You lost')
                : (Mixin.quad?.quadFirstPlayerId.toString() == Mixin.quad?.quadUsrId.toString()
                ? 'You lost' : 'You lost');
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

  void _onGaveUpPlay(){
    Mixin.quadrixSocket?.on('gave_up', (message) async {
      print(jsonEncode(message));
      _quad = Quad.fromJson(message);

      var quitter =  Mixin.user?.usrId == Mixin.quad?.quadUsrId ? Mixin.quad?.quadAgainst : Mixin.quad?.quadUser;
      setState(() {
        _timer?.cancel();
        AudioPlayer().play(AssetSource('audio/sound/win2.wav'));
        quadPlayer = 'You won ';
        Mixin.showToast(context,'$quitter  couldn\'t take it anymore;  Gave up in silence 😔', INFO);
        end = true;
        widget.onRefresh();
      });
    });
  }


  void _makeAIMove() async {
    if (end) return;
    
     final color = ThemeDataStyle.darker.extension<CustomColors>()!;
    
    // Convert game state to AI board format
    List<List<int>> board = List.generate(ai.rows, (r) => 
        List.generate(ai.cols, (c) => gameState[r][c]['value'] as int));
    
    // Debug: Print current board state
    debugPrint('AI analyzing board:');
    for (int r = 0; r < ai.rows; r++) {
      debugPrint(board[r].toString());
    }
    
    // Get AI difficulty from quad description
    String difficulty = Mixin.quad?.quadDesc ?? 'Medium';
    debugPrint('AI difficulty: $difficulty');
    
    // Get AI move with timeout protection
    int aiColumn = -1;
    try {
      // Add a small delay for user experience and computation time
      await Future.delayed(Duration(milliseconds: 500)); // Increased delay for better UX
      aiColumn = ai.getAIMove(board, difficulty: difficulty);
      debugPrint('AI selected column: $aiColumn');
    } catch (e) {
      print('AI error: $e');
      // Fallback to center column
      aiColumn = 3;
      debugPrint('AI fallback to center column');
    }
    
    // Validate AI move
    if (aiColumn == -1 || aiColumn < 0 || aiColumn >= ai.cols || !ai.canDrop(board, aiColumn)) {
      // Emergency fallback - find any valid move
      for (int c = 0; c < ai.cols; c++) {
        if (ai.canDrop(board, c)) {
          aiColumn = c;
          break;
        }
      }
      if (aiColumn == -1) return; // No valid moves at all
    }
    
    // Create coin for AI move
    var aiCoin = {
      'row': 0,
      'column': aiColumn,
      'value': 0
    };
    
    await onPlay(
        coin: Coin(
          row: 0,
          column: aiColumn,
          selected: false,
          color: color.xSecondaryColor,
        ),
        playerTurnKey: widget.playerTurnKey,
        gameBoardKey: widget.gameBoardKey);

    Result result = didEnd();
    _end(result);
    
    if (result != Result.play) {
      setState(() {});
      if (result == Result.draw) {
        quadPlayer = 'It\'s a tie!';
      } else if (result == Result.player1) {
        quadPlayer = 'You won!';
      } else {
        // Show opponent's name instead of "AI won!"
        quadPlayer = '${Mixin.quad?.quadAgainst} won!';
      }
    } else {
      setState(() {
        quadPlayer = 'Your turn';
        play = true;
        _startTimer();
      });
    }
  }

  void _end(Result result){
    if(result == Result.draw) {
      widget.onRefresh();
      _timer?.cancel();
      Mixin.vibe();
      AudioPlayer().play(AssetSource('audio/sound/win.wav')); // Your sound file
    }else if(result == Result.player1 || result == Result.player2){
      widget.onRefresh();
      _timer?.cancel();
      Mixin.vibe();
      AudioPlayer().play(AssetSource('audio/sound/win2.wav')); // Your sound file
    }
  }
}
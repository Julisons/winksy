
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/component/glow2.dart';

import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../theme/custom_colors.dart';
import '../../theme/theme_data_style.dart';
import 'components/dead_piece.dart';
import 'components/pieces.dart';
import 'components/square.dart';
import 'helper/helper_function.dart';
import 'chess_ai.dart';

class IChessGame extends StatefulWidget {
  const IChessGame({Key? key}) : super(key: key);

  @override
  State<IChessGame> createState() => _IChessGameState();
}

class _IChessGameState extends State<IChessGame> {
  late List<List<ChessPiece?>> board;
  // The currently selected piece on the chess board,
// If no piece is selected, this is null.
  ChessPiece? selectedPiece;
// The row index of the selected piece
// Default value -1 indicated no piece is currently selected;
  int selectedRow = -1;

// The Column index of the selected piece
// Default value -1 indicated no piece is currently selected;
  int selectedCol = -1;
  List<List<int>> validMoves = [];

  List<ChessPiece> whitePiecesTaken = [];

  List<ChessPiece> blackPiecesTaken = [];

  bool isWhiteTurn = true;

  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  String currentPlayer = '';
  late Quad _quad = Quad();
  String quadPlayer = '';
  Timer? _timer;
  bool play = true;
  late int _seconds;
  bool end = false;

  // AI mode variables
  bool get isAIMode => Mixin.quad?.quadType == 'AI_MODE';
  bool get isUserTurn => isWhiteTurn; // User always plays white in AI mode
  Timer? _aiMoveTimer;

  @override
  void initState() {
    super.initState();

    if (isAIMode) {
      // AI mode initialization
      quadPlayer = "You start";
      _startTimer();
    } else {
      // Multiplayer mode initialization
      if(Mixin.quad?.quadFirstPlayerId.toString() == Mixin.user?.usrId.toString()){
        quadPlayer = "You start";
        _startTimer();
      }else{
        quadPlayer = Mixin.quad?.quadPlayer+" starts";
      }
      _remotePlay();
      _onGaveUpPlay();
    }

    _initializeBoard();
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
        setState(() {});
      }
      else if(quadPlayer.contains('Your turn')) {
        quadPlayer = 'Your turn $_seconds';
       setState(() {});
      }
      else if(quadPlayer.contains('AI thinking')) {
        quadPlayer = 'AI thinking $_seconds';
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _aiMoveTimer?.cancel();
    super.dispose();
  }

  void _initializeBoard() {
    // initialize the board with nulls, meaning no pieces in those positions.
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    // Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPiecesType.pawn,
        isWhite: false,
        imagePath: 'assets/chess/pawn.png',
      );

      newBoard[6][i] = ChessPiece(
        type: ChessPiecesType.pawn,
        isWhite: true,
        imagePath: 'assets/chess/pawn.png',
      );
    }

    // Place rooks
    newBoard[0][0] = ChessPiece(
        type: ChessPiecesType.rook,
        isWhite: false,
        imagePath: "assets/chess/rook.png");
    newBoard[0][7] = ChessPiece(
        type: ChessPiecesType.rook,
        isWhite: false,
        imagePath: "assets/chess/rook.png");
    newBoard[7][0] = ChessPiece(
        type: ChessPiecesType.rook,
        isWhite: true,
        imagePath: "assets/chess/rook.png");
    newBoard[7][7] = ChessPiece(
        type: ChessPiecesType.rook,
        isWhite: true,
        imagePath: "assets/chess/rook.png");

    // Place knights
    newBoard[0][1] = ChessPiece(
        type: ChessPiecesType.knight,
        isWhite: false,
        imagePath: "assets/chess/knight.png");
    newBoard[0][6] = ChessPiece(
        type: ChessPiecesType.knight,
        isWhite: false,
        imagePath: "assets/chess/knight.png");
    newBoard[7][1] = ChessPiece(
        type: ChessPiecesType.knight,
        isWhite: true,
        imagePath: "assets/chess/knight.png");
    newBoard[7][6] = ChessPiece(
        type: ChessPiecesType.knight,
        isWhite: true,
        imagePath: "assets/chess/knight.png");

    // Place bishops
    newBoard[0][2] = ChessPiece(
        type: ChessPiecesType.bishop,
        isWhite: false,
        imagePath: "assets/chess/bishop.png");

    newBoard[0][5] = ChessPiece(
        type: ChessPiecesType.bishop,
        isWhite: false,
        imagePath: "assets/chess/bishop.png");
    newBoard[7][2] = ChessPiece(
        type: ChessPiecesType.bishop,
        isWhite: true,
        imagePath: "assets/chess/bishop.png");
    newBoard[7][5] = ChessPiece(
        type: ChessPiecesType.bishop,
        isWhite: true,
        imagePath: "assets/chess/bishop.png");

    // Place queens
    newBoard[0][3] = ChessPiece(
      type: ChessPiecesType.queen,
      isWhite: false,
      imagePath: 'assets/chess/queen.png',
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPiecesType.queen,
      isWhite: true,
      imagePath: 'assets/chess/queen.png',
    );

    // Place kings
    newBoard[0][4] = ChessPiece(
      type: ChessPiecesType.king,
      isWhite: false,
      imagePath: 'assets/chess/king.png',
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPiecesType.king,
      isWhite: true,
      imagePath: 'assets/chess/king.png',
    );

    board = newBoard;
  }

// USER SELECTED A PIECE
  void pieceSelected(int row, int col) {
    setState(() {
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      } else if (board[row][col] != null && board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      } else if (selectedPiece != null && validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }

      validMoves = calculateRealValidMoves(selectedRow, selectedCol, selectedPiece, true);
    });
  }

  List<List<int>> calculateRowValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPiecesType.pawn:
      case ChessPiecesType.pawn:
        // Check the square immediately in front of the pawn
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        // If it's the pawn's first move (row is either 1 for black pawns or 6 for white ones), check the square two steps ahead
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        // Check for possible captures
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;

      case ChessPiecesType.rook:
        // horizontal and vertical directions
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], //left
          [0, 1], //right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves
                    .add([newRow, newCol]); // can capture opponent's piece
              }
              break; // blocked by own piece or after capturing
            }
            candidateMoves.add([newRow, newCol]); // an empty valid square
            i++;
          }
        }
        break;

      case ChessPiecesType.knight:
        // all eight possible L shapes the knight can move
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-2, 1], // up 2 right 1
          [-1, -2], // up 1 left 2
          [-1, 2], // up 1 right 2
          [1, -2], // down 1 left 2
          [1, 2], // down 1 right 2
          [2, -1], // down 2 left 1
          [2, 1], // down 2 right 1
        ];
        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          // if the new position is empty or there is an opponent's piece there
          if (board[newRow][newCol] == null ||
              board[newRow][newCol]!.isWhite != piece.isWhite) {
            candidateMoves.add([newRow, newCol]);
          }
        }
        break;

      case ChessPiecesType.bishop:
        // diagonal directions
        var directions = [
          [-1, -1], // up-left
          [-1, 1], // up-right
          [1, -1], // down-left
          [1, 1], // down-right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // capture
              }
              break; // blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPiecesType.queen:
        // Queen can move in any direction, combining the moves of a rook and a bishop
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], // left
          [0, 1], // right
          [-1, -1], // up-left
          [-1, 1], // up-right
          [1, -1], // down-left
          [1, 1] // down-right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (!isInBoard(newRow, newCol)) {
              break;
            }

            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // capture
              }
              break; // blocked
            }
            candidateMoves.add([newRow, newCol]); // free space
            i++;
          }
        }
        break;

      case ChessPiecesType.king:
        var kingMoves = [
          [-1, -1], // Up-left
          [-1, 0], // Up
          [-1, 1], // Up-right
          [0, -1], // Left
          [0, 1], // Right
          [1, -1], // Down-left
          [1, 0], // Down
          [1, 1] // Down-right
        ];

        for (var move in kingMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];

          if (!isInBoard(newRow, newCol)) {
            continue;
          }

          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); // Can capture
            }
            continue; // Square is blocked by a piece of the same color
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;

      default:
    }
    return candidateMoves;
  }

  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRowValidMoves(row, col, piece);
    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  void movePiece(int newRow, int newCol) {
// if the new spot has an enemy piece
    if (board[newRow][newCol] != null) {
// add the captured piece to the appropriate list
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }

    if (selectedPiece?.type == ChessPiecesType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    // Check for game ending conditions
    String? gameEndReason = _checkGameEnd(!isWhiteTurn);
    if (gameEndReason != null) {
      final color = ThemeDataStyle.darker.extension<CustomColors>()!;
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(gameEndReason, style: TextStyle(
                  color: color.xTextColorSecondary,fontSize: FONT_TITLE
                ),),
                actions: [
                  TextButton(
                      onPressed: resetGame, child: Text("Restart The Game",
                  style: TextStyle(
                    color: color.xTrailing,
                    fontSize: FONT_13
                  ),))
                ],
              ));
      end = true; // Mark game as ended
    }

    isWhiteTurn = !isWhiteTurn;
    
    // In AI mode, trigger AI move after user's move
    if (isAIMode && !isUserTurn && !end) {
      // Start timer for AI's turn (AI is also subject to 15-second limit)
      _startTimer();
      _scheduleAIMove();
    }
  }

  bool isKingInCheck(bool isWhiteKing) {
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        for (List<int> move in pieceValidMoves) {
          if (move[0] == kingPosition[0] && move[1] == kingPosition[1]) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    List<int>? originalKingPosition;
    if (piece.type == ChessPiecesType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(piece.isWhite);

    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    if (piece.type == ChessPiecesType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingInCheck;
  }

  bool isCheckMate(bool isWhiteKing) {
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> validMoves =
            calculateRealValidMoves(i, j, board[i][j]!, true);
        if (validMoves.isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void resetGame() {
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = ThemeDataStyle.darker.extension<CustomColors>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:color.xPrimaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(quadPlayer,
              style: GoogleFonts.quicksand(
                color: color.xTrailing,
                fontWeight: FontWeight.bold,
                fontSize: FONT_APP_BAR,
              ),
            textAlign: TextAlign.center,),
            GlowingLetter(letter: checkStatus ? " (CHECK)" : "",size: FONT_APP_BAR,glowType: GlowType.intense,color: color.xTrailing),
          ],
        ),
      ),
      backgroundColor: color.xPrimaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 28.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.grey.shade800, Colors.grey.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (Mixin.user?.usrId.toString() == Mixin.quad?.quadFirstPlayerId.toString()) ? whitePiecesTaken.length : blackPiecesTaken.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) => DeadPiece(
                  imagePath: (Mixin.user?.usrId.toString() == Mixin.quad?.quadFirstPlayerId.toString()) ? whitePiecesTaken[index].imagePath : blackPiecesTaken[index].imagePath,
                  isWhite: (Mixin.user?.usrId.toString() == Mixin.quad?.quadFirstPlayerId.toString()),
                ),
              ), // GridView.builder
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8 * 8,
              // reverse: (Mixin.user?.usrId.toString() != Mixin.quad?.quadFirstPlayerId.toString()),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context, index) {
                int row, col;

                if (Mixin.user?.usrId.toString() != Mixin.quad?.quadFirstPlayerId.toString()) {
                  // Flip the board for the second player
                  int flippedIndex = 63 - index; // 64 squares total, so 63 is max index
                  row = flippedIndex ~/ 8;
                  col = flippedIndex % 8;
                } else {
                  row = index ~/ 8;
                  col = index % 8;
                }

                bool isSelected = selectedCol == col && selectedRow == row;
                bool isValidMove = false;

                for (var position in validMoves) {
                  // compare row and col
                  if (position[0] == row && position[1] == col) {
                    isValidMove = true;
                  }
                }

                return Square(
                  isValidMove: isValidMove,
                  onTap: () {
                    bool viableMove = (selectedPiece != null && isValidMove);

                    if(viableMove){
                      FlameAudio.play('piece_moved.mp3');
                      _timer?.cancel();
                      _seconds = 15;
                    }

                    dev.log('-${Mixin.user?.usrId}--${(Mixin.user?.usrId.toString() == Mixin.quad?.quadFirstPlayerId.toString())}----------quadPlayerId---${_quad.quadPlayerId}------------isWhiteTurn: $isWhiteTurn');

                    if(viableMove){
                      dev.log('-------------------------------------------------------------isValidMove: $isValidMove');
                    }
                    /**
                     * IF ITS NOT YOUR TURN , DON'T PLAY
                     */

                    if(_quad.quadPlayerId == null){
                      if (!(Mixin.user?.usrId.toString() == Mixin.quad?.quadFirstPlayerId.toString() && isWhiteTurn)) {
                        return;
                      }
                    }else {
                      if (Mixin.user?.usrId.toString() != _quad.quadPlayerId.toString()) {
                        return;
                      }
                    }

                    Quad quad = Quad()
                      ..quadRow = row
                      ..quadColumn = col
                      ..quadMoveType = (selectedPiece != null && isValidMove)
                      ..quadUsrId = Mixin.user?.usrId
                      ..quadPlayer = Mixin.user?.usrFirstName
                      ..quadId = Mixin.quad?.quadId;

                    if(viableMove) {
                      quad.quadPlayerId = Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString() ?  Mixin.quad?.quadAgainstId : Mixin.quad?.quadUsrId;

                      if (Mixin.user?.usrId.toString() == Mixin.quad?.quadUsrId.toString()) {
                        quadPlayer = '${Mixin.quad?.quadAgainst}\'s turn';
                      } else {
                        quadPlayer = '${Mixin.quad?.quadUser}\'s turn';
                      }
                    }else{
                      //Maintain the first player because is not viableMove
                      quad.quadPlayerId = Mixin.user?.usrId;
                    }

                    Mixin.quadrixSocket?.emit('played', quad.toJson());
                    pieceSelected(row, col);
                  },
                  isSelected: isSelected,
                  isWhite: isWhite(index),
                  piece: board[row][col],
                );
              },
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (Mixin.user?.usrId.toString() == Mixin.quad?.quadFirstPlayerId.toString()) ? blackPiecesTaken.length : whitePiecesTaken.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                itemBuilder: (context, index) => DeadPiece(
                  imagePath: (Mixin.user?.usrId.toString() == Mixin.quad?.quadFirstPlayerId.toString()) ? blackPiecesTaken[index].imagePath : whitePiecesTaken[index].imagePath,
                  isWhite: (Mixin.user?.usrId.toString() != Mixin.quad?.quadFirstPlayerId.toString()),
                ),
              ), // GridView.builder
            ),
          ],
        ),
      ),
    );
  }

  void _remotePlay(){
    Mixin.quadrixSocket?.on('play', (message) async {
      print(jsonEncode(message));
      _quad = Quad.fromJson(message);

      dev.log('----------_quad.quadMoveType---------${_quad.quadMoveType}');

      /**
       * THIS MOVE IS FROM ME, SO JUST IGNORE
       */
      if(Mixin.user?.usrId.toString() == _quad.quadUsrId.toString()) {
        return;
      }
      if(_quad.quadMoveType == 'true') {
          FlameAudio.play('piece_moved.mp3');
          Mixin.vibe();
          _startTimer();
        if (Mixin.user?.usrId.toString() == _quad.quadPlayerId.toString()) {
          quadPlayer = 'Your turn';
        } else {
          quadPlayer = '${_quad.quadPlayer}\'s turn';
        }
      }

      pieceSelected(int.parse(_quad.quadRow.toString()),int.parse(_quad.quadColumn.toString()));
    });
  }

  void _end(String winner){
    if(winner == 'Draw') {
      setState(() {});
      _timer?.cancel();
      Mixin.vibe();
      AudioPlayer().play(AssetSource('audio/sound/win.wav')); // Your sound file
    }else {
      setState(() {});
      _timer?.cancel();
      Mixin.vibe();
      AudioPlayer().play(AssetSource('audio/sound/win2.wav')); // Your sound file
    }
  }

  void autoPlayer() {
    _timer?.cancel();
    _seconds = 15;
    
    // In AI mode, if it's AI's turn, make an AI move
    if (isAIMode && !isUserTurn && !end) {
      _makeAIMove();
    }
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
        setState(() {});
      });
    });
  }

  // AI Move Methods
  void _scheduleAIMove() {
    // Cancel any existing AI move timer
    _aiMoveTimer?.cancel();
    
    // Update UI to show AI is thinking (but keep timer running)
    setState(() {
      quadPlayer = 'AI thinking $_seconds';
    });
    
    // Schedule AI move with shorter delay (AI should play fast like a good player)
    _aiMoveTimer = Timer(Duration(milliseconds: 800), () {
      _makeAIMove();
    });
  }

  void _makeAIMove() {
    if (end || isUserTurn) return;
    
    try {
      // Get AI difficulty from quad description
      String difficulty = Mixin.quad?.quadDesc ?? 'Medium';
      
      // Get AI move using ChessAI
      Move? aiMove = ChessAI.getAIMove(
        board, 
        isWhiteTurn, 
        difficulty,
        whiteKingPosition, 
        blackKingPosition
      );
      
      if (aiMove != null) {
        // Execute the AI move
        setState(() {
          quadPlayer = 'AI played';
        });
        
        // Simulate piece selection and movement
        selectedPiece = board[aiMove.fromRow][aiMove.fromCol];
        selectedRow = aiMove.fromRow;
        selectedCol = aiMove.fromCol;
        
        // Execute the move
        movePiece(aiMove.toRow, aiMove.toCol);
        
        // Play sound and haptic feedback for AI move
        FlameAudio.play('piece_moved.mp3');
        Mixin.vibe();
        
        // Start timer for user's next turn
        if (!end) {
          _startTimer();
          setState(() {
            quadPlayer = 'Your turn $_seconds';
          });
        }
      } else {
        // No valid AI move found (shouldn't happen in normal gameplay)
        setState(() {
          quadPlayer = 'AI has no moves';
        });
      }
    } catch (e) {
      print('AI Move Error: $e');
      // Fallback: make a random move
      _makeRandomMove();
    }
  }
  
  void _makeRandomMove() {
    // Fallback method to make a random valid move
    List<List<int>> allMoves = [];
    
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null && piece.isWhite == isWhiteTurn) {
          List<List<int>> validMovesForPiece = calculateRealValidMoves(row, col, piece, true);
          for (List<int> move in validMovesForPiece) {
            allMoves.add([row, col, move[0], move[1]]);
          }
        }
      }
    }
    
    if (allMoves.isNotEmpty) {
      var randomMove = allMoves[Random().nextInt(allMoves.length)];
      selectedPiece = board[randomMove[0]][randomMove[1]];
      selectedRow = randomMove[0];
      selectedCol = randomMove[1];
      movePiece(randomMove[2], randomMove[3]);
      
      // Play sound and haptic feedback for AI fallback move
      FlameAudio.play('piece_moved.mp3');
      Mixin.vibe();
      
      if (!end) {
        _startTimer();
        setState(() {
          quadPlayer = 'Your turn $_seconds';
        });
      }
    }
  }

  // Comprehensive game end detection
  String? _checkGameEnd(bool checkingPlayer) {
    // 1. Check if the player has any pieces left
    bool hasKing = false;
    int pieceCount = 0;
    
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null && piece.isWhite == checkingPlayer) {
          pieceCount++;
          if (piece.type == ChessPiecesType.king) {
            hasKing = true;
          }
        }
      }
    }
    
    // 2. No king = immediate loss (king captured)
    if (!hasKing) {
      String winner = checkingPlayer ? "Black" : "White";
      if (isAIMode) {
        winner = checkingPlayer ? "AI" : "You";
      }
      return "$winner Wins! - King Captured";
    }
    
    // 3. Only king left = insufficient material loss
    if (pieceCount == 1) {
      String winner = checkingPlayer ? "Black" : "White";
      if (isAIMode) {
        winner = checkingPlayer ? "AI" : "You";
      }
      return "$winner Wins! - All Pieces Captured";
    }
    
    // 4. Check for checkmate
    if (isCheckMate(checkingPlayer)) {
      String winner = checkingPlayer ? "Black" : "White";
      if (isAIMode) {
        winner = checkingPlayer ? "AI" : "You";
      }
      return "$winner Wins! - Checkmate";
    }
    
    // 5. Check for stalemate (no legal moves but not in check)
    if (!isKingInCheck(checkingPlayer)) {
      List<List<int>> allMoves = [];
      
      for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
          ChessPiece? piece = board[row][col];
          if (piece != null && piece.isWhite == checkingPlayer) {
            List<List<int>> pieceMoves = calculateRealValidMoves(row, col, piece, true);
            allMoves.addAll(pieceMoves);
          }
        }
      }
      
      if (allMoves.isEmpty) {
        return "Stalemate - Draw";
      }
    }
    
    // 6. Check for insufficient material draw
    if (_isInsufficientMaterial()) {
      return "Draw - Insufficient Material";
    }
    
    return null; // Game continues
  }

  // Check if both sides have insufficient material to checkmate
  bool _isInsufficientMaterial() {
    int whiteKnights = 0, whiteBishops = 0, whiteOthers = 0;
    int blackKnights = 0, blackBishops = 0, blackOthers = 0;
    
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null && piece.type != ChessPiecesType.king) {
          if (piece.isWhite) {
            if (piece.type == ChessPiecesType.knight) {
              whiteKnights++;
            } else if (piece.type == ChessPiecesType.bishop) {
              whiteBishops++;
            } else {
              whiteOthers++;
            }
          } else {
            if (piece.type == ChessPiecesType.knight) {
              blackKnights++;
            } else if (piece.type == ChessPiecesType.bishop) {
              blackBishops++;
            } else {
              blackOthers++;
            }
          }
        }
      }
    }
    
    // If either side has pawns, rooks, or queens, material is sufficient
    if (whiteOthers > 0 || blackOthers > 0) return false;
    
    // King vs King
    if (whiteKnights == 0 && whiteBishops == 0 && blackKnights == 0 && blackBishops == 0) {
      return true;
    }
    
    // King + Knight vs King or King + Bishop vs King
    if ((whiteKnights + whiteBishops <= 1) && (blackKnights + blackBishops == 0) ||
        (blackKnights + blackBishops <= 1) && (whiteKnights + whiteBishops == 0)) {
      return true;
    }
    
    return false;
  }
}

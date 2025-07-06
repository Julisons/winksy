
import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/app_bar.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../theme/custom_colors.dart';
import '../../theme/theme_data_style.dart';
import 'components/dead_piece.dart';
import 'components/pieces.dart';
import 'components/square.dart';
import 'helper/helper_function.dart';

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

  @override
  void initState() {
    super.initState();

    if(Mixin.quad?.quadFirstPlayerId.toString() == Mixin.user?.usrId.toString()){
      quadPlayer = "You start";
    }else{
      quadPlayer = Mixin.quad?.quadPlayer+" starts";
    }

    _play();

    _initializeBoard();
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
      } else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      } else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }

      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
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

    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("CHECK MATE"),
                actions: [
                  TextButton(
                      onPressed: resetGame, child: Text("Restart The Game"))
                ],
              ));
    }

    isWhiteTurn = !isWhiteTurn;
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
      //appBar: IAppBar(title: 'Chess', leading: false),
      backgroundColor: color.xPrimaryColor,
      body: Container(
        padding: EdgeInsets.only(bottom: 30.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey.shade900, Colors.grey.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: whitePiecesTaken.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) => DeadPiece(
                  imagePath: whitePiecesTaken[index].imagePath,
                  isWhite: true,
                ),
              ), // GridView.builder
            ), // Expanded
            Text(checkStatus ? "CHECK" : ""),
            Expanded(
              flex: 4,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8 * 8,
                reverse: (Mixin.user?.usrId.toString() != Mixin.quad?.quadFirstPlayerId.toString()),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;

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
                      }

                      log('-${Mixin.user?.usrId}--${(Mixin.user?.usrId.toString() == Mixin.quad?.quadFirstPlayerId.toString())}----------quadPlayerId---${_quad.quadPlayerId}------------isWhiteTurn: $isWhiteTurn');

                      if(viableMove){
                        log('-------------------------------------------------------------isValidMove: $isValidMove');
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
            ),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: blackPiecesTaken.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                itemBuilder: (context, index) => DeadPiece(
                  imagePath: blackPiecesTaken[index].imagePath,
                  isWhite: false,
                ),
              ), // GridView.builder
            ),
            Text(quadPlayer,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: FONT_APP_BAR,
              ),
              textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }


  void _play(){
    Mixin.quadrixSocket?.on('play', (message) async {
      print(jsonEncode(message));
      _quad = Quad.fromJson(message);

      log('----------_quad.quadMoveType---------${_quad.quadMoveType}');

      /**
       * THIS MOVE IS FROM ME, SO JUST IGNORE
       */
      if(Mixin.user?.usrId.toString() == _quad.quadUsrId.toString()) {
        return;
      }
      if(_quad.quadMoveType == 'true') {
          FlameAudio.play('piece_moved.mp3');
          Mixin.vibe();
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
      AudioPlayer().play(AssetSource('sound/win.wav')); // Your sound file
    }else {
      AudioPlayer().play(AssetSource('sound/win2.wav')); // Your sound file
    }
  }
}

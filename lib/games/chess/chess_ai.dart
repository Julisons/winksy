import 'dart:math';
import 'components/pieces.dart';
import 'helper/helper_function.dart';

class ChessAI {
  static const int maxDepth = 4;
  static const int maxDepthHard = 6;
  
  // Piece values for evaluation
  static const Map<ChessPieceType, int> pieceValues = {
    ChessPieceType.pawn: 100,
    ChessPieceType.knight: 300,
    ChessPieceType.bishop: 300,
    ChessPieceType.rook: 500,
    ChessPieceType.queen: 900,
    ChessPieceType.king: 10000,
  };

  // Position bonus tables for better piece placement
  static const List<List<int>> pawnTable = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [50, 50, 50, 50, 50, 50, 50, 50],
    [10, 10, 20, 30, 30, 20, 10, 10],
    [5, 5, 10, 25, 25, 10, 5, 5],
    [0, 0, 0, 20, 20, 0, 0, 0],
    [5, -5, -10, 0, 0, -10, -5, 5],
    [5, 10, 10, -20, -20, 10, 10, 5],
    [0, 0, 0, 0, 0, 0, 0, 0]
  ];

  static const List<List<int>> knightTable = [
    [-50, -40, -30, -30, -30, -30, -40, -50],
    [-40, -20, 0, 0, 0, 0, -20, -40],
    [-30, 0, 10, 15, 15, 10, 0, -30],
    [-30, 5, 15, 20, 20, 15, 5, -30],
    [-30, 0, 15, 20, 20, 15, 0, -30],
    [-30, 5, 10, 15, 15, 10, 5, -30],
    [-40, -20, 0, 5, 5, 0, -20, -40],
    [-50, -40, -30, -30, -30, -30, -40, -50]
  ];

  static const List<List<int>> bishopTable = [
    [-20, -10, -10, -10, -10, -10, -10, -20],
    [-10, 0, 0, 0, 0, 0, 0, -10],
    [-10, 0, 5, 10, 10, 5, 0, -10],
    [-10, 5, 5, 10, 10, 5, 5, -10],
    [-10, 0, 10, 10, 10, 10, 0, -10],
    [-10, 10, 10, 10, 10, 10, 10, -10],
    [-10, 5, 0, 0, 0, 0, 5, -10],
    [-20, -10, -10, -10, -10, -10, -10, -20]
  ];

  static const List<List<int>> rookTable = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [5, 10, 10, 10, 10, 10, 10, 5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [0, 0, 0, 5, 5, 0, 0, 0]
  ];

  static const List<List<int>> queenTable = [
    [-20, -10, -10, -5, -5, -10, -10, -20],
    [-10, 0, 0, 0, 0, 0, 0, -10],
    [-10, 0, 5, 5, 5, 5, 0, -10],
    [-5, 0, 5, 5, 5, 5, 0, -5],
    [0, 0, 5, 5, 5, 5, 0, -5],
    [-10, 5, 5, 5, 5, 5, 0, -10],
    [-10, 0, 5, 0, 0, 0, 0, -10],
    [-20, -10, -10, -5, -5, -10, -10, -20]
  ];

  static const List<List<int>> kingTable = [
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-20, -30, -30, -40, -40, -30, -30, -20],
    [-10, -20, -20, -20, -20, -20, -20, -10],
    [20, 20, 0, 0, 0, 0, 20, 20],
    [20, 30, 10, 0, 0, 10, 30, 20]
  ];

  // Get AI move based on difficulty
  static Move? getAIMove(List<List<ChessPiece?>> board, bool isWhiteTurn, 
                        String difficulty, List<int> whiteKingPos, List<int> blackKingPos) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return _getEasyMove(board, isWhiteTurn, whiteKingPos, blackKingPos);
      case 'medium':
        return _getMediumMove(board, isWhiteTurn, whiteKingPos, blackKingPos);
      case 'hard':
        return _getHardMove(board, isWhiteTurn, whiteKingPos, blackKingPos);
      default:
        return _getMediumMove(board, isWhiteTurn, whiteKingPos, blackKingPos);
    }
  }

  // Easy AI: Random moves with some basic strategy
  static Move? _getEasyMove(List<List<ChessPiece?>> board, bool isWhiteTurn, 
                           List<int> whiteKingPos, List<int> blackKingPos) {
    List<Move> allMoves = _getAllValidMoves(board, isWhiteTurn, whiteKingPos, blackKingPos);
    if (allMoves.isEmpty) return null;

    // 30% chance to make a random move
    if (Random().nextInt(100) < 30) {
      return allMoves[Random().nextInt(allMoves.length)];
    }

    // Otherwise use basic strategy
    return _getBestMoveBasic(board, allMoves, isWhiteTurn);
  }

  // Medium AI: Minimax with limited depth
  static Move? _getMediumMove(List<List<ChessPiece?>> board, bool isWhiteTurn, 
                             List<int> whiteKingPos, List<int> blackKingPos) {
    return _minimax(board, maxDepth, isWhiteTurn, whiteKingPos, blackKingPos, 
                   -999999, 999999, true);
  }

  // Hard AI: Deeper minimax search
  static Move? _getHardMove(List<List<ChessPiece?>> board, bool isWhiteTurn, 
                           List<int> whiteKingPos, List<int> blackKingPos) {
    return _minimax(board, maxDepthHard, isWhiteTurn, whiteKingPos, blackKingPos, 
                   -999999, 999999, true);
  }

  // Minimax algorithm with alpha-beta pruning
  static Move? _minimax(List<List<ChessPiece?>> board, int depth, bool isWhiteTurn,
                       List<int> whiteKingPos, List<int> blackKingPos, 
                       int alpha, int beta, bool isMaximizing) {
    if (depth == 0) return null;

    List<Move> moves = _getAllValidMoves(board, isWhiteTurn, whiteKingPos, blackKingPos);
    if (moves.isEmpty) return null;

    Move? bestMove;
    int bestValue = isMaximizing ? -999999 : 999999;

    for (Move move in moves) {
      // Make the move
      var backup = _makeMove(board, move);
      var newKingPos = _updateKingPosition(move, whiteKingPos, blackKingPos);
      
      if (depth == 1) {
        // Evaluate position at leaf node
        int value = _evaluateBoard(board, isWhiteTurn, newKingPos[0], newKingPos[1]);
        
        if (isMaximizing) {
          if (value > bestValue) {
            bestValue = value;
            bestMove = move;
          }
          alpha = max(alpha, value);
        } else {
          if (value < bestValue) {
            bestValue = value;
            bestMove = move;
          }
          beta = min(beta, value);
        }
      } else {
        // Recursive minimax call
        Move? childMove = _minimax(board, depth - 1, !isWhiteTurn, 
                                  newKingPos[0], newKingPos[1], alpha, beta, !isMaximizing);
        
        if (childMove != null) {
          int value = _evaluateBoard(board, isWhiteTurn, newKingPos[0], newKingPos[1]);
          
          if (isMaximizing) {
            if (value > bestValue) {
              bestValue = value;
              bestMove = move;
            }
            alpha = max(alpha, value);
          } else {
            if (value < bestValue) {
              bestValue = value;
              bestMove = move;
            }
            beta = min(beta, value);
          }
        }
      }

      // Undo the move
      _undoMove(board, move, backup);
      
      // Alpha-beta pruning
      if (beta <= alpha) break;
    }

    return bestMove;
  }

  // Get all valid moves for current player
  static List<Move> _getAllValidMoves(List<List<ChessPiece?>> board, bool isWhiteTurn,
                                     List<int> whiteKingPos, List<int> blackKingPos) {
    List<Move> moves = [];
    
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null && piece.isWhite == isWhiteTurn) {
          List<List<int>> validMoves = Helper.calculateRealValidMoves(
            row, col, piece, board, whiteKingPos, blackKingPos, true
          );
          
          for (List<int> move in validMoves) {
            moves.add(Move(row, col, move[0], move[1]));
          }
        }
      }
    }
    
    return moves;
  }

  // Basic move evaluation for easy AI
  static Move? _getBestMoveBasic(List<List<ChessPiece?>> board, List<Move> moves, bool isWhiteTurn) {
    Move? bestMove;
    int bestScore = -999999;
    
    for (Move move in moves) {
      int score = 0;
      
      // Prioritize captures
      ChessPiece? targetPiece = board[move.toRow][move.toCol];
      if (targetPiece != null) {
        score += pieceValues[targetPiece.type] ?? 0;
      }
      
      // Prioritize center control
      if ((move.toRow >= 3 && move.toRow <= 4) && (move.toCol >= 3 && move.toCol <= 4)) {
        score += 10;
      }
      
      // Add some randomness
      score += Random().nextInt(50);
      
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    
    return bestMove;
  }

  // Evaluate board position
  static int _evaluateBoard(List<List<ChessPiece?>> board, bool isWhiteTurn, 
                           List<int> whiteKingPos, List<int> blackKingPos) {
    int score = 0;
    
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null) {
          int pieceValue = pieceValues[piece.type] ?? 0;
          int positionValue = _getPositionValue(piece.type, row, col, piece.isWhite);
          
          int totalValue = pieceValue + positionValue;
          
          if (piece.isWhite) {
            score += totalValue;
          } else {
            score -= totalValue;
          }
        }
      }
    }
    
    // Evaluate king safety
    score += _evaluateKingSafety(board, whiteKingPos, blackKingPos);
    
    return isWhiteTurn ? score : -score;
  }

  // Get position value based on piece type and position
  static int _getPositionValue(ChessPieceType type, int row, int col, bool isWhite) {
    List<List<int>> table;
    
    switch (type) {
      case ChessPieceType.pawn:
        table = pawnTable;
        break;
      case ChessPieceType.knight:
        table = knightTable;
        break;
      case ChessPieceType.bishop:
        table = bishopTable;
        break;
      case ChessPieceType.rook:
        table = rookTable;
        break;
      case ChessPieceType.queen:
        table = queenTable;
        break;
      case ChessPieceType.king:
        table = kingTable;
        break;
    }
    
    // Flip table for black pieces
    int tableRow = isWhite ? 7 - row : row;
    return table[tableRow][col];
  }

  // Evaluate king safety
  static int _evaluateKingSafety(List<List<ChessPiece?>> board, 
                                List<int> whiteKingPos, List<int> blackKingPos) {
    int safety = 0;
    
    // Check pieces around kings
    safety += _countPiecesAroundKing(board, whiteKingPos, true) * 10;
    safety -= _countPiecesAroundKing(board, blackKingPos, false) * 10;
    
    return safety;
  }

  // Count friendly pieces around king
  static int _countPiecesAroundKing(List<List<ChessPiece?>> board, 
                                   List<int> kingPos, bool isWhite) {
    int count = 0;
    int kingRow = kingPos[0];
    int kingCol = kingPos[1];
    
    for (int row = kingRow - 1; row <= kingRow + 1; row++) {
      for (int col = kingCol - 1; col <= kingCol + 1; col++) {
        if (row >= 0 && row < 8 && col >= 0 && col < 8) {
          ChessPiece? piece = board[row][col];
          if (piece != null && piece.isWhite == isWhite && 
              !(row == kingRow && col == kingCol)) {
            count++;
          }
        }
      }
    }
    
    return count;
  }

  // Make a move on the board
  static ChessPiece? _makeMove(List<List<ChessPiece?>> board, Move move) {
    ChessPiece? capturedPiece = board[move.toRow][move.toCol];
    board[move.toRow][move.toCol] = board[move.fromRow][move.fromCol];
    board[move.fromRow][move.fromCol] = null;
    return capturedPiece;
  }

  // Undo a move on the board
  static void _undoMove(List<List<ChessPiece?>> board, Move move, ChessPiece? capturedPiece) {
    board[move.fromRow][move.fromCol] = board[move.toRow][move.toCol];
    board[move.toRow][move.toCol] = capturedPiece;
  }

  // Update king position after move
  static List<List<int>> _updateKingPosition(Move move, List<int> whiteKingPos, List<int> blackKingPos) {
    List<int> newWhiteKingPos = List.from(whiteKingPos);
    List<int> newBlackKingPos = List.from(blackKingPos);
    
    // Check if king moved
    if (move.fromRow == whiteKingPos[0] && move.fromCol == whiteKingPos[1]) {
      newWhiteKingPos = [move.toRow, move.toCol];
    }
    if (move.fromRow == blackKingPos[0] && move.fromCol == blackKingPos[1]) {
      newBlackKingPos = [move.toRow, move.toCol];
    }
    
    return [newWhiteKingPos, newBlackKingPos];
  }
}

// Move class to represent chess moves
class Move {
  final int fromRow;
  final int fromCol;
  final int toRow;
  final int toCol;

  Move(this.fromRow, this.fromCol, this.toRow, this.toCol);

  @override
  String toString() {
    return 'Move from ($fromRow,$fromCol) to ($toRow,$toCol)';
  }
}
import 'dart:math';
import 'components/pieces.dart';

class ChessAI {
  
  // Piece values for evaluation
  static const Map<ChessPiecesType, int> pieceValues = {
    ChessPiecesType.pawn: 100,
    ChessPiecesType.knight: 300,
    ChessPiecesType.bishop: 300,
    ChessPiecesType.rook: 500,
    ChessPiecesType.queen: 900,
    ChessPiecesType.king: 10000,
  };


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

  // Easy AI: Depth 1 minimax (just looks at immediate consequences)
  static Move? _getEasyMove(List<List<ChessPiece?>> board, bool isWhiteTurn, 
                           List<int> whiteKingPos, List<int> blackKingPos) {
    return _minimax(board, 1, isWhiteTurn, -999999, 999999, true);
  }

  // Medium AI: Depth 2 minimax (looks 2 moves ahead)
  static Move? _getMediumMove(List<List<ChessPiece?>> board, bool isWhiteTurn, 
                             List<int> whiteKingPos, List<int> blackKingPos) {
    return _minimax(board, 2, isWhiteTurn, -999999, 999999, true);
  }

  // Hard AI: Depth 3 minimax (looks 3 moves ahead)
  static Move? _getHardMove(List<List<ChessPiece?>> board, bool isWhiteTurn, 
                           List<int> whiteKingPos, List<int> blackKingPos) {
    return _minimax(board, 3, isWhiteTurn, -999999, 999999, true);
  }

  // Proper Minimax algorithm with alpha-beta pruning
  static dynamic _minimax(List<List<ChessPiece?>> board, int depth, bool isMaximizing, 
                         int alpha, int beta, bool isRoot) {
    // Base case: if depth is 0, evaluate position
    if (depth == 0) {
      return _evaluatePosition(board, true); // Return evaluation score
    }

    List<Move> moves = _getAllValidMoves(board, isMaximizing, [], []);
    
    // Move ordering for better alpha-beta pruning
    moves = _orderMoves(board, moves);
    
    if (moves.isEmpty) {
      // No moves available - could be checkmate, stalemate, or no pieces
      
      // Check if king exists
      bool hasKing = false;
      int pieceCount = 0;
      for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
          ChessPiece? piece = board[row][col];
          if (piece != null && piece.isWhite == isMaximizing) {
            pieceCount++;
            if (piece.type == ChessPiecesType.king) {
              hasKing = true;
            }
          }
        }
      }
      
      // No king = instant loss
      if (!hasKing) {
        return isMaximizing ? -999999 : 999999;
      }
      
      // Only king left = material loss
      if (pieceCount == 1) {
        return isMaximizing ? -999999 : 999999;
      }
      
      // Check for checkmate vs stalemate
      if (_isInCheck(board, isMaximizing)) {
        // Checkmate - return large penalty/bonus
        return isMaximizing ? -999999 : 999999;
      } else {
        // Stalemate - return 0
        return 0;
      }
    }

    Move? bestMove;
    int bestScore = isMaximizing ? -999999 : 999999;

    for (Move move in moves) {
      // Make the move
      ChessPiece? capturedPiece = _makeMove(board, move);
      
      // Recursive minimax call - THIS IS THE CRITICAL FIX
      dynamic result = _minimax(board, depth - 1, !isMaximizing, alpha, beta, false);
      int score = result is int ? result : result['score'];

      // Undo the move
      _undoMove(board, move, capturedPiece);

      // Update best score and move
      if (isMaximizing) {
        if (score > bestScore) {
          bestScore = score;
          if (isRoot) bestMove = move;
        }
        alpha = max(alpha, score);
      } else {
        if (score < bestScore) {
          bestScore = score;
          if (isRoot) bestMove = move;
        }
        beta = min(beta, score);
      }

      // Alpha-beta pruning
      if (beta <= alpha) {
        break;
      }
    }

    // Return move at root level, score at other levels
    if (isRoot) {
      return bestMove;
    } else {
      return bestScore;
    }
  }

  // Check if king is in check (simplified)
  static bool _isInCheck(List<List<ChessPiece?>> board, bool isWhiteKing) {
    // Find the king
    int kingRow = -1, kingCol = -1;
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null && piece.type == ChessPiecesType.king && piece.isWhite == isWhiteKing) {
          kingRow = row;
          kingCol = col;
          break;
        }
      }
      if (kingRow != -1) break;
    }

    if (kingRow == -1) return false; // King not found

    // Check if any enemy piece can attack the king
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null && piece.isWhite != isWhiteKing) {
          List<List<int>> moves = _calculateValidMoves(row, col, piece, board);
          for (List<int> move in moves) {
            if (move[0] == kingRow && move[1] == kingCol) {
              return true; // King is under attack
            }
          }
        }
      }
    }

    return false;
  }

  // Make a move on the board and return captured piece
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

  // Enhanced position evaluation function
  static int _evaluatePosition(List<List<ChessPiece?>> board, bool fromWhitePerspective) {
    int score = 0;
    
    // 1. Material count (most important)
    int whiteMaterial = 0, blackMaterial = 0;
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null) {
          int pieceValue = pieceValues[piece.type] ?? 0;
          int positionBonus = _getPositionValue(piece.type, row, col, piece.isWhite);
          
          if (piece.isWhite) {
            whiteMaterial += pieceValue + positionBonus;
          } else {
            blackMaterial += pieceValue + positionBonus;
          }
        }
      }
    }
    score += whiteMaterial - blackMaterial;
    
    // 2. King safety
    score += _evaluateKingSafety(board);
    
    // 3. Center control bonus
    score += _evaluateCenterControl(board);
    
    // 4. Check for checkmate/check
    if (_isInCheck(board, true)) {
      score -= 50; // Penalty for white king in check
    }
    if (_isInCheck(board, false)) {
      score += 50; // Bonus if black king in check
    }
    
    return score;
  }

  // Evaluate king safety
  static int _evaluateKingSafety(List<List<ChessPiece?>> board) {
    int safety = 0;
    
    // Find kings and evaluate their safety
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null && piece.type == ChessPiecesType.king) {
          int kingSafety = _countDefenders(board, row, col, piece.isWhite);
          if (piece.isWhite) {
            safety += kingSafety;
          } else {
            safety -= kingSafety;
          }
        }
      }
    }
    
    return safety * 5; // Weight king safety
  }

  // Count pieces defending a square
  static int _countDefenders(List<List<ChessPiece?>> board, int row, int col, bool isWhite) {
    int defenders = 0;
    
    // Check surrounding squares
    for (int r = row - 1; r <= row + 1; r++) {
      for (int c = col - 1; c <= col + 1; c++) {
        if (r >= 0 && r < 8 && c >= 0 && c < 8 && !(r == row && c == col)) {
          ChessPiece? piece = board[r][c];
          if (piece != null && piece.isWhite == isWhite) {
            defenders++;
          }
        }
      }
    }
    
    return defenders;
  }

  // Move ordering for better alpha-beta pruning
  static List<Move> _orderMoves(List<List<ChessPiece?>> board, List<Move> moves) {
    List<MoveScore> moveScores = [];
    
    for (Move move in moves) {
      int score = 0;
      
      // 1. Prioritize captures (MVV-LVA: Most Valuable Victim - Least Valuable Attacker)
      ChessPiece? victim = board[move.toRow][move.toCol];
      ChessPiece? attacker = board[move.fromRow][move.fromCol];
      
      if (victim != null && attacker != null) {
        score += (pieceValues[victim.type] ?? 0) - (pieceValues[attacker.type] ?? 0) ~/ 10;
      }
      
      // 2. Prioritize center moves
      if ((move.toRow >= 3 && move.toRow <= 4) && (move.toCol >= 3 && move.toCol <= 4)) {
        score += 50;
      }
      
      // 3. Prioritize piece development
      if (attacker != null && 
          (attacker.type == ChessPiecesType.knight || attacker.type == ChessPiecesType.bishop) &&
          ((attacker.isWhite && move.fromRow == 7) || (!attacker.isWhite && move.fromRow == 0))) {
        score += 30;
      }
      
      moveScores.add(MoveScore(move, score));
    }
    
    // Sort by score descending (highest first for better pruning)
    moveScores.sort((a, b) => b.score.compareTo(a.score));
    
    return moveScores.map((ms) => ms.move).toList();
  }

  // Evaluate center control
  static int _evaluateCenterControl(List<List<ChessPiece?>> board) {
    int score = 0;
    
    // Check center squares (d4, d5, e4, e5)
    List<List<int>> centerSquares = [[3, 3], [3, 4], [4, 3], [4, 4]];
    
    for (List<int> square in centerSquares) {
      ChessPiece? piece = board[square[0]][square[1]];
      if (piece != null) {
        if (piece.isWhite) {
          score += 20;
        } else {
          score -= 20;
        }
      }
    }
    
    return score;
  }


  // Get all valid moves for current player - simplified version
  static List<Move> _getAllValidMoves(List<List<ChessPiece?>> board, bool isWhiteTurn,
                                     List<int> whiteKingPos, List<int> blackKingPos) {
    List<Move> moves = [];
    
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null && piece.isWhite == isWhiteTurn) {
          List<List<int>> validMoves = _calculateValidMoves(row, col, piece, board);
          
          for (List<int> move in validMoves) {
            moves.add(Move(row, col, move[0], move[1]));
          }
        }
      }
    }
    
    return moves;
  }

  // Simplified move calculation
  static List<List<int>> _calculateValidMoves(int row, int col, ChessPiece piece, List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    
    switch (piece.type) {
      case ChessPiecesType.pawn:
        moves.addAll(_getPawnMoves(row, col, piece.isWhite, board));
        break;
      case ChessPiecesType.rook:
        moves.addAll(_getRookMoves(row, col, piece.isWhite, board));
        break;
      case ChessPiecesType.knight:
        moves.addAll(_getKnightMoves(row, col, piece.isWhite, board));
        break;
      case ChessPiecesType.bishop:
        moves.addAll(_getBishopMoves(row, col, piece.isWhite, board));
        break;
      case ChessPiecesType.queen:
        moves.addAll(_getQueenMoves(row, col, piece.isWhite, board));
        break;
      case ChessPiecesType.king:
        moves.addAll(_getKingMoves(row, col, piece.isWhite, board));
        break;
    }
    
    return moves;
  }

  // Helper method to check if position is valid and not occupied by friendly piece
  static bool _isValidMove(int row, int col, bool isWhite, List<List<ChessPiece?>> board) {
    if (row < 0 || row >= 8 || col < 0 || col >= 8) return false;
    ChessPiece? targetPiece = board[row][col];
    if (targetPiece == null) return true;
    return targetPiece.isWhite != isWhite; // Can capture enemy pieces
  }

  // Pawn moves
  static List<List<int>> _getPawnMoves(int row, int col, bool isWhite, List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    int direction = isWhite ? -1 : 1;
    int startRow = isWhite ? 6 : 1;
    
    // Forward move
    if (_isValidMove(row + direction, col, isWhite, board) && board[row + direction][col] == null) {
      moves.add([row + direction, col]);
      
      // Double move from starting position
      if (row == startRow && board[row + 2 * direction][col] == null) {
        moves.add([row + 2 * direction, col]);
      }
    }
    
    // Diagonal captures
    if (_isValidMove(row + direction, col - 1, isWhite, board) && board[row + direction][col - 1] != null) {
      moves.add([row + direction, col - 1]);
    }
    if (_isValidMove(row + direction, col + 1, isWhite, board) && board[row + direction][col + 1] != null) {
      moves.add([row + direction, col + 1]);
    }
    
    return moves;
  }

  // Rook moves
  static List<List<int>> _getRookMoves(int row, int col, bool isWhite, List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    
    // Horizontal and vertical directions
    List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    
    for (List<int> dir in directions) {
      for (int i = 1; i < 8; i++) {
        int newRow = row + dir[0] * i;
        int newCol = col + dir[1] * i;
        
        if (newRow < 0 || newRow >= 8 || newCol < 0 || newCol >= 8) break;
        
        if (board[newRow][newCol] == null) {
          moves.add([newRow, newCol]);
        } else if (board[newRow][newCol]!.isWhite != isWhite) {
          moves.add([newRow, newCol]); // Capture
          break;
        } else {
          break; // Blocked by friendly piece
        }
      }
    }
    
    return moves;
  }

  // Knight moves
  static List<List<int>> _getKnightMoves(int row, int col, bool isWhite, List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    List<List<int>> knightMoves = [
      [-2, -1], [-2, 1], [-1, -2], [-1, 2],
      [1, -2], [1, 2], [2, -1], [2, 1]
    ];
    
    for (List<int> move in knightMoves) {
      int newRow = row + move[0];
      int newCol = col + move[1];
      
      if (_isValidMove(newRow, newCol, isWhite, board)) {
        moves.add([newRow, newCol]);
      }
    }
    
    return moves;
  }

  // Bishop moves
  static List<List<int>> _getBishopMoves(int row, int col, bool isWhite, List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    
    // Diagonal directions
    List<List<int>> directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]];
    
    for (List<int> dir in directions) {
      for (int i = 1; i < 8; i++) {
        int newRow = row + dir[0] * i;
        int newCol = col + dir[1] * i;
        
        if (newRow < 0 || newRow >= 8 || newCol < 0 || newCol >= 8) break;
        
        if (board[newRow][newCol] == null) {
          moves.add([newRow, newCol]);
        } else if (board[newRow][newCol]!.isWhite != isWhite) {
          moves.add([newRow, newCol]); // Capture
          break;
        } else {
          break; // Blocked by friendly piece
        }
      }
    }
    
    return moves;
  }

  // Queen moves (combination of rook and bishop)
  static List<List<int>> _getQueenMoves(int row, int col, bool isWhite, List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    moves.addAll(_getRookMoves(row, col, isWhite, board));
    moves.addAll(_getBishopMoves(row, col, isWhite, board));
    return moves;
  }

  // King moves
  static List<List<int>> _getKingMoves(int row, int col, bool isWhite, List<List<ChessPiece?>> board) {
    List<List<int>> moves = [];
    
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;
        
        int newRow = row + i;
        int newCol = col + j;
        
        if (_isValidMove(newRow, newCol, isWhite, board)) {
          moves.add([newRow, newCol]);
        }
      }
    }
    
    return moves;
  }



  // Simplified position value (lightweight)
  static int _getPositionValue(ChessPiecesType type, int row, int col, bool isWhite) {
    // Simple center bonus
    int centerBonus = 0;
    if ((row >= 3 && row <= 4) && (col >= 3 && col <= 4)) {
      centerBonus = 10;
    }
    
    // Piece-specific simple bonuses
    switch (type) {
      case ChessPiecesType.pawn:
        return centerBonus + (isWhite ? (7 - row) : row); // Advance bonus
      case ChessPiecesType.knight:
      case ChessPiecesType.bishop:
        return centerBonus + 5;
      case ChessPiecesType.rook:
      case ChessPiecesType.queen:
        return centerBonus;
      case ChessPiecesType.king:
        return 0; // Kings don't need position bonus in simplified version
    }
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

// Helper class for move ordering
class MoveScore {
  final Move move;
  final int score;

  MoveScore(this.move, this.score);
}
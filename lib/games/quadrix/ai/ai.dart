import 'dart:math';

const int rows = 6;
const int cols = 7;

int getAIMove(List<List<int>> board, {String difficulty = 'Medium'}) {
  switch (difficulty) {
    case 'Easy':
      return getEasyMove(board);
    case 'Hard':
      return getHardMove(board);
    case 'Medium':
    default:
      return getMediumMove(board);
  }
}

int getEasyMove(List<List<int>> board) {
  final random = Random();
  
  // 30% chance to make optimal move, 70% chance for random valid move
  if (random.nextDouble() < 0.3) {
    return getMediumMove(board);
  }
  
  // Random valid move
  List<int> validColumns = [];
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      validColumns.add(c);
    }
  }
  
  if (validColumns.isEmpty) return -1;
  return validColumns[random.nextInt(validColumns.length)];
}

int getMediumMove(List<List<int>> board) {
  // 1. Try to win immediately
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 2);
      if (checkWin(copy, 2)) return c;
    }
  }

  // 2. Block immediate opponent win
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 1);
      if (checkWin(copy, 1)) return c;
    }
  }

  // 3. Look for moves that create multiple threats
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 2);
      if (countActualThreats(copy, 2) >= 2) return c;
    }
  }

  // 4. Block opponent from creating multiple threats
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 1);
      if (countActualThreats(copy, 1) >= 2) return c;
    }
  }

  // 5. Use shallow minimax for tactical awareness
  int bestMove = -1;
  int bestScore = -1000;
  List<int> centerPreference = [3, 2, 4, 1, 5, 0, 6];
  
  for (int c in centerPreference) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 2);
      int score = minimaxEnhanced(copy, 4, false, -1000, 1000, 2);
      if (score > bestScore) {
        bestScore = score;
        bestMove = c;
      }
    }
  }

  return bestMove != -1 ? bestMove : centerPreference.firstWhere((c) => canDrop(board, c), orElse: () => -1);
}

int getHardMove(List<List<int>> board) {
  // Start with immediate tactics, then use negamax if needed
  
  // 1. Immediate win check
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 2);
      if (checkWin(copy, 2)) return c;
    }
  }
  
  // 2. Block immediate opponent win
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 1);
      if (checkWin(copy, 1)) return c;
    }
  }
  
  // 3. Use optimized negamax with reasonable depth
  int move = negamaxSolver(board, 6, -100000, 100000, 2);
  
  // 4. Fallback to center if something goes wrong
  if (move == -1 || !canDrop(board, move)) {
    List<int> centerPreference = [3, 2, 4, 1, 5, 0, 6];
    for (int c in centerPreference) {
      if (canDrop(board, c)) return c;
    }
  }
  
  return move;
}

// Check if a move gives opponent an immediate winning opportunity
bool givesOpponentWin(List<List<int>> board, int col) {
  if (!canDrop(board, col)) return false;
  
  List<List<int>> afterMove = cloneBoard(board);
  drop(afterMove, col, 2); // AI makes the move
  
  // Check if opponent can win on next move
  for (int c = 0; c < cols; c++) {
    if (canDrop(afterMove, c)) {
      List<List<int>> afterOpponent = cloneBoard(afterMove);
      drop(afterOpponent, c, 1);
      if (checkWin(afterOpponent, 1)) {
        return true; // This move gives opponent a win
      }
    }
  }
  
  return false;
}

int minimax(List<List<int>> board, int depth, bool isMaximizing, int alpha, int beta) {
  if (depth == 0 || isGameOver(board)) {
    return evaluateBoard(board);
  }
  
  if (isMaximizing) {
    int maxEval = -1000;
    for (int c = 0; c < cols; c++) {
      if (canDrop(board, c)) {
        List<List<int>> copy = cloneBoard(board);
        drop(copy, c, 2);
        int eval = minimax(copy, depth - 1, false, alpha, beta);
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);
        if (beta <= alpha) break;
      }
    }
    return maxEval;
  } else {
    int minEval = 1000;
    for (int c = 0; c < cols; c++) {
      if (canDrop(board, c)) {
        List<List<int>> copy = cloneBoard(board);
        drop(copy, c, 1);
        int eval = minimax(copy, depth - 1, true, alpha, beta);
        minEval = min(minEval, eval);
        beta = min(beta, eval);
        if (beta <= alpha) break;
      }
    }
    return minEval;
  }
}

int evaluateBoard(List<List<int>> board) {
  if (checkWin(board, 2)) return 100;
  if (checkWin(board, 1)) return -100;
  
  int score = 0;
  // Add positional scoring
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      if (board[r][c] == 2) {
        score += getPositionScore(r, c);
      } else if (board[r][c] == 1) {
        score -= getPositionScore(r, c);
      }
    }
  }
  
  return score;
}

int getPositionScore(int row, int col) {
  // Center columns are more valuable
  int centerDistance = (col - 3).abs();
  int centerScore = 4 - centerDistance;
  
  // Lower rows are more valuable
  int heightScore = rows - row;
  
  return centerScore + heightScore;
}

bool isGameOver(List<List<int>> board) {
  return checkWin(board, 1) || checkWin(board, 2) || isBoardFull(board);
}

bool isBoardFull(List<List<int>> board) {
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) return false;
  }
  return true;
}

// Enhanced minimax with better evaluation - FIXED VERSION
int minimaxEnhanced(List<List<int>> board, int depth, bool isMaximizing, int alpha, int beta, int aiPlayer) {
  if (depth == 0 || isGameOver(board)) {
    return evaluateBoardEnhanced(board, aiPlayer);
  }
  
  if (isMaximizing) {
    int maxEval = -10000;
    List<int> moveOrder = getMoveOrder(board, aiPlayer); // Smarter move ordering
    
    for (int c in moveOrder) {
      if (canDrop(board, c)) {
        List<List<int>> copy = cloneBoard(board);
        drop(copy, c, aiPlayer); // AI player's move
        int eval = minimaxEnhanced(copy, depth - 1, false, alpha, beta, aiPlayer);
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);
        if (beta <= alpha) break; // Alpha-beta pruning
      }
    }
    return maxEval;
  } else {
    int minEval = 10000;
    List<int> moveOrder = getMoveOrder(board, aiPlayer == 1 ? 2 : 1); // Opponent move ordering
    
    for (int c in moveOrder) {
      if (canDrop(board, c)) {
        List<List<int>> copy = cloneBoard(board);
        int opponent = aiPlayer == 1 ? 2 : 1;
        drop(copy, c, opponent); // Opponent's move
        int eval = minimaxEnhanced(copy, depth - 1, true, alpha, beta, aiPlayer);
        minEval = min(minEval, eval);
        beta = min(beta, eval);
        if (beta <= alpha) break; // Alpha-beta pruning
      }
    }
    return minEval;
  }
}

// Intelligent move ordering for better alpha-beta pruning
List<int> getMoveOrder(List<List<int>> board, int player) {
  List<MapEntry<int, int>> columnScores = [];
  
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, player);
      
      int score = 0;
      // Prioritize winning moves
      if (checkWin(copy, player)) score += 10000;
      // Prioritize blocking opponent wins
      if (isOpponentThreat(board, c, player == 1 ? 2 : 1)) score += 5000;
      // Prefer center columns
      score += 100 - (c - 3).abs() * 10;
      
      columnScores.add(MapEntry(c, score));
    }
  }
  
  // Sort by score descending
  columnScores.sort((a, b) => b.value.compareTo(a.value));
  return columnScores.map((e) => e.key).toList();
}

// Check if placing a piece creates a threat for opponent
bool isOpponentThreat(List<List<int>> board, int col, int opponent) {
  if (!canDrop(board, col)) return false;
  
  List<List<int>> copy = cloneBoard(board);
  drop(copy, col, opponent);
  return checkWin(copy, opponent);
}

// Find forced wins (positions that create multiple threats) - IMPROVED
int findForcedWin(List<List<int>> board, int player) {
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, player);
      
      // Count actual threats (not just any winning move)
      int threats = countActualThreats(copy, player);
      if (threats >= 2) {
        return c; // Multiple threats = forced win
      }
    }
  }
  return -1;
}

// Count immediate winning threats that opponent cannot block simultaneously
int countActualThreats(List<List<int>> board, int player) {
  int threats = 0;
  
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, player);
      if (checkWin(copy, player)) {
        // This is a valid threat - check if it's on top row or has support
        if (isValidThreat(board, c)) {
          threats++;
        }
      }
    }
  }
  
  return threats;
}

// Check if a threat is actually playable (has proper support)
bool isValidThreat(List<List<int>> board, int col) {
  if (!canDrop(board, col)) return false;
  
  // Find the row where the piece would land
  for (int r = rows - 1; r >= 0; r--) {
    if (board[r][col] == 0) {
      // This is where the piece would land
      return true; // In Connect Four, gravity ensures this is always valid
    }
  }
  return false;
}

// Enhanced board evaluation with strategic patterns
int evaluateBoardEnhanced(List<List<int>> board, int player) {
  int opponent = player == 1 ? 2 : 1;
  
  // Check for immediate wins/losses
  if (checkWin(board, player)) return 5000;
  if (checkWin(board, opponent)) return -5000;
  
  int score = 0;
  
  // Evaluate all possible 4-in-a-row windows
  score += evaluateWindows(board, player);
  
  // Strategic position values
  score += evaluateHeightAdvantage(board, player);
  
  // Control of center columns
  score += evaluateCenterControl(board, player);
  
  // Threat analysis
  score += evaluateThreats(board, player);
  
  return score;
}

// Evaluate all 4-piece windows for patterns
int evaluateWindows(List<List<int>> board, int player) {
  int score = 0;
  int opponent = player == 1 ? 2 : 1;
  
  // Check all horizontal windows
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c <= cols - 4; c++) {
      List<int> window = [board[r][c], board[r][c+1], board[r][c+2], board[r][c+3]];
      score += evaluateWindow(window, player, opponent);
    }
  }
  
  // Check all vertical windows
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r <= rows - 4; r++) {
      List<int> window = [board[r][c], board[r+1][c], board[r+2][c], board[r+3][c]];
      score += evaluateWindow(window, player, opponent);
    }
  }
  
  // Check positive diagonal windows
  for (int r = 0; r <= rows - 4; r++) {
    for (int c = 0; c <= cols - 4; c++) {
      List<int> window = [board[r][c], board[r+1][c+1], board[r+2][c+2], board[r+3][c+3]];
      score += evaluateWindow(window, player, opponent);
    }
  }
  
  // Check negative diagonal windows
  for (int r = 3; r < rows; r++) {
    for (int c = 0; c <= cols - 4; c++) {
      List<int> window = [board[r][c], board[r-1][c+1], board[r-2][c+2], board[r-3][c+3]];
      score += evaluateWindow(window, player, opponent);
    }
  }
  
  return score;
}

// Evaluate a 4-piece window for strategic value
int evaluateWindow(List<int> window, int player, int opponent) {
  int score = 0;
  
  int playerCount = window.where((piece) => piece == player).length;
  int opponentCount = window.where((piece) => piece == opponent).length;
  int emptyCount = window.where((piece) => piece == 0).length;
  
  if (playerCount == 4) {
    score += 100; // Winning position
  } else if (playerCount == 3 && emptyCount == 1) {
    score += 10; // Three in a row with space
  } else if (playerCount == 2 && emptyCount == 2) {
    score += 2; // Two in a row with spaces
  }
  
  if (opponentCount == 3 && emptyCount == 1) {
    score -= 80; // Block opponent threats
  } else if (opponentCount == 2 && emptyCount == 2) {
    score -= 3; // Reduce opponent potential
  }
  
  return score;
}

// OLD evaluatePosition function removed - using professional version below

// Evaluate control of center columns
int evaluateCenterControl(List<List<int>> board, int player) {
  int score = 0;
  int opponent = player == 1 ? 2 : 1;
  
  // Center columns (2, 3, 4) are most valuable
  for (int c = 2; c <= 4; c++) {
    for (int r = 0; r < rows; r++) {
      if (board[r][c] == player) {
        score += c == 3 ? 3 : 2; // Middle column is worth more
      } else if (board[r][c] == opponent) {
        score -= c == 3 ? 3 : 2;
      }
    }
  }
  
  return score;
}

// Evaluate threat situations - IMPROVED
int evaluateThreats(List<List<int>> board, int player) {
  int playerThreats = countActualThreats(board, player);
  int opponentThreats = countActualThreats(board, player == 1 ? 2 : 1);
  
  // Weight opponent threats more heavily (defense is crucial)
  return (playerThreats * 50) - (opponentThreats * 80);
}

// Simplified but effective Connect Four solver
int negamaxSolver(List<List<int>> board, int depth, int alpha, int beta, int player) {
  int bestMove = 3; // Default to center
  int bestScore = -100000;
  
  // Simple move ordering: center first
  List<int> moves = [3, 2, 4, 1, 5, 0, 6];
  
  for (int col in moves) {
    if (canDrop(board, col)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, col, player);
      
      // Quick win check
      if (checkWin(copy, player)) {
        return col;
      }
      
      int score = -negamaxSimple(copy, depth - 1, -beta, -alpha, player == 1 ? 2 : 1);
      
      if (score > bestScore) {
        bestScore = score;
        bestMove = col;
      }
      
      alpha = max(alpha, score);
      if (beta <= alpha) break;
    }
  }
  
  return bestMove;
}

// Simple but effective negamax
int negamaxSimple(List<List<int>> board, int depth, int alpha, int beta, int player) {
  if (depth == 0 || isGameOver(board)) {
    return evaluateSimple(board, player);
  }
  
  int maxScore = -50000;
  
  for (int col = 0; col < cols; col++) {
    if (canDrop(board, col)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, col, player);
      
      // Quick win check
      if (checkWin(copy, player)) {
        return 10000 + depth;
      }
      
      int score = -negamaxSimple(copy, depth - 1, -beta, -alpha, player == 1 ? 2 : 1);
      maxScore = max(maxScore, score);
      alpha = max(alpha, score);
      
      if (beta <= alpha) break;
    }
  }
  
  return maxScore;
}

// Simplified evaluation function
int evaluateSimple(List<List<int>> board, int player) {
  if (checkWin(board, player)) return 10000;
  if (checkWin(board, player == 1 ? 2 : 1)) return -10000;
  
  int score = 0;
  
  // Simple center preference
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      if (board[r][c] == player) {
        score += (4 - (c - 3).abs()) * 2; // Center bonus
        score += (rows - r); // Height bonus
      } else if (board[r][c] == (player == 1 ? 2 : 1)) {
        score -= (4 - (c - 3).abs()) * 2;
        score -= (rows - r);
      }
    }
  }
  
  return score;
}

// Professional move ordering for Connect Four
List<int> getOrderedMoves(List<List<int>> board, int player) {
  List<MapEntry<int, int>> columnScores = [];
  int opponent = player == 1 ? 2 : 1;
  
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      int score = 0;
      
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, player);
      
      // Winning moves get highest priority
      if (checkWin(copy, player)) {
        score += 100000;
      }
      
      // Blocking opponent wins
      List<List<int>> opponentCopy = cloneBoard(board);
      drop(opponentCopy, c, opponent);
      if (checkWin(opponentCopy, opponent)) {
        score += 50000;
      }
      
      // Avoid giving opponent a win next turn
      if (!givesOpponentWinProfessional(board, c, player)) {
        score += 10000;
      }
      
      // Center control bonus
      score += (4 - (c - 3).abs()) * 100;
      
      // Look for multiple threat creation
      score += countConnectedThreats(copy, player) * 1000;
      
      columnScores.add(MapEntry(c, score));
    }
  }
  
  // Sort by score descending
  columnScores.sort((a, b) => b.value.compareTo(a.value));
  return columnScores.map((e) => e.key).toList();
}

// Professional evaluation function for Connect Four
int evaluatePosition(List<List<int>> board, int player) {
  if (checkWin(board, player)) return 500000;
  if (checkWin(board, player == 1 ? 2 : 1)) return -500000;
  
  int score = 0;
  int opponent = player == 1 ? 2 : 1;
  
  // Evaluate all windows of 4
  score += evaluateWindows(board, player) * 10;
  
  // Center column control
  score += evaluateCenterControl(board, player) * 3;
  
  // Connected threats
  score += countConnectedThreats(board, player) * 50;
  score -= countConnectedThreats(board, opponent) * 60;
  
  // Height advantage (lower pieces are more stable)
  score += evaluateHeightAdvantage(board, player) * 2;
  
  return score;
}

// Count connected three-in-a-rows that can become four
int countConnectedThreats(List<List<int>> board, int player) {
  int threats = 0;
  
  // Check all possible 4-piece windows for 3-in-a-row + empty
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c <= cols - 4; c++) {
      // Horizontal
      List<int> window = [board[r][c], board[r][c+1], board[r][c+2], board[r][c+3]];
      if (isThreeInARow(window, player)) threats++;
    }
  }
  
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r <= rows - 4; r++) {
      // Vertical
      List<int> window = [board[r][c], board[r+1][c], board[r+2][c], board[r+3][c]];
      if (isThreeInARow(window, player)) threats++;
    }
  }
  
  // Diagonals
  for (int r = 0; r <= rows - 4; r++) {
    for (int c = 0; c <= cols - 4; c++) {
      List<int> window1 = [board[r][c], board[r+1][c+1], board[r+2][c+2], board[r+3][c+3]];
      List<int> window2 = [board[r+3][c], board[r+2][c+1], board[r+1][c+2], board[r][c+3]];
      if (isThreeInARow(window1, player)) threats++;
      if (isThreeInARow(window2, player)) threats++;
    }
  }
  
  return threats;
}

bool isThreeInARow(List<int> window, int player) {
  int playerCount = window.where((x) => x == player).length;
  int emptyCount = window.where((x) => x == 0).length;
  return playerCount == 3 && emptyCount == 1;
}

int evaluateHeightAdvantage(List<List<int>> board, int player) {
  int score = 0;
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      if (board[r][c] == player) {
        score += (rows - r); // Lower pieces worth more
      } else if (board[r][c] == (player == 1 ? 2 : 1)) {
        score -= (rows - r);
      }
    }
  }
  return score;
}

bool givesOpponentWinProfessional(List<List<int>> board, int col, int player) {
  if (!canDrop(board, col)) return false;
  
  List<List<int>> afterMove = cloneBoard(board);
  drop(afterMove, col, player);
  
  int opponent = player == 1 ? 2 : 1;
  
  // Check if opponent gets immediate win
  for (int c = 0; c < cols; c++) {
    if (canDrop(afterMove, c)) {
      List<List<int>> opponentMove = cloneBoard(afterMove);
      drop(opponentMove, c, opponent);
      if (checkWin(opponentMove, opponent)) {
        return true;
      }
    }
  }
  
  return false;
}

bool canDrop(List<List<int>> board, int col) {
  if (col < 0 || col >= cols) return false;
  return board[0][col] == 0;
}

void drop(List<List<int>> board, int col, int player) {
  for (int r = rows - 1; r >= 0; r--) {
    if (board[r][col] == 0) {
      board[r][col] = player;
      return;
    }
  }
}

List<List<int>> cloneBoard(List<List<int>> board) {
  return List.generate(rows, (r) => List.from(board[r]));
}

bool checkWin(List<List<int>> board, int player) {
  // Horizontal
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c <= cols - 4; c++) {
      if (List.generate(4, (i) => board[r][c + i]).every((v) => v == player)) return true;
    }
  }

  // Vertical
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r <= rows - 4; r++) {
      if (List.generate(4, (i) => board[r + i][c]).every((v) => v == player)) return true;
    }
  }

  // Diagonal /
  for (int r = 3; r < rows; r++) {
    for (int c = 0; c <= cols - 4; c++) {
      if (List.generate(4, (i) => board[r - i][c + i]).every((v) => v == player)) return true;
    }
  }

  // Diagonal \
  for (int r = 0; r <= rows - 4; r++) {
    for (int c = 0; c <= cols - 4; c++) {
      if (List.generate(4, (i) => board[r + i][c + i]).every((v) => v == player)) return true;
    }
  }

  return false;
}

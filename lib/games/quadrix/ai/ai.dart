import 'dart:math';

const int rows = 7;
const int cols = 7;

int getAIMove(List<List<int>> board, {String difficulty = 'Hard'}) {
  return getHardMove(board);
}


int getHardMove(List<List<int>> board) {
  print('\n🤖 AI TURN - ANALYZING BOARD:');
  printBoardState(board);
  print('\n🔍 SCANNING FOR THREATS:');
  printAllUserThreats(board);
  printAllAIThreats(board);
  
  // 1. HIGHEST PRIORITY: Check if AI can win immediately
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 2);
      if (checkWin(copy, 2)) {
        print('🎯 AI CAN WIN in column $c!');
        return c;
      }
    }
  }
  
  // 2. Check if AI has 3-in-a-row opportunities (but only if safe)
  int aiWinColumn = findAIThreeInARowToComplete(board);
  if (aiWinColumn != -1) {
    // SAFETY CHECK: Does this move gift the user a win?
    if (!doesMoveGiftOpponentWin(board, aiWinColumn)) {
      print('🚀 AI safely completing 3-in-a-row in column $aiWinColumn');
      return aiWinColumn;
    } else {
      print('⚠️ AI 3-in-a-row in column $aiWinColumn would gift user a win - SKIPPING');
    }
  }
  
  // 3. Block user's 3-in-a-row threats
  int blockColumn = findThreeInARowToBlock(board);
  if (blockColumn != -1) {
    print('🛡️ AI blocking user threat in column $blockColumn');
    return blockColumn;
  }
  
  // 3. Block immediate opponent win (but not if AI move there also causes opponent win)
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      // First check if AI placing there causes opponent to win
      List<List<int>> aiMove = cloneBoard(board);
      drop(aiMove, c, 2);
      if (checkWin(aiMove, 1)) continue; // Skip this move - it gives opponent the win!
      
      // Now check if opponent placing there would win
      List<List<int>> opponentMove = cloneBoard(board);
      drop(opponentMove, c, 1);
      if (checkWin(opponentMove, 1)) return c;
    }
  }
  
  // 4. Use optimized negamax with deep search (but check safety first)
  int move = negamaxSolver(board, 8, -100000, 100000, 2);
  
  if (move != -1 && canDrop(board, move)) {
    // Safety check the negamax move too
    if (!doesMoveGiftOpponentWin(board, move)) {
      print('🧠 AI using safe negamax move: column $move');
      return move;
    } else {
      print('⚠️ Negamax move $move would gift user a win - using fallback');
    }
  }
  
  // 5. Find ANY safe move (check all columns for safety)
  print('🔍 Checking all columns for safety...');
  List<int> safeMoves = [];
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c) && !doesMoveGiftOpponentWin(board, c)) {
      safeMoves.add(c);
      print('✅ Column $c is SAFE');
    } else if (canDrop(board, c)) {
      print('❌ Column $c gifts user a win');
    }
  }
  
  if (safeMoves.isNotEmpty) {
    // Prefer center among safe moves
    List<int> centerPreference = [3, 2, 4, 1, 5, 0, 6];
    for (int c in centerPreference) {
      if (safeMoves.contains(c)) {
        print('🏠 AI using safe preferred move: column $c');
        return c;
      }
    }
    // If no center moves are safe, pick first safe move
    print('🎯 AI using first safe move: column ${safeMoves[0]}');
    return safeMoves[0];
  }
  
  // 6. Emergency: ALL moves gift wins - pick center as least bad
  print('🆘 CRITICAL: All moves gift user wins! Using emergency center move.');
  if (canDrop(board, 3)) return 3;
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) return c;
  }
  
  return 3; // Ultimate fallback
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

// COMPREHENSIVE THREAT DETECTION - Check ALL directions for 3-in-a-row threats
bool hasAnyThreat(List<List<int>> board, int col, int player) {
  if (!canDrop(board, col)) return false;
  
  // Find where the piece would land
  int landingRow = -1;
  for (int r = rows - 1; r >= 0; r--) {
    if (board[r][col] == 0) {
      landingRow = r;
      break;
    }
  }
  
  if (landingRow == -1) return false;
  
  // Check vertical threat (3 pieces below landing position)
  int verticalCount = 0;
  for (int r = landingRow + 1; r < rows; r++) {
    if (board[r][col] == player) {
      verticalCount++;
    } else {
      break;
    }
  }
  
  if (verticalCount >= 3) {
    return true;
  }
  
  // Check horizontal threat (3 pieces in a row horizontally)
  int leftCount = 0;
  for (int c = col - 1; c >= 0; c--) {
    if (board[landingRow][c] == player) {
      leftCount++;
    } else {
      break;
    }
  }
  
  int rightCount = 0;
  for (int c = col + 1; c < cols; c++) {
    if (board[landingRow][c] == player) {
      rightCount++;
    } else {
      break;
    }
  }
  
  if (leftCount + rightCount >= 3) {
    return true;
  }
  
  // Check diagonal threat (\ direction)
  int diagDownLeft = 0;
  for (int i = 1; landingRow + i < rows && col - i >= 0; i++) {
    if (board[landingRow + i][col - i] == player) {
      diagDownLeft++;
    } else {
      break;
    }
  }
  
  int diagUpRight = 0;
  for (int i = 1; landingRow - i >= 0 && col + i < cols; i++) {
    if (board[landingRow - i][col + i] == player) {
      diagUpRight++;
    } else {
      break;
    }
  }
  
  if (diagDownLeft + diagUpRight >= 3) {
    return true;
  }
  
  // Check diagonal threat (/ direction)
  int diagDownRight = 0;
  for (int i = 1; landingRow + i < rows && col + i < cols; i++) {
    if (board[landingRow + i][col + i] == player) {
      diagDownRight++;
    } else {
      break;
    }
  }
  
  int diagUpLeft = 0;
  for (int i = 1; landingRow - i >= 0 && col - i >= 0; i++) {
    if (board[landingRow - i][col - i] == player) {
      diagUpLeft++;
    } else {
      break;
    }
  }
  
  if (diagDownRight + diagUpLeft >= 3) {
    return true;
  }
  
  return false;
}

// DEAD SIMPLE: Find any 3 consecutive human pieces and return column to block
int findThreeInARowToBlock(List<List<int>> board) {
  print('=== SCANNING BOARD FOR 3-IN-A-ROW ===');
  
  // Print current board state
  for (int r = 0; r < rows; r++) {
    print('Row $r: ${board[r]}');
  }
  
  // Check vertical 3-in-a-row FIRST (most common when user plays straight down)
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r <= rows - 3; r++) {
      if (board[r][c] == 1 && board[r+1][c] == 1 && board[r+2][c] == 1) {
        print('FOUND 3 VERTICAL PIECES in column $c at rows $r,${r+1},${r+2}');
        if (canDrop(board, c)) {
          print('BLOCKING in column $c');
          return c;
        } else {
          print('Cannot drop in column $c - full!');
        }
      }
    }
  }
  
  // Check horizontal 3-in-a-row
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 1 && board[r][c+1] == 1 && board[r][c+2] == 1) {
        print('FOUND 3 HORIZONTAL PIECES at row $r, columns $c,${c+1},${c+2}');
        if (c > 0 && canDrop(board, c-1)) {
          print('BLOCKING left at column ${c-1}');
          return c-1;
        }
        if (c+3 < cols && canDrop(board, c+3)) {
          print('BLOCKING right at column ${c+3}');
          return c+3;
        }
      }
    }
  }
  
  // Check diagonal \ 3-in-a-row
  for (int r = 0; r <= rows - 3; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 1 && board[r+1][c+1] == 1 && board[r+2][c+2] == 1) {
        // Found 3 diagonal pieces! Try to block
        if (r > 0 && c > 0 && canDrop(board, c-1)) return c-1;
        if (r+3 < rows && c+3 < cols && canDrop(board, c+3)) return c+3;
      }
    }
  }
  
  // Check diagonal / 3-in-a-row
  for (int r = 2; r < rows; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 1 && board[r-1][c+1] == 1 && board[r-2][c+2] == 1) {
        // Found 3 diagonal pieces! Try to block
        if (r < rows-1 && c > 0 && canDrop(board, c-1)) return c-1;
        if (r > 2 && c+3 < cols && canDrop(board, c+3)) return c+3;
      }
    }
  }
  
  print('NO 3-IN-A-ROW FOUND!');
  return -1; // No 3-in-a-row found
}

// Print the current board state in a readable format
void printBoardState(List<List<int>> board) {
  print('   0 1 2 3 4 5 6  (columns)');
  for (int r = 0; r < rows; r++) {
    String row = '$r: ';
    for (int c = 0; c < cols; c++) {
      String piece = board[r][c] == 0 ? '·' : (board[r][c] == 1 ? '🔴' : '🔵');
      row += '$piece ';
    }
    print(row);
  }
  print('Board size: ${rows}x${cols}');
}

// Find and print ALL user threats (3-in-a-row patterns)
void printAllUserThreats(List<List<int>> board) {
  List<String> threats = [];
  
  // Check vertical threats
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r <= rows - 3; r++) {
      if (board[r][c] == 1 && board[r+1][c] == 1 && board[r+2][c] == 1) {
        threats.add('VERTICAL: Column $c, Rows $r-${r+2}');
      }
    }
  }
  
  // Check horizontal threats  
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 1 && board[r][c+1] == 1 && board[r][c+2] == 1) {
        threats.add('HORIZONTAL: Row $r, Columns $c-${c+2}');
      }
    }
  }
  
  // Check diagonal \ threats
  for (int r = 0; r <= rows - 3; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 1 && board[r+1][c+1] == 1 && board[r+2][c+2] == 1) {
        threats.add('DIAGONAL \\: Starting ($r,$c) to (${r+2},${c+2})');
      }
    }
  }
  
  // Check diagonal / threats
  for (int r = 2; r < rows; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 1 && board[r-1][c+1] == 1 && board[r-2][c+2] == 1) {
        threats.add('DIAGONAL /: Starting ($r,$c) to (${r-2},${c+2})');
      }
    }
  }
  
  if (threats.isEmpty) {
    print('❌ No user 3-in-a-row threats');
  } else {
    print('⚠️  USER THREATS:');
    for (String threat in threats) {
      print('   🚨 $threat');
    }
  }
}

// Find and print ALL AI opportunities (3-in-a-row patterns)
void printAllAIThreats(List<List<int>> board) {
  List<String> opportunities = [];
  
  // Check vertical opportunities
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r <= rows - 3; r++) {
      if (board[r][c] == 2 && board[r+1][c] == 2 && board[r+2][c] == 2) {
        opportunities.add('VERTICAL: Column $c, Rows $r-${r+2}');
      }
    }
  }
  
  // Check horizontal opportunities  
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 2 && board[r][c+1] == 2 && board[r][c+2] == 2) {
        opportunities.add('HORIZONTAL: Row $r, Columns $c-${c+2}');
      }
    }
  }
  
  // Check diagonal \ opportunities
  for (int r = 0; r <= rows - 3; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 2 && board[r+1][c+1] == 2 && board[r+2][c+2] == 2) {
        opportunities.add('DIAGONAL \\: Starting ($r,$c) to (${r+2},${c+2})');
      }
    }
  }
  
  // Check diagonal / opportunities
  for (int r = 2; r < rows; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 2 && board[r-1][c+1] == 2 && board[r-2][c+2] == 2) {
        opportunities.add('DIAGONAL /: Starting ($r,$c) to (${r-2},${c+2})');
      }
    }
  }
  
  if (opportunities.isEmpty) {
    print('❌ No AI 3-in-a-row opportunities');
  } else {
    print('💪 AI OPPORTUNITIES:');
    for (String opportunity in opportunities) {
      print('   ⭐ $opportunity');
    }
  }
}

// Find AI's 3-in-a-row patterns and return column to complete them
int findAIThreeInARowToComplete(List<List<int>> board) {
  // Check vertical 3-in-a-row for AI (player 2)
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r <= rows - 3; r++) {
      if (board[r][c] == 2 && board[r+1][c] == 2 && board[r+2][c] == 2) {
        // Found 3 vertical AI pieces! Try to complete on top
        if (canDrop(board, c)) return c;
      }
    }
  }
  
  // Check horizontal 3-in-a-row for AI
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c <= cols - 3; c++) {
      if (board[r][c] == 2 && board[r][c+1] == 2 && board[r][c+2] == 2) {
        // Found 3 horizontal AI pieces! Try to complete on either side
        if (c > 0 && canDrop(board, c-1)) return c-1; // Complete left
        if (c+3 < cols && canDrop(board, c+3)) return c+3; // Complete right
      }
    }
  }
  
  // Check diagonal patterns for AI (same logic as user but for player 2)
  // ... (similar diagonal checks but for player 2)
  
  return -1; // No AI 3-in-a-row found to complete
}

// SAFETY CHECK: Does AI making this move gift the opponent an immediate win?
bool doesMoveGiftOpponentWin(List<List<int>> board, int aiColumn) {
  if (!canDrop(board, aiColumn)) return true; // Can't make move = unsafe
  
  // Simulate AI making the move
  List<List<int>> afterAIMove = cloneBoard(board);
  drop(afterAIMove, aiColumn, 2);
  
  print('🔍 DETAILED Safety check: AI considering column $aiColumn');
  print('Board after AI move:');
  for (int r = 0; r < rows; r++) {
    print('   ${afterAIMove[r]}');
  }
  
  // Now check if opponent (player 1) can win immediately on their next turn
  for (int c = 0; c < cols; c++) {
    if (canDrop(afterAIMove, c)) {
      List<List<int>> afterOpponentMove = cloneBoard(afterAIMove);
      drop(afterOpponentMove, c, 1);
      
      print('   Testing user response in column $c...');
      if (checkWin(afterOpponentMove, 1)) {
        print('💀 CRITICAL DANGER: If AI plays $aiColumn, user wins immediately with column $c!');
        print('Winning board would be:');
        for (int r = 0; r < rows; r++) {
          print('      ${afterOpponentMove[r]}');
        }
        return true; // This move gifts opponent a win!
      }
    }
  }
  
  print('✅ Safe: AI move in column $aiColumn does not gift user a win');
  return false; // Move is safe
}

// Simple and direct threat detection - check if opponent placing here creates 3+ in a row
bool wouldCreateThreat(List<List<int>> board, int col, int player) {
  if (!canDrop(board, col)) return false;
  
  // Simulate opponent placing a piece in this column
  List<List<int>> testBoard = cloneBoard(board);
  drop(testBoard, col, player);
  
  // Find where the piece landed
  int landingRow = -1;
  for (int r = 0; r < rows; r++) {
    if (testBoard[r][col] == player && board[r][col] == 0) {
      landingRow = r;
      break;
    }
  }
  
  if (landingRow == -1) return false;
  
  // Check all 4 directions for 3+ consecutive pieces
  
  // Horizontal check
  int horizontal = 1; // Count the piece we just placed
  // Count left
  for (int c = col - 1; c >= 0 && testBoard[landingRow][c] == player; c--) {
    horizontal++;
  }
  // Count right  
  for (int c = col + 1; c < cols && testBoard[landingRow][c] == player; c++) {
    horizontal++;
  }
  if (horizontal >= 3) return true;
  
  // Vertical check
  int vertical = 1; // Count the piece we just placed
  // Count down (up doesn't matter since piece falls down)
  for (int r = landingRow + 1; r < rows && testBoard[r][col] == player; r++) {
    vertical++;
  }
  if (vertical >= 3) return true;
  
  // Diagonal \ check
  int diag1 = 1; // Count the piece we just placed
  // Count down-left
  for (int i = 1; landingRow + i < rows && col - i >= 0 && testBoard[landingRow + i][col - i] == player; i++) {
    diag1++;
  }
  // Count up-right
  for (int i = 1; landingRow - i >= 0 && col + i < cols && testBoard[landingRow - i][col + i] == player; i++) {
    diag1++;
  }
  if (diag1 >= 3) return true;
  
  // Diagonal / check
  int diag2 = 1; // Count the piece we just placed
  // Count down-right
  for (int i = 1; landingRow + i < rows && col + i < cols && testBoard[landingRow + i][col + i] == player; i++) {
    diag2++;
  }
  // Count up-left
  for (int i = 1; landingRow - i >= 0 && col - i >= 0 && testBoard[landingRow - i][col - i] == player; i++) {
    diag2++;
  }
  if (diag2 >= 3) return true;
  
  return false;
}

// Keep original vertical function for backward compatibility
bool hasVerticalThreat(List<List<int>> board, int col, int player) {
  if (!canDrop(board, col)) return false;
  
  // Find where the piece would land
  int landingRow = -1;
  for (int r = rows - 1; r >= 0; r--) {
    if (board[r][col] == 0) {
      landingRow = r;
      break;
    }
  }
  
  if (landingRow == -1) return false;
  
  // Check if there are 3 consecutive pieces below the landing position
  int consecutiveCount = 0;
  for (int r = landingRow + 1; r < rows; r++) {
    if (board[r][col] == player) {
      consecutiveCount++;
    } else {
      break;
    }
  }
  
  return consecutiveCount >= 3;
}

// Enhanced threat detection for all directions
bool hasThreatsToBlock(List<List<int>> board, int col, int player) {
  if (!canDrop(board, col)) return false;
  
  // Find where the piece would land
  int landingRow = -1;
  for (int r = rows - 1; r >= 0; r--) {
    if (board[r][col] == 0) {
      landingRow = r;
      break;
    }
  }
  
  if (landingRow == -1) return false;
  
  // Check vertical threat (most critical)
  if (hasVerticalThreat(board, col, player)) return true;
  
  // Check horizontal threats
  int consecutiveLeft = 0;
  for (int c = col - 1; c >= 0; c--) {
    if (board[landingRow][c] == player) {
      consecutiveLeft++;
    } else {
      break;
    }
  }
  
  int consecutiveRight = 0;
  for (int c = col + 1; c < cols; c++) {
    if (board[landingRow][c] == player) {
      consecutiveRight++;
    } else {
      break;
    }
  }
  
  // If placing here would complete or enable a 4-in-a-row horizontally
  if (consecutiveLeft + consecutiveRight >= 3) return true;
  
  return false;
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

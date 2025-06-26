const int rows = 6;
const int cols = 7;

int getAIMove(List<List<int>> board) {
  // 1. Try to win
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 2);
      if (checkWin(copy, 2)) return c;
    }
  }

  // 2. Try to block player
  for (int c = 0; c < cols; c++) {
    if (canDrop(board, c)) {
      List<List<int>> copy = cloneBoard(board);
      drop(copy, c, 1);
      if (checkWin(copy, 1)) return c;
    }
  }

  // 3. Prefer center
  List<int> centerPreference = [3, 2, 4, 1, 5, 0, 6];
  for (int c in centerPreference) {
    if (canDrop(board, c)) return c;
  }

  return -1; // no move possible
}

bool canDrop(List<List<int>> board, int col) {
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

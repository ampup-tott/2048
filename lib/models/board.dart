import 'dart:math' show Random;
import 'package:app2048/models/tile.dart';

class Board {
  final int row;
  final int column;
  int score;
  bool canBack;

  Board(this.row, this.column);

  List<List<Tile>> _boardTiles;
  List<List<Tile>> _boardTilesPrev;

  void initBoard() {
    _boardTiles = List.generate(
      row,
      (r) => List.generate(
        column,
        (c) => Tile(
          row: r,
          column: c,
          value: 0,
          isNew: false,
          canMerge: false,
          isMerged: false,
          oldValue: 0
        ),
      ),
    );

    _boardTilesPrev = List.generate(
      row,
      (r) => List.generate(
        column,
        (c) => Tile(
          row: r,
          column: c,
          value: 0,
          isNew: false,
          canMerge: false,
          isMerged: false,
          oldValue: 0
        ),
      ),
    );

    score = 0;
    canBack = false;
    resetCanMerge();
    randomEmptyTile();
    randomEmptyTile();
  }

  void moveLeft() {
    if (!canMoveLeft()) {
      return;
    }

    backupboardTiles();

    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        mergeLeft(r, c);
      }
    }
    
    randomEmptyTile();
    resetCanMerge();
  }

  void moveRight() {
    if (!canMoveRight()) {
      return;
    }

    backupboardTiles();

    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        mergeRight(r, c);
      }
    }

    randomEmptyTile();
    resetCanMerge();
  }

  void moveUp() {
    if (!canMoveUp()) {
      return;
    }

    backupboardTiles();

    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        mergeUp(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

  void moveDown() {
    if (!canMoveDown()) {
      return;
    }

    backupboardTiles();

    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        mergeDown(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

  bool canMoveLeft() {
    for (int r = 0; r < row; ++r) {
      for (int c = 1; c < column; ++c) {
        if (canMerge(_boardTiles[r][c], _boardTiles[r][c - 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        if (canMerge(_boardTiles[r][c], _boardTiles[r][c + 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int r = 1; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(_boardTiles[r][c], _boardTiles[r - 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveDown() {
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(_boardTiles[r][c], _boardTiles[r + 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  void mergeLeft(int row, int col) {
    while (col > 0) {
      merge(_boardTiles[row][col], _boardTiles[row][col - 1]);
      col--;
    }
  }

  void mergeRight(int row, int col) {
    while (col < column - 1) {
      merge(_boardTiles[row][col], _boardTiles[row][col + 1]);
      col++;
    }
  }

  void mergeUp(int r, int col) {
    while (r > 0) {
      merge(_boardTiles[r][col], _boardTiles[r - 1][col]);
      r--;
    }
  }

  void mergeDown(int r, int col) {
    while (r < row - 1) {
      merge(_boardTiles[r][col], _boardTiles[r + 1][col]);
      r++;
    }
  }

  bool canMerge(Tile a, Tile b) {
    return !a.canMerge &&
        ((b.isEmpty() && !a.isEmpty()) || (!a.isEmpty() && a == b));
  }

  void merge(Tile a, Tile b) {
    if (!canMerge(a, b)) {
      if (!a.isEmpty() && !b.canMerge) {
        b.canMerge = true;
      }
      return;
    }

    if (b.isEmpty()) {
      b.value = a.value;
      a.oldValue = a.value;
      a.value = 0;
    } else if (a == b) {
      b.value = b.value * 2;
      a.oldValue = a.value;
      a.value = 0;
      score += b.value;
      b.canMerge = true;
      b.isMerged = true;
    } else {
      b.canMerge = true;
    }
  }

  bool gameOver() {
    bool gameOver = !canMoveLeft() && !canMoveRight() && !canMoveUp() && !canMoveDown();
    if (gameOver) {
      canBack = false;
    }
    return gameOver;
  }

  Tile getTile(int row, int column) {
    return _boardTiles[row][column];
  }

  void randomEmptyTile() {
    List<Tile> empty = List<Tile>();

    _boardTiles.forEach((rows) {
      empty.addAll(rows.where((tile) => tile.isEmpty()));
    });

    if (empty.isEmpty) {
      return;
    }

    Random rng = Random();

    int index = rng.nextInt(empty.length);
    empty[index].value = rng.nextInt(9) == 0 ? 4 : 2;
    empty[index].isNew = true;
    empty.removeAt(index);
  }

  void resetCanMerge() {
    _boardTiles.forEach((rows) {
      rows.forEach((tile) {
        tile.canMerge = false;
      });
    });
  }

  void backupboardTiles() {
    print('backup');
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _boardTilesPrev[r][c].canMerge = _boardTiles[r][c].canMerge;
        _boardTilesPrev[r][c].isNew = _boardTiles[r][c].isNew;
        _boardTilesPrev[r][c].value = _boardTiles[r][c].value;
        _boardTilesPrev[r][c].row = _boardTiles[r][c].row;
        _boardTilesPrev[r][c].column = _boardTiles[r][c].column;
      }
    }
    canBack = true;
    return;
  }

  void back() {
    if (!canBack) {
      return;
    }
     print('back');
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _boardTiles[r][c].canMerge = _boardTilesPrev[r][c].canMerge;
        _boardTiles[r][c].isNew = _boardTilesPrev[r][c].isNew;
        _boardTiles[r][c].value = _boardTilesPrev[r][c].value;
        _boardTiles[r][c].row = _boardTilesPrev[r][c].row;
        _boardTiles[r][c].column = _boardTilesPrev[r][c].column;
      }
    }
    canBack = false;
  }
}
import 'package:flutter/material.dart';

import 'package:app2048/widgets/game.dart';
import 'package:app2048/models/board.dart';
import 'package:app2048/widgets/tile.dart';
import 'package:app2048/colors.dart';

class BoardWidget extends StatefulWidget {
  @override
  BoardWidgetState createState() => BoardWidgetState();
}

class BoardWidgetState extends State<BoardWidget> {
  Board _board;
  int row;
  int column;
  bool _isMoving;
  bool gameOver;
  double tilePadding = 5.0;
  MediaQueryData _queryData;

  @override
  void initState() {
    super.initState();

    row = 4;
    column = 4;
    _isMoving = false;
    gameOver = false;

    _board = Board(row, column);
    newGame();
  }

  void newGame() {
    setState(() {
      _board.initBoard();
      gameOver = false;
    });
  }

  void gameover() {
    setState(() {
      if (_board.gameOver()) {
        gameOver = true;
      }
    });
  }

  Size boardSize() {
    Size size = _queryData.size;
    return Size(size.width - 40, size.width - 40);
  }

  @override
  Widget build(BuildContext context) {
    _queryData = MediaQuery.of(context);
    List<TileWidget> _tileWidgets = List<TileWidget>();
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _tileWidgets.add(TileWidget(tile: _board.getTile(r, c), state: this));
      }
    }
    List<Widget> children = List<Widget>();

    children.add(GameWidget(state: this));
    children.addAll(_tileWidgets);

    return Scaffold(
        body: GestureDetector(
      onVerticalDragUpdate: (detail) {
        if (detail.delta.distance == 0 || _isMoving) {
          return;
        }
        _isMoving = true;
        if (detail.delta.direction > 0) {
          setState(() {
            _board.moveDown();
            gameover();
          });
        } else {
          setState(() {
            _board.moveUp();
            gameover();
          });
        }
      },
      onVerticalDragEnd: (d) {
        _isMoving = false;
      },
      onVerticalDragCancel: () {
        _isMoving = false;
      },
      onHorizontalDragUpdate: (d) {
        if (d.delta.distance == 0 || _isMoving) {
          return;
        }
        _isMoving = true;
        if (d.delta.direction > 0) {
          setState(() {
            _board.moveLeft();
            gameover();
          });
        } else {
          setState(() {
            _board.moveRight();
            gameover();
          });
        }
      },
      onHorizontalDragEnd: (d) {
        _isMoving = false;
      },
      onHorizontalDragCancel: () {
        _isMoving = false;
      },
      child: Container(
          width: _queryData.size.width,
          height: _queryData.size.height,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Container(
                        width: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(gridBackground),
                        ),
                        height: 80.0,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                              child: Text(
                                'Score',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                '${_board.score}',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Container(
                          width: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(gridBackground),
                          ),
                          height: 80.0,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: IconButton(
                                iconSize: 50.0,
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  newGame();
                                },
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 40.0,
                  child: Opacity(
                    opacity: gameOver ? 1.0 : 0.0,
                    child: Center(
                      child: Text('Game Over'),
                    ),
                  )),
              Container(
                  width: _queryData.size.width,
                  height: _queryData.size.width,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Stack(
                      children: children,
                    ),
                  ))
            ],
          )),
    ));
  }
}

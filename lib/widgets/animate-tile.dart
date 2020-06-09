import 'package:app2048/contants.dart';
import 'package:flutter/material.dart';
import 'package:app2048/models/tile.dart';
import 'package:app2048/screens/board.dart';
import 'package:app2048/colors.dart';

class AnimatedTileWidget extends AnimatedWidget {
  final Tile tile;
  final BoardWidgetState state;

  AnimatedTileWidget({
    Key key,
    this.tile,
    this.state,
    Animation<double> animation,
  }) : super(
          key: key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.tilePadding) /
        state.column;

    return TileBox(
      left: (tile.column * width + state.tilePadding * (tile.column + 1)) +
          width / 2 * (1 - animationValue),
      top: tile.row * width +
          state.tilePadding * (tile.row + 1) +
          width / 2 * (1 - animationValue),
      size: width * animationValue,
      color: tileColors.containsKey(tile.value)
          ? Color(tileColors[tile.value])
          : Color(emptyGridBackground),
      text: Text('${tile.value > 0 ? tile.value : ""}',
          style: TextStyle(
              fontSize: getFontSize(tile.value),
              fontWeight: FontWeight.bold,
              color: tile.value > 4
                  ? Color(fontColorOther)
                  : Color(fontColorTwoFour))),
    );
  }
}

class TileBox extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final Text text;

  const TileBox({
    Key key,
    this.left,
    this.top,
    this.size,
    this.color,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Center(
          child: text,
        ),
      ),
    );
  }
}

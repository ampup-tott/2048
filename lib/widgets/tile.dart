import 'package:flutter/material.dart';

import 'package:app2048/models/tile.dart';
import 'package:app2048/widgets/animate-tile.dart';
import 'package:app2048/screens/board.dart';

class TileWidget extends StatefulWidget {
  final Tile tile;
  final BoardWidgetState state;

  const TileWidget({Key key, this.tile, this.state})
      : super(key: key);
  @override
  _TileWidgetState createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticIn,
    ));

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    widget.tile.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tile.oldValue > 0) {
      controller.fling(velocity: 0.3);
      widget.tile.oldValue = 0;
    } else if (widget.tile.isMerged) {
      controller.reset();
      controller.forward();
      widget.tile.isMerged = false;
    } else if (widget.tile.isNew && !widget.tile.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.tile.isNew = false;
    } else {
      controller.forward();
      controller.animateTo(1.0);
    }

    // return AnimatedTileWidget(
    //   tile: widget.tile,
    //   state: widget.state,
    //   animation: animation,
    // );

    return SlideTransition(
      position: offsetAnimation,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FlutterLogo(size: 150.0),
      ),
    );
  }
}

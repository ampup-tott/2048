import 'package:flutter/material.dart';

class Routes {
  static void goToHomeScreen(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }

  static void goToGame(BuildContext context) {
    Navigator.pushNamed(context, '/game');
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
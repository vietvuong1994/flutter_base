import 'package:flutter/material.dart';

class MusicPlayerModel extends ChangeNotifier {
  AnimationController animController;
  bool isSmallPlayerShow = false;

  void initSmallPlayer(TickerProvider ticker) {
    animController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: ticker,
    );
  }

  void showSmallPlayer() {
    animController.forward();
    isSmallPlayerShow = true;
    notifyListeners();
  }

  void hideSmallplayer() {
    if (isSmallPlayerShow) {
      isSmallPlayerShow = false;
      animController.reverse();
      notifyListeners();
    }
  }

}

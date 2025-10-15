import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:penuhan/game/game.dart'; // Your game class

class GamePlay extends StatefulWidget {
  const GamePlay({super.key});

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  late final PenuhanGame _penuhanGame;

  @override
  void initState() {
    super.initState();
    _penuhanGame = PenuhanGame();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _penuhanGame);
  }
}

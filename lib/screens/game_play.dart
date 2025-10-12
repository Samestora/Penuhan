import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:penuhan/game/game.dart';

PenuhanGame _penuhanGame = PenuhanGame();

class GamePlay extends StatelessWidget {
  const GamePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget (
      game: _penuhanGame,
    );
  }
}
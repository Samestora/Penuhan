import 'package:flame/components.dart';
import 'package:penuhan/game/player.dart';

class Level extends World {
  @override
  Future<void> onLoad() async {
    add(Player(position: Vector2(0, 0)));
  }
}
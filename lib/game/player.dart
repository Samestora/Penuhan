import 'package:flame/components.dart';
import 'package:penuhan/utils/asset_manager.dart';

class Player extends SpriteComponent {
  Player({super.position})
    : super(size: Vector2(200, 200), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(AssetManager.playerSprite);
  }
}

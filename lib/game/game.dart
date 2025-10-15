import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:penuhan/game/player.dart';
import 'package:penuhan/utils/assets.dart';

class PenuhanGame extends FlameGame {
  PenuhanGame() {
    pauseWhenBackgrounded = false;
  }

  @override
  void onRemove() {
    FlameAudio.audioCache.clear(Assets.bgmTitle);

    // Always call the super method.
    super.onRemove();
  }

  @override
  FutureOr<void> onLoad() async {
    Player player = Player();
    add(player);
    return super.onLoad();
  }
}

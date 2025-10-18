import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:penuhan/utils/asset_manager.dart';

class PenuhanGame extends FlameGame {
  PenuhanGame() {
    pauseWhenBackgrounded = false;
  }

  @override
  FutureOr<void> onLoad() async {
    FlameAudio.bgm.stop();
    FlameAudio.audioCache.clear(AssetManager.bgmTitle);
    // FlameAudio.bgm.play(AssetManager.bgmGameplay, volume: 0.8);
  }

  @override
  void onRemove() {
    FlameAudio.audioCache.clearAll();

    super.onRemove();
  }
}

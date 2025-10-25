import 'dart:async';

import 'package:flame/game.dart';
import 'package:penuhan/utils/audio_manager.dart';

class PenuhanGame extends FlameGame {
  late final AudioManager _audioManager;

  PenuhanGame() {
    pauseWhenBackgrounded = false;
  }

  @override
  FutureOr<void> onLoad() async {
    _audioManager.stopBgm();
  }
}

import 'dart:async';

import 'package:flame/game.dart';
import 'package:penuhan/utils/audio_manager.dart';
import 'package:penuhan/models/dungeon.dart';

class PenuhanGame extends FlameGame {
  final AudioManager _audioManager;
  final Dungeon dungeon;

  PenuhanGame({required this.dungeon, required AudioManager audioManager})
      : _audioManager = audioManager {
    pauseWhenBackgrounded = false;
  }

  @override
  FutureOr<void> onLoad() async {
    _audioManager.stopBgm();
    print('Entering dungeon: ${dungeon.name}');
  }
}

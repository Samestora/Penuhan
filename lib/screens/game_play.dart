import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:penuhan/game/game.dart';
import 'package:penuhan/utils/audio_manager.dart';

class GamePlay extends StatefulWidget {
  const GamePlay({super.key});

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> with WidgetsBindingObserver {
  late final PenuhanGame _penuhanGame;

  @override
  void initState() {
    super.initState();
    _penuhanGame = PenuhanGame();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      AudioManager.instance.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      AudioManager.instance.onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _penuhanGame);
  }
}

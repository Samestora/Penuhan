import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:penuhan/game/game.dart';
import 'package:penuhan/utils/audio_manager.dart';
import 'package:penuhan/widgets/tap_circle_indicator.dart';
import 'package:provider/provider.dart';

class GamePlay extends StatefulWidget {
  const GamePlay({super.key});

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> with WidgetsBindingObserver {
  late final PenuhanGame _penuhanGame;
  late final AudioManager _audioManager;

  @override
  void initState() {
    super.initState();
    _penuhanGame = PenuhanGame();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioManager = context.read<AudioManager>();
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
      _audioManager.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      _audioManager.onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TapCircleIndicator(child: GameWidget(game: _penuhanGame));
  }
}

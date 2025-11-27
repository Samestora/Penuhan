import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:penuhan/features/exploration/game/penuhan_game.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:provider/provider.dart';

import 'package:penuhan/core/models/dungeon.dart';

class GamePlay extends StatefulWidget {
  final Dungeon dungeon;

  const GamePlay({super.key, required this.dungeon});

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> with WidgetsBindingObserver {
  PenuhanGame? _penuhanGame;
  late final AudioManager _audioManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_penuhanGame == null) {
      _audioManager = context.read<AudioManager>();
      _penuhanGame = PenuhanGame(
        dungeon: widget.dungeon,
        audioManager: _audioManager,
      );
    }
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
    if (_penuhanGame == null) {
      // This can happen while the game is being initialized.
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return GameWidget(game: _penuhanGame!);
  }
}

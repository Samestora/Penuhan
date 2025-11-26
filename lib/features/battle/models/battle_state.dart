import 'package:penuhan/features/battle/models/battle_character.dart';

enum BattleAction { attack, skill, win }

enum BattlePhase { playerTurn, enemyTurn, victory, defeat }

class BattleState {
  final BattleCharacter player;
  final BattleCharacter enemy;
  BattlePhase phase;
  String battleLog;

  BattleState({
    required this.player,
    required this.enemy,
    this.phase = BattlePhase.playerTurn,
    this.battleLog = '',
  });

  bool get isBattleOver =>
      phase == BattlePhase.victory || phase == BattlePhase.defeat;
}

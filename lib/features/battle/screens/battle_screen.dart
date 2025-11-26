import 'package:flutter/material.dart';
import 'package:penuhan/features/battle/models/battle_character.dart';
import 'package:penuhan/features/battle/models/battle_state.dart';
import 'package:penuhan/features/battle/models/skill.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/game_progress.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/features/app/screens/resting_screen.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class BattleScreen extends StatefulWidget {
  final Dungeon dungeon;
  final GameProgress? gameProgress;

  const BattleScreen({super.key, required this.dungeon, this.gameProgress});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen>
    with SingleTickerProviderStateMixin {
  late BattleState _battleState;
  late AudioManager _audioManager;
  late AnimationController _shakeController;
  bool _isPlayerHit = false;
  bool _isEnemyHit = false;
  bool _showSkillList = false;
  Skill? _selectedSkill;

  @override
  void initState() {
    super.initState();
    _initBattle();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioManager = context.read<AudioManager>();
  }

  void _initBattle() {
    // Initialize player stats from GameProgress or default
    final progress = widget.gameProgress;
    final player = BattleCharacter(
      name: 'Nama Musun',
      currentHp: progress?.playerHp ?? 150,
      maxHp: progress?.playerMaxHp ?? 150,
      currentXp: progress?.playerXp ?? 150,
      maxXp: progress?.playerMaxXp ?? 150,
      attack: progress?.playerAttack ?? 10,
      skill: progress?.playerSkill ?? 10,
    );

    // Initialize enemy based on dungeon difficulty
    final enemy = BattleCharacter(
      name: _getEnemyName(),
      currentHp: _getEnemyHp(),
      maxHp: _getEnemyHp(),
      currentXp: 0,
      maxXp: 100,
      attack: _getEnemyAttack(),
      skill: _getEnemySkill(),
    );

    _battleState = BattleState(
      player: player,
      enemy: enemy,
      battleLog: 'Battle Start!',
    );
  }

  String _getEnemyName() {
    switch (widget.dungeon) {
      case Dungeon.sunkenCitadel:
        return 'Goblin';
      case Dungeon.whisperingCrypt:
        return 'Skeleton';
      case Dungeon.dragonsMaw:
        return 'Dragon';
    }
  }

  int _getEnemyHp() {
    switch (widget.dungeon.difficulty) {
      case DungeonDifficulty.easy:
        return 100;
      case DungeonDifficulty.normal:
        return 150;
      case DungeonDifficulty.hard:
        return 200;
    }
  }

  int _getEnemyAttack() {
    switch (widget.dungeon.difficulty) {
      case DungeonDifficulty.easy:
        return 8;
      case DungeonDifficulty.normal:
        return 12;
      case DungeonDifficulty.hard:
        return 18;
    }
  }

  int _getEnemySkill() {
    switch (widget.dungeon.difficulty) {
      case DungeonDifficulty.easy:
        return 5;
      case DungeonDifficulty.normal:
        return 10;
      case DungeonDifficulty.hard:
        return 15;
    }
  }

  void _performAction(BattleAction action) {
    if (_battleState.isBattleOver) return;

    setState(() {
      String log = '';
      int damage = 0;

      // Player's turn
      switch (action) {
        case BattleAction.attack:
          damage = _battleState.player.attack + Random().nextInt(5);
          _battleState.enemy.takeDamage(damage);
          log = AppLocalizations.of(
            context,
          )!.battlePlayerAttacks(_battleState.player.name, damage);
          _isEnemyHit = true;
          _audioManager.playSfx(AssetManager.sfxClick);
          break;
        case BattleAction.skill:
          // Show skill list UI
          _showSkillList = true;
          _selectedSkill = null;
          _audioManager.playSfx(AssetManager.sfxClick);
          return; // Don't process turn yet
        case BattleAction.win:
          log = AppLocalizations.of(context)!.battleSurrendered;
          _battleState.phase = BattlePhase.defeat;
          break;
      }

      // Check if enemy is defeated
      if (!_battleState.enemy.isAlive) {
        _battleState.phase = BattlePhase.victory;
        log = AppLocalizations.of(
          context,
        )!.battleVictoryMessage(_battleState.enemy.name);
        _battleState.player.gainXp(50);
      } else {
        // Enemy's turn
        _battleState.phase = BattlePhase.enemyTurn;

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _isEnemyHit = false;
              int enemyDamage = _battleState.enemy.attack + Random().nextInt(5);
              _battleState.player.takeDamage(enemyDamage);
              log = AppLocalizations.of(
                context,
              )!.battleEnemyAttacks(_battleState.enemy.name, enemyDamage);
              _isPlayerHit = true;
              _shakeController.forward(from: 0);
              _audioManager.playSfx(AssetManager.sfxClick);

              // Check if player is defeated
              if (!_battleState.player.isAlive) {
                _battleState.phase = BattlePhase.defeat;
                log = AppLocalizations.of(context)!.battleDefeatMessage;
              } else {
                _battleState.phase = BattlePhase.playerTurn;
              }

              _battleState.battleLog = log;

              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) {
                  setState(() {
                    _isPlayerHit = false;
                  });
                }
              });
            });
          }
        });
      }

      _battleState.battleLog = log;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isEnemyHit = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // LAYER 1: Background (solid black)
            Container(color: Colors.black),

            // LAYER 2: Sprites (characters in battle area)
            _buildSpritesLayer(screenHeight, screenWidth),

            // LAYER 3: UI (buttons, info bars, overlays)
            _buildUILayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpritesLayer(double screenHeight, double screenWidth) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Player character (bottom)
          Positioned(
            bottom: screenHeight * 0.25,
            left: screenWidth * 0.25,
            child: AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                final shake = _isPlayerHit
                    ? sin(_shakeController.value * pi * 4) * 10
                    : 0.0;
                return Transform.translate(
                  offset: Offset(shake, 0),
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _isPlayerHit
                      ? Colors.red.withOpacity(0.3)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: _buildStickFigure(size: 80, isPlayer: true),
              ),
            ),
          ),

          // Enemy character (top)
          Positioned(
            top: screenHeight * 0.15,
            right: screenWidth * 0.25,
            child: Container(
              decoration: BoxDecoration(
                color: _isEnemyHit
                    ? Colors.red.withOpacity(0.3)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: _buildStickFigure(size: 80, isPlayer: false),
            ),
          ),

          // Battle log in center
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                _battleState.battleLog,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Unifont',
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUILayer() {
    return Stack(
      children: [
        // Base UI layout
        Column(
          children: [
            // Top bar with back button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      _audioManager.playSfx(AssetManager.sfxClick);
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    widget.dungeon.name.toString().split('.').last,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Unifont',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Player info at top
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: _buildCharacterInfo(
                _battleState.player,
                isPlayer: true,
                isHit: _isPlayerHit,
                previewDamage: null,
                previewHeal:
                    _selectedSkill != null &&
                        _selectedSkill!.effect == SkillEffect.heal
                    ? 30
                    : null,
              ),
            ),

            // Spacer for battle area (sprites are on layer 2)
            const Spacer(),

            // Enemy info at bottom center (above action buttons)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8,
              ),
              child: _buildCharacterInfo(
                _battleState.enemy,
                isPlayer: false,
                isHit: _isEnemyHit,
                previewDamage:
                    _selectedSkill != null &&
                        _selectedSkill!.effect != SkillEffect.heal
                    ? _selectedSkill!.calculateDamage(_battleState.player.skill)
                    : null,
                previewHeal: null,
              ),
            ),

            // Action buttons or skill detail (when skill selected)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: _selectedSkill != null
                  ? _buildSkillDetail()
                  : _buildActionButtons(),
            ),
          ],
        ),

        // Skill list overlay (only when showing list, not detail)
        if (_showSkillList && _selectedSkill == null)
          Container(
            color: Colors.black87,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 60,
                ),
                constraints: const BoxConstraints(maxHeight: 500),
                child: _buildSkillList(),
              ),
            ),
          ),

        // Victory/Defeat overlay
        if (_battleState.isBattleOver) _buildBattleEndOverlay(),
      ],
    );
  }

  Widget _buildCharacterInfo(
    BattleCharacter character, {
    required bool isPlayer,
    required bool isHit,
    int? previewDamage,
    int? previewHeal,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: isHit ? Colors.red : Colors.white, width: 2),
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and HP
          Row(
            children: [
              Expanded(
                child: Text(
                  character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Unifont',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${character.currentHp}/${character.maxHp}',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Unifont',
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // HP Bar (with preview damage or heal if applicable)
          previewDamage != null
              ? _buildStatBarWithPreview(
                  'HP',
                  character.currentHp,
                  character.maxHp,
                  previewDamage,
                  Colors.red,
                )
              : previewHeal != null
              ? _buildStatBarWithHealPreview(
                  'HP',
                  character.currentHp,
                  character.maxHp,
                  previewHeal,
                  Colors.red,
                )
              : _buildStatBar('HP', character.hpPercentage, Colors.red),

          // XP Bar (only for player)
          if (isPlayer) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'XP: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Unifont',
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${character.currentXp}/${character.maxXp}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Unifont',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Unifont',
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: percentage.clamp(0.0, 1.0),
                      child: Container(color: color),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatBarWithPreview(
    String label,
    int currentHp,
    int maxHp,
    int previewDamage,
    Color color,
  ) {
    final currentPercentage = currentHp / maxHp;
    final afterDamageHp = (currentHp - previewDamage).clamp(0, maxHp);
    final afterDamagePercentage = afterDamageHp / maxHp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Unifont',
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // HP after damage (full color)
                        Container(
                          width:
                              constraints.maxWidth *
                              afterDamagePercentage.clamp(0.0, 1.0),
                          color: color,
                        ),
                        // Damage preview area (darker overlay)
                        if (afterDamagePercentage < currentPercentage)
                          Positioned(
                            left:
                                constraints.maxWidth *
                                afterDamagePercentage.clamp(0.0, 1.0),
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width:
                                  constraints.maxWidth *
                                  (currentPercentage - afterDamagePercentage)
                                      .clamp(0.0, 1.0),
                              color: color.withValues(alpha: 0.3),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        // Preview HP text
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Text(
                  'Preview: $afterDamageHp/$maxHp (-$previewDamage)',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'Unifont',
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBarWithHealPreview(
    String label,
    int currentHp,
    int maxHp,
    int previewHeal,
    Color color,
  ) {
    final currentPercentage = currentHp / maxHp;
    final afterHealHp = (currentHp + previewHeal).clamp(0, maxHp);
    final afterHealPercentage = afterHealHp / maxHp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Unifont',
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Current HP (full color)
                        Container(
                          width:
                              constraints.maxWidth *
                              currentPercentage.clamp(0.0, 1.0),
                          color: color,
                        ),
                        // Heal preview area (green overlay showing additional HP)
                        if (afterHealPercentage > currentPercentage)
                          Positioned(
                            left:
                                constraints.maxWidth *
                                currentPercentage.clamp(0.0, 1.0),
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width:
                                  constraints.maxWidth *
                                  (afterHealPercentage - currentPercentage)
                                      .clamp(0.0, 1.0),
                              color: Colors.green.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        // Preview HP text
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Text(
                  'Preview: $afterHealHp/$maxHp (+$previewHeal)',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontFamily: 'Unifont',
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final bool canAct =
        _battleState.phase == BattlePhase.playerTurn &&
        !_battleState.isBattleOver;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          'Attack',
          canAct,
          () => _performAction(BattleAction.attack),
        ),
        _buildActionButton(
          'Skill',
          canAct,
          () => _performAction(BattleAction.skill),
        ),
        _buildActionButton(
          'Win',
          canAct,
          () => _performAction(BattleAction.win),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    bool enabled,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey,
            disabledForegroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Unifont',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SELECT SKILL',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Unifont',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: Skill.allSkills.length,
              itemBuilder: (context, index) {
                final skill = Skill.allSkills[index];
                final l10n = AppLocalizations.of(context)!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      _audioManager.playSfx(AssetManager.sfxClick);
                      setState(() {
                        _selectedSkill = skill;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill.getLocalizedName(context),
                          style: const TextStyle(
                            fontFamily: 'Unifont',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.skillCost(skill.skillCost),
                          style: const TextStyle(
                            fontFamily: 'Unifont',
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return ElevatedButton(
                onPressed: () {
                  _audioManager.playSfx(AssetManager.sfxClick);
                  setState(() {
                    _showSkillList = false;
                    _selectedSkill = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                child: Text(
                  l10n.skillCancel,
                  style: const TextStyle(
                    fontFamily: 'Unifont',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillDetail() {
    final l10n = AppLocalizations.of(context)!;
    final skill = _selectedSkill!;
    final playerSkillStat = _battleState.player.skill;
    final estimatedDamage = skill.calculateDamage(playerSkillStat);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            skill.getLocalizedName(context).toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Unifont',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Text(
              skill.getLocalizedDescription(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Unifont',
                fontSize: 14,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatInfo('Cost', '${skill.skillCost} SP'),
              if (skill.effect != SkillEffect.heal)
                _buildStatInfo('Damage', '~$estimatedDamage')
              else
                _buildStatInfo('Heal', '30 HP'),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _audioManager.playSfx(AssetManager.sfxClick);
                    setState(() {
                      _selectedSkill = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    l10n.skillCancel,
                    style: const TextStyle(
                      fontFamily: 'Unifont',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _useSkill(skill);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    l10n.skillAttack,
                    style: const TextStyle(
                      fontFamily: 'Unifont',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Unifont',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Unifont',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _useSkill(Skill skill) {
    _audioManager.playSfx(AssetManager.sfxClick);

    setState(() {
      String log = '';

      if (skill.effect == SkillEffect.heal) {
        // Healing skill
        final healAmount = 30;
        final oldHp = _battleState.player.currentHp;
        _battleState.player.heal(healAmount);
        final actualHeal = _battleState.player.currentHp - oldHp;
        log = AppLocalizations.of(
          context,
        )!.battlePlayerHeals(_battleState.player.name, actualHeal);
      } else {
        // Damage skill
        final damage = skill.calculateDamage(_battleState.player.skill);
        _battleState.enemy.takeDamage(damage);
        log = AppLocalizations.of(context)!.battlePlayerUsesSkill(
          _battleState.player.name,
          skill.getLocalizedName(context),
          damage,
        );
        _isEnemyHit = true;
      }

      // Reset skill UI
      _showSkillList = false;
      _selectedSkill = null;

      // Check if enemy is defeated
      if (!_battleState.enemy.isAlive) {
        _battleState.phase = BattlePhase.victory;
        log = AppLocalizations.of(
          context,
        )!.battleVictoryMessage(_battleState.enemy.name);
        _battleState.player.gainXp(50);
      } else {
        // Enemy's turn
        _battleState.phase = BattlePhase.enemyTurn;

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _isEnemyHit = false;
              int enemyDamage = _battleState.enemy.attack + Random().nextInt(5);
              _battleState.player.takeDamage(enemyDamage);
              String enemyLog = AppLocalizations.of(
                context,
              )!.battleEnemyAttacks(_battleState.enemy.name, enemyDamage);
              _isPlayerHit = true;
              _shakeController.forward(from: 0);
              _audioManager.playSfx(AssetManager.sfxClick);

              // Check if player is defeated
              if (!_battleState.player.isAlive) {
                _battleState.phase = BattlePhase.defeat;
                enemyLog = AppLocalizations.of(context)!.battleDefeatMessage;
              } else {
                _battleState.phase = BattlePhase.playerTurn;
              }

              _battleState.battleLog = enemyLog;

              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) {
                  setState(() {
                    _isPlayerHit = false;
                  });
                }
              });
            });
          }
        });
      }

      _battleState.battleLog = log;

      if (_isEnemyHit) {
        _shakeController.forward(from: 0).then((_) {
          if (mounted) {
            setState(() => _isEnemyHit = false);
          }
        });
      }
    });
  }

  Widget _buildStickFigure({required double size, required bool isPlayer}) {
    return CustomPaint(
      size: Size(size, size),
      painter: StickFigurePainter(isPlayer: isPlayer),
    );
  }

  Widget _buildBattleEndOverlay() {
    final bool isVictory = _battleState.phase == BattlePhase.victory;

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: isVictory ? Colors.green : Colors.red,
              width: 4,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isVictory
                    ? AppLocalizations.of(context)!.battleVictory
                    : AppLocalizations.of(context)!.battleDefeat,
                style: TextStyle(
                  color: isVictory ? Colors.green : Colors.red,
                  fontFamily: 'Unifont',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _battleState.battleLog,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Unifont',
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _audioManager.playSfx(AssetManager.sfxClick);
                  if (isVictory) {
                    // Victory: Navigate to Resting Screen
                    final goldReward =
                        30 + (widget.gameProgress?.currentFloor ?? 1) * 10;
                    final updatedProgress = GameProgress(
                      currentFloor: widget.gameProgress?.currentFloor ?? 1,
                      maxFloor: widget.gameProgress?.maxFloor ?? 5,
                      playerHp: _battleState.player.currentHp,
                      playerMaxHp: _battleState.player.maxHp,
                      playerXp: _battleState.player.currentXp,
                      playerMaxXp: _battleState.player.maxXp,
                      playerAttack: _battleState.player.attack,
                      playerSkill: _battleState.player.skill,
                      gold: (widget.gameProgress?.gold ?? 0) + goldReward,
                      inventory: widget.gameProgress?.inventory ?? [],
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => RestingScreen(
                          dungeon: widget.dungeon,
                          gameProgress: updatedProgress,
                        ),
                      ),
                    );
                  } else {
                    // Defeat: Return to main menu
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  isVictory
                      ? AppLocalizations.of(context)!.battleContinue
                      : AppLocalizations.of(context)!.battleReturn,
                  style: const TextStyle(
                    fontFamily: 'Unifont',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StickFigurePainter extends CustomPainter {
  final bool isPlayer;

  StickFigurePainter({required this.isPlayer});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final headRadius = size.width * 0.2;

    // Head
    canvas.drawCircle(Offset(centerX, headRadius + 5), headRadius, paint);

    // Body
    final bodyStart = Offset(centerX, headRadius * 2 + 5);
    final bodyEnd = Offset(centerX, size.height * 0.6);
    canvas.drawLine(bodyStart, bodyEnd, paint);

    // Arms
    final armY = size.height * 0.4;
    canvas.drawLine(
      Offset(centerX - size.width * 0.3, armY),
      Offset(centerX + size.width * 0.3, armY),
      paint,
    );

    // Legs
    canvas.drawLine(
      bodyEnd,
      Offset(centerX - size.width * 0.2, size.height * 0.9),
      paint,
    );
    canvas.drawLine(
      bodyEnd,
      Offset(centerX + size.width * 0.2, size.height * 0.9),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

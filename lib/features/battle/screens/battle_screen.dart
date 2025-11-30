import 'package:flutter/material.dart';
import 'package:penuhan/features/battle/models/battle_character.dart';
import 'package:penuhan/features/battle/models/battle_state.dart';
import 'package:penuhan/features/battle/models/skill.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/game_progress.dart';
import 'package:penuhan/core/models/item.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/core/widgets/pause_overlay.dart';
import 'package:penuhan/features/app/screens/resting_screen.dart';
import 'package:penuhan/features/app/screens/stat_upgrade_screen.dart';
import 'package:penuhan/features/battle/models/monster_registry.dart';
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
  bool _showItemList = false;
  Item? _selectedItem;
  bool _showMessage = false;
  String _currentMessage = '';
  List<InventoryItem> _currentInventory = [];
  bool _isPaused = false;
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();
    _initBattle();
    _currentInventory = widget.gameProgress?.inventory ?? [];
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
      currentMp: progress?.playerMp ?? 50,
      maxMp: progress?.playerMaxMp ?? 50,
      attack: progress?.playerAttack ?? 10,
      skill: progress?.playerSkill ?? 10,
    );

    // Initialize enemy from monster registry
    final monster = MonsterRegistry.forDungeon(widget.dungeon);
    final enemy = BattleCharacter(
      name: monster.name,
      currentHp: monster.maxHp,
      maxHp: monster.maxHp,
      currentXp: 0,
      maxXp: 100,
      currentMp: 0,
      maxMp: 0,
      attack: monster.attack,
      skill: monster.skillStat,
    );

    _battleState = BattleState(
      player: player,
      enemy: enemy,
      battleLog: 'Battle Start!',
    );
  }

  // Obsolete enemy stat helpers removed; using MonsterRegistry and _battleState.enemy

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
        case BattleAction.item:
          // Show item list UI
          _showItemList = true;
          _selectedItem = null;
          _audioManager.playSfx(AssetManager.sfxClick);
          return; // Don't process turn yet
      }

      _battleState.battleLog = log;

      // Show player action message and keep showing until turn completes
      _currentMessage = log;
      _showMessage = true;

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

        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            setState(() {
              _isEnemyHit = false;
              final monster = MonsterRegistry.forDungeon(widget.dungeon);
              final bool useSkill =
                  monster.skills.isNotEmpty && Random().nextBool();

              int enemyDamage;
              if (useSkill) {
                final skill =
                    monster.skills[Random().nextInt(monster.skills.length)];
                enemyDamage = skill.calculateDamage(_battleState.enemy.skill);
                _battleState.player.takeDamage(enemyDamage);
                log = AppLocalizations.of(context)!.battleEnemyUsesSkill(
                  _battleState.enemy.name,
                  skill.getLocalizedName(context),
                  enemyDamage,
                );
              } else {
                enemyDamage = _battleState.enemy.attack + Random().nextInt(5);
                _battleState.player.takeDamage(enemyDamage);
                log = AppLocalizations.of(
                  context,
                )!.battleEnemyAttacks(_battleState.enemy.name, enemyDamage);
              }
              _isPlayerHit = true;
              _shakeController.forward(from: 0);
              _audioManager.playSfx(AssetManager.sfxClick);

              _battleState.battleLog = log;

              // Update to enemy action message
              _currentMessage = log;

              // Check if player is defeated
              if (!_battleState.player.isAlive) {
                _battleState.phase = BattlePhase.defeat;
                log = AppLocalizations.of(context)!.battleDefeatMessage;
              } else {
                _battleState.phase = BattlePhase.playerTurn;
              }

              // Hide message after enemy action completes
              Future.delayed(const Duration(milliseconds: 900), () {
                if (mounted) {
                  setState(() {
                    _isPlayerHit = false;
                    _showMessage = false;
                  });
                }
              });
            });
          }
        });
      }
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
            _buildUILayer(screenHeight),
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
        ],
      ),
    );
  }

  Widget _buildUILayer(double screenHeight) {
    return Stack(
      children: [
        // Enemy info bar - STATIC POSITION (only for action buttons & battle message)
        // Hidden when viewing skill/item detail
        if (_selectedSkill == null && _selectedItem == null)
          Positioned(
            left: 24,
            right: 24,
            top:
                screenHeight *
                0.1, // Di atas player bar - responsif untuk semua device
            child: _buildCharacterInfo(
              _battleState.enemy,
              isPlayer: false,
              isHit: _isEnemyHit,
              previewDamage: null,
              previewHeal: null,
            ),
          ),

        // Player info bar - STATIC POSITION (only for action buttons & battle message)
        // Hidden when viewing skill/item detail
        if (_selectedSkill == null && _selectedItem == null)
          Positioned(
            left: 24,
            right: 24,
            bottom:
                screenHeight *
                0.17, // 27% dari tinggi layar - responsif untuk semua device
            child: _buildCharacterInfo(
              _battleState.player,
              isPlayer: true,
              isHit: _isPlayerHit,
              previewDamage: null,
              previewHeal: null,
            ),
          ),

        // Action area - STATIC POSITION (only for action buttons & battle message)
        // Hidden when viewing skill/item detail
        if (_selectedSkill == null && _selectedItem == null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height:
                screenHeight *
                0.18, // 25% dari tinggi layar - responsif untuk semua device
            child: Column(
              children: [
                // Battle message (shown during actions)
                if (_showMessage) Expanded(child: _buildBattleMessage()),

                // Action buttons (hidden during actions)
                if (!_showMessage)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildActionButtons(),
                    ),
                  ),
              ],
            ),
          ),

        // Skill/Item detail area - DYNAMIC POSITION (like before)
        // Shows bar info above detail, positioned normally at bottom
        if (_selectedSkill != null || _selectedItem != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Character info bar above skill/item detail
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _selectedSkill != null
                        ? (_selectedSkill!.effect == SkillEffect.heal
                              ? _buildCharacterInfo(
                                  _battleState.player,
                                  isPlayer: true,
                                  isHit: _isPlayerHit,
                                  previewDamage: null,
                                  previewHeal: 30,
                                )
                              : _buildCharacterInfo(
                                  _battleState.enemy,
                                  isPlayer: false,
                                  isHit: _isEnemyHit,
                                  previewDamage: _selectedSkill!
                                      .calculateDamage(
                                        _battleState.player.skill,
                                      ),
                                  previewHeal: null,
                                ))
                        : _buildCharacterInfo(
                            _battleState.player,
                            isPlayer: true,
                            isHit: _isPlayerHit,
                            previewDamage: null,
                            previewHeal: _selectedItem!.hpRestore,
                          ),
                  ),
                  // Skill or Item detail below
                  _selectedSkill != null
                      ? _buildSkillDetail()
                      : _buildItemDetail(),
                ],
              ),
            ),
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

        // Item list overlay (only when showing list, not detail)
        if (_showItemList && _selectedItem == null)
          Container(
            color: Colors.black87,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 60,
                ),
                constraints: const BoxConstraints(maxHeight: 500),
                child: _buildItemList(),
              ),
            ),
          ),

        // Victory/Defeat overlay
        if (_battleState.isBattleOver) _buildBattleEndOverlay(),

        // Pause button (pojok kanan atas, layer atas)
        Positioned(
          top: 8,
          left: 35,
          child: PauseButton(
            onPause: () {
              _audioManager.playSfx(AssetManager.sfxClick);
              setState(() => _isPaused = true);
            },
          ),
        ),

        // Pause overlay or Settings overlay
        if (_isPaused && !_showSettings)
          PauseOverlay(
            onResume: () {
              setState(() {
                _isPaused = false;
                _showSettings = false;
              });
            },
            onOption: () {
              setState(() => _showSettings = true);
            },
            onMainMenu: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        if (_isPaused && _showSettings)
          SettingsOverlay(
            onClose: () {
              setState(() => _showSettings = false);
            },
          ),
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
            const SizedBox(height: 8),
            // MP Bar similar style to HP bar (blue color)
            _buildStatBar('MP', character.mpPercentage, Colors.blue),
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

  Widget _buildBattleMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          // Gunakan Center untuk menempatkan teks di tengah
          child: Text(
            _currentMessage,
            textAlign:
                TextAlign.center, // Untuk meratakan teks secara horizontal
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Unifont',
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ),
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
          'Item',
          canAct,
          () => _performAction(BattleAction.item),
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
    final canUse = _battleState.player.currentMp >= skill.skillCost;

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
              _buildStatInfo('Cost', '${skill.skillCost} MP'),
              if (skill.effect != SkillEffect.heal)
                _buildStatInfo('Damage', '~$estimatedDamage')
              else
                _buildStatInfo('Heal', '30 HP'),
            ],
          ),
          if (!canUse) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                l10n.notEnoughMP,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'Unifont',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
                  onPressed: canUse
                      ? () {
                          _useSkill(skill);
                        }
                      : null,
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
        // Spend MP (already validated in UI)
        _battleState.player.spendMp(skill.skillCost);
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

      _battleState.battleLog = log;

      // Show player skill message and keep showing until turn completes
      _currentMessage = log;
      _showMessage = true;

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

        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            setState(() {
              _isEnemyHit = false;
              final monster = MonsterRegistry.forDungeon(widget.dungeon);
              final bool useSkill =
                  monster.skills.isNotEmpty && Random().nextBool();

              int enemyDamage;
              String enemyLog;
              if (useSkill) {
                final skill =
                    monster.skills[Random().nextInt(monster.skills.length)];
                enemyDamage = skill.calculateDamage(_battleState.enemy.skill);
                _battleState.player.takeDamage(enemyDamage);
                enemyLog = AppLocalizations.of(context)!.battleEnemyUsesSkill(
                  _battleState.enemy.name,
                  skill.getLocalizedName(context),
                  enemyDamage,
                );
              } else {
                enemyDamage = _battleState.enemy.attack + Random().nextInt(5);
                _battleState.player.takeDamage(enemyDamage);
                enemyLog = AppLocalizations.of(
                  context,
                )!.battleEnemyAttacks(_battleState.enemy.name, enemyDamage);
              }
              _isPlayerHit = true;
              _shakeController.forward(from: 0);
              _audioManager.playSfx(AssetManager.sfxClick);

              _battleState.battleLog = enemyLog;

              // Update to enemy action message
              _currentMessage = enemyLog;

              // Check if player is defeated
              if (!_battleState.player.isAlive) {
                _battleState.phase = BattlePhase.defeat;
                enemyLog = AppLocalizations.of(context)!.battleDefeatMessage;
              } else {
                _battleState.phase = BattlePhase.playerTurn;
              }

              // Hide message after enemy action completes
              Future.delayed(const Duration(milliseconds: 900), () {
                if (mounted) {
                  setState(() {
                    _isPlayerHit = false;
                    _showMessage = false;
                  });
                }
              });
            });
          }
        });
      }

      if (_isEnemyHit) {
        _shakeController.forward(from: 0).then((_) {
          if (mounted) {
            setState(() => _isEnemyHit = false);
          }
        });
      }
    });
  }

  Widget _buildItemList() {
    final availableItems = _currentInventory
        .map((invItem) {
          final item = Item.allItems.firstWhere((i) => i.id == invItem.itemId);
          return item;
        })
        .where((item) => item.type == ItemType.potion)
        .toList();

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
            'SELECT ITEM',
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
            child: availableItems.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.restingNoItems,
                      style: const TextStyle(
                        fontFamily: 'Unifont',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: availableItems.length,
                    itemBuilder: (context, index) {
                      final item = availableItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: ElevatedButton(
                          onPressed: () {
                            _audioManager.playSfx(AssetManager.sfxClick);
                            setState(() {
                              _selectedItem = item;
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
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.getLocalizedName(context),
                                style: const TextStyle(
                                  fontFamily: 'Unifont',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.getLocalizedDescription(context),
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
                    _showItemList = false;
                    _selectedItem = null;
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

  Widget _buildItemDetail() {
    final l10n = AppLocalizations.of(context)!;
    final item = _selectedItem!;

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
            item.getLocalizedName(context).toUpperCase(),
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
              item.getLocalizedDescription(context),
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
          if (item.hpRestore != null)
            Center(child: _buildStatInfo('Restore', '${item.hpRestore} HP')),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _audioManager.playSfx(AssetManager.sfxClick);
                    setState(() {
                      _selectedItem = null;
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
                    _useItem(item);
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
                    l10n.restingUse,
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

  void _useItem(Item item) {
    _audioManager.playSfx(AssetManager.sfxClick);

    setState(() {
      String log = '';

      // Use the item effect
      final messages = <String>[];
      if (item.hpRestore != null) {
        final oldHp = _battleState.player.currentHp;
        _battleState.player.heal(item.hpRestore!);
        final actualHeal = _battleState.player.currentHp - oldHp;
        messages.add(
          AppLocalizations.of(
            context,
          )!.battlePlayerHeals(_battleState.player.name, actualHeal),
        );
      }
      if (item.mpRestore != null) {
        final oldMp = _battleState.player.currentMp;
        _battleState.player.restoreMp(item.mpRestore!);
        final actualRestore = _battleState.player.currentMp - oldMp;
        messages.add(
          AppLocalizations.of(
            context,
          )!.battlePlayerRestoresMp(_battleState.player.name, actualRestore),
        );
      }
      log = messages.join('\n');

      // Remove item from local inventory
      final itemIndex = _currentInventory.indexWhere(
        (inv) => inv.itemId == item.id,
      );
      if (itemIndex >= 0) {
        final inventoryItem = _currentInventory[itemIndex];
        if (inventoryItem.quantity > 1) {
          _currentInventory[itemIndex] = inventoryItem.copyWith(
            quantity: inventoryItem.quantity - 1,
          );
        } else {
          _currentInventory.removeAt(itemIndex);
        }
      }

      // Reset item UI
      _showItemList = false;
      _selectedItem = null;

      _battleState.battleLog = log;

      // Show player item usage message and keep showing until turn completes
      _currentMessage = log;
      _showMessage = true;

      // Enemy's turn
      _battleState.phase = BattlePhase.enemyTurn;

      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) {
          setState(() {
            int enemyDamage = _battleState.enemy.attack + Random().nextInt(5);
            _battleState.player.takeDamage(enemyDamage);
            String enemyLog = AppLocalizations.of(
              context,
            )!.battleEnemyAttacks(_battleState.enemy.name, enemyDamage);
            _isPlayerHit = true;
            _shakeController.forward(from: 0);
            _audioManager.playSfx(AssetManager.sfxClick);

            _battleState.battleLog = enemyLog;

            // Update to enemy action message
            _currentMessage = enemyLog;

            // Check if player is defeated
            if (!_battleState.player.isAlive) {
              _battleState.phase = BattlePhase.defeat;
              enemyLog = AppLocalizations.of(context)!.battleDefeatMessage;
            } else {
              _battleState.phase = BattlePhase.playerTurn;
            }

            // Hide message after enemy action completes
            Future.delayed(const Duration(milliseconds: 900), () {
              if (mounted) {
                setState(() {
                  _isPlayerHit = false;
                  _showMessage = false;
                });
              }
            });
          });
        }
      });
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
                isVictory
                    ? AppLocalizations.of(
                        context,
                      )!.battleVictoryMessage(_battleState.enemy.name)
                    : AppLocalizations.of(context)!.battleDefeatMessage,
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
                    // Victory: Navigate to Stat Upgrade Screen if leveled up, otherwise Resting Screen
                    final goldReward =
                        30 + (widget.gameProgress?.currentFloor ?? 1) * 10;
                    // Grant XP reward and carry battle-updated stats
                    final baseProgress = GameProgress(
                      currentFloor: widget.gameProgress?.currentFloor ?? 1,
                      maxFloor: widget.gameProgress?.maxFloor ?? 5,
                      playerLevel: widget.gameProgress?.playerLevel ?? 1,
                      playerHp: _battleState.player.currentHp,
                      playerMaxHp: _battleState.player.maxHp,
                      playerXp: _battleState.player.currentXp,
                      playerMaxXp: _battleState.player.maxXp,
                      playerMp: _battleState.player.currentMp,
                      playerMaxMp: _battleState.player.maxMp,
                      playerAttack: _battleState.player.attack,
                      playerSkill: _battleState.player.skill,
                      gold: (widget.gameProgress?.gold ?? 0) + goldReward,
                      inventory:
                          _currentInventory, // Use updated inventory from battle
                    );
                    final xpReward =
                        20 + (widget.gameProgress?.currentFloor ?? 1) * 5;
                    final xpResult = baseProgress.addXp(xpReward);

                    // Check if player leveled up
                    if (xpResult.levelsGained > 0) {
                      // Navigate to stat upgrade screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => StatUpgradeScreen(
                            progress: xpResult.progress,
                            levelsGained: xpResult.levelsGained,
                            dungeon: widget.dungeon,
                          ),
                        ),
                      );
                    } else {
                      // No level up, go directly to resting screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => RestingScreen(
                            dungeon: widget.dungeon,
                            gameProgress: xpResult.progress,
                          ),
                        ),
                      );
                    }
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

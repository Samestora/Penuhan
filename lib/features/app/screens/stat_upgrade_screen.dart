import 'package:flutter/material.dart';

import '../../../core/models/game_progress.dart';
import '../../../core/models/dungeon.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'package:penuhan/core/widgets/monochrome_button.dart';
import 'resting_screen.dart';

class StatUpgradeScreen extends StatefulWidget {
  final GameProgress progress;
  final int levelsGained;
  final Dungeon dungeon;

  const StatUpgradeScreen({
    super.key,
    required this.progress,
    required this.levelsGained,
    required this.dungeon,
  });

  @override
  State<StatUpgradeScreen> createState() => _StatUpgradeScreenState();
}

class _StatUpgradeScreenState extends State<StatUpgradeScreen> {
  late int _availablePoints;
  late int _maxHpBonus;
  late int _maxMpBonus;
  late int _attackBonus;
  late int _skillBonus;
  late int _defenseBonus;

  @override
  void initState() {
    super.initState();
    // Each level gives 5 stat points to allocate
    _availablePoints = widget.levelsGained * 5;
    _maxHpBonus = 0;
    _maxMpBonus = 0;
    _attackBonus = 0;
    _skillBonus = 0;
    _defenseBonus = 0;
  }

  void _incrementStat(String stat) {
    if (_availablePoints <= 0) return;

    setState(() {
      switch (stat) {
        case 'maxHp':
          _maxHpBonus += 5; // Each point = +5 MaxHP
          break;
        case 'maxMp':
          _maxMpBonus += 3; // Each point = +3 MaxMP
          break;
        case 'attack':
          _attackBonus += 1; // Each point = +1 Attack
          break;
        case 'skill':
          _skillBonus += 1; // Each point = +1 Skill
          break;
        case 'defense':
          _defenseBonus += 1; // Each point = +1 Defense
          break;
      }
      _availablePoints--;
    });
  }

  void _decrementStat(String stat) {
    setState(() {
      switch (stat) {
        case 'maxHp':
          if (_maxHpBonus > 0) {
            _maxHpBonus -= 5;
            _availablePoints++;
          }
          break;
        case 'maxMp':
          if (_maxMpBonus > 0) {
            _maxMpBonus -= 3;
            _availablePoints++;
          }
          break;
        case 'attack':
          if (_attackBonus > 0) {
            _attackBonus -= 1;
            _availablePoints++;
          }
          break;
        case 'skill':
          if (_skillBonus > 0) {
            _skillBonus -= 1;
            _availablePoints++;
          }
          break;
        case 'defense':
          if (_defenseBonus > 0) {
            _defenseBonus -= 1;
            _availablePoints++;
          }
          break;
      }
    });
  }

  void _confirmUpgrade() {
    // Apply stat bonuses to progress
    final updatedProgress = widget.progress.copyWith(
      playerMaxHp: widget.progress.playerMaxHp + _maxHpBonus,
      playerMaxMp: widget.progress.playerMaxMp + _maxMpBonus,
      playerAttack: widget.progress.playerAttack + _attackBonus,
      playerSkill: widget.progress.playerSkill + _skillBonus,
      playerDefense: widget.progress.playerDefense + _defenseBonus,
      // Restore HP/MP to new max values
      playerHp: widget.progress.playerMaxHp + _maxHpBonus,
      playerMp: widget.progress.playerMaxMp + _maxMpBonus,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RestingScreen(
          dungeon: widget.dungeon,
          gameProgress: updatedProgress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/engine/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                margin: const EdgeInsets.all(16.0),
                color: Colors.black.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        l10n.statUpgradeTitle,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Level info
                      Text(
                        l10n.statUpgradeLevel(widget.progress.playerLevel),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Available points
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.amber, width: 2),
                        ),
                        child: Text(
                          l10n.statUpgradePointsAvailable(_availablePoints),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Stat upgrade rows
                      _buildStatRow(
                        l10n.statUpgradeMaxHp,
                        widget.progress.playerMaxHp,
                        _maxHpBonus,
                        'maxHp',
                        _maxHpBonus ~/ 5,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        l10n.statUpgradeMaxMp,
                        widget.progress.playerMaxMp,
                        _maxMpBonus,
                        'maxMp',
                        _maxMpBonus ~/ 3,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        l10n.statUpgradeAttack,
                        widget.progress.playerAttack,
                        _attackBonus,
                        'attack',
                        _attackBonus,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        l10n.statUpgradeSkill,
                        widget.progress.playerSkill,
                        _skillBonus,
                        'skill',
                        _skillBonus,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        l10n.statUpgradeDefense,
                        widget.progress.playerDefense,
                        _defenseBonus,
                        'defense',
                        _defenseBonus,
                      ),
                      const SizedBox(height: 24),

                      // Confirm button
                      SizedBox(
                        width: double.infinity,
                        child: MonochromeButton(
                          text: l10n.statUpgradeConfirm,
                          onPressed: _availablePoints == 0
                              ? _confirmUpgrade
                              : null,
                        ),
                      ),
                      if (_availablePoints > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            l10n.statUpgradeAllocateAll,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    int currentValue,
    int bonus,
    String statKey,
    int pointsSpent,
  ) {
    final theme = Theme.of(context);
    final hasBonus = bonus > 0;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: hasBonus ? Colors.green : Colors.grey[700]!,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Stat label
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Current value
          Expanded(
            flex: 2,
            child: Text(
              hasBonus
                  ? '$currentValue → ${currentValue + bonus}'
                  : '$currentValue',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: hasBonus ? Colors.green : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Points spent
          Expanded(
            flex: 1,
            child: Text(
              '($pointsSpent)',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.amber),
              textAlign: TextAlign.center,
            ),
          ),

          // Buttons
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: pointsSpent > 0
                      ? () => _decrementStat(statKey)
                      : null,
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.red,
                  iconSize: 28,
                ),
                IconButton(
                  onPressed: _availablePoints > 0
                      ? () => _incrementStat(statKey)
                      : null,
                  icon: const Icon(Icons.add_circle),
                  color: Colors.green,
                  iconSize: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

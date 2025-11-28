import 'package:flutter/material.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/game_progress.dart';
import 'package:penuhan/core/models/item.dart';
import 'package:penuhan/features/battle/models/skill.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/core/widgets/monochrome_button.dart';
import 'package:penuhan/core/widgets/pause_overlay.dart';
import 'package:penuhan/features/app/screens/floor_selection_screen.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:penuhan/core/utils/localization_extensions.dart';

class RestingScreen extends StatefulWidget {
  final Dungeon dungeon;
  final GameProgress gameProgress;
  final int initialTab;

  const RestingScreen({
    super.key,
    required this.dungeon,
    required this.gameProgress,
    this.initialTab = 0,
  });

  @override
  State<RestingScreen> createState() => _RestingScreenState();
}

class _RestingScreenState extends State<RestingScreen> {
  late AudioManager _audioManager;
  late int _selectedTab;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioManager = context.read<AudioManager>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                _buildTabButtons(),
                Expanded(child: _buildContent()),
                _buildNextFloorButton(),
              ],
            ),

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

            if (_isPaused)
              PauseOverlay(
                onResume: () {
                  setState(() => _isPaused = false);
                },
                onMainMenu: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(
              context,
            )!.floorNumber(widget.gameProgress.currentFloor),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Unifont',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.restingResting,
            style: const TextStyle(
              color: Colors.grey,
              fontFamily: 'Unifont',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              AppLocalizations.of(context)!.restingStatus,
              0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton(
              AppLocalizations.of(context)!.restingItem,
              1,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton(
              AppLocalizations.of(context)!.skillSelectTitle,
              2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        _audioManager.playSfx(AssetManager.sfxClick);
        setState(() => _selectedTab = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontFamily: 'Unifont',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildStatusTab();
      case 1:
        return _buildItemTab();
      case 2:
        return _buildSkillTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStatusTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Player Status',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Unifont',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              AppLocalizations.of(context)!.restingHp,
              '${widget.gameProgress.playerHp}/${widget.gameProgress.playerMaxHp}',
            ),
            _buildStatRow(
              AppLocalizations.of(context)!.restingXp,
              '${widget.gameProgress.playerXp}/${widget.gameProgress.playerMaxXp}',
            ),
            _buildStatRow(
              AppLocalizations.of(context)!.restingAttack,
              '${widget.gameProgress.playerAttack}',
            ),
            _buildStatRow(
              AppLocalizations.of(context)!.restingSkill,
              '${widget.gameProgress.playerSkill}',
            ),
            _buildStatRow(
              AppLocalizations.of(context)!.restingGold,
              '${widget.gameProgress.gold}',
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.restingDungeonInfo,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Unifont',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              AppLocalizations.of(context)!.restingFloor,
              '${widget.gameProgress.currentFloor}/${widget.gameProgress.maxFloor}',
            ),
            _buildStatRow('Dungeon', widget.dungeon.name.getName(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontFamily: 'Unifont',
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Unifont',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTab() {
    if (widget.gameProgress.inventory.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inventory_2, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.floorItem,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Unifont',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.restingNoItems,
                style: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Unifont',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.gameProgress.inventory.length,
      itemBuilder: (context, index) {
        final inventoryItem = widget.gameProgress.inventory[index];
        final item = Item.allItems.firstWhere(
          (i) => i.id == inventoryItem.itemId,
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: ListTile(
            title: Row(
              children: [
                Text(
                  item.getLocalizedName(context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Unifont',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    'x${inventoryItem.quantity}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Unifont',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item.getLocalizedDescription(context),
                style: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Unifont',
                  fontSize: 12,
                ),
              ),
            ),
            trailing: ElevatedButton(
              onPressed: () => _useItem(item.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.restingUse,
                style: const TextStyle(
                  fontFamily: 'Unifont',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _useItem(String itemId) {
    _audioManager.playSfx(AssetManager.sfxClick);
    setState(() {
      final updatedProgress = widget.gameProgress.useItem(itemId);
      // Update parent dengan progress baru
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RestingScreen(
            dungeon: widget.dungeon,
            gameProgress: updatedProgress,
          ),
        ),
      );
    });
  }

  Widget _buildSkillTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: Skill.allSkills.length,
      itemBuilder: (context, index) {
        final skill = Skill.allSkills[index];
        final l10n = AppLocalizations.of(context)!;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skill name and SP cost
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        skill.getLocalizedName(context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Unifont',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        l10n.skillCost(skill.skillCost),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Unifont',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Skill description
                Text(
                  skill.getLocalizedDescription(context),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Unifont',
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Skill stats
                // Row(
                //   children: [
                //     if (skill.effect != SkillEffect.heal) ...[
                //       _buildSkillStat(
                //         l10n.skillDamageLabel,
                //         '${(skill.damageMultiplier * 100).toInt()}%',
                //         Colors.red,
                //       ),
                //       const SizedBox(width: 16),
                //     ],
                //     if (skill.effect == SkillEffect.heal) ...[
                //       _buildSkillStat(
                //         l10n.skillHealLabel,
                //         '30 HP',
                //         Colors.green,
                //       ),
                //       const SizedBox(width: 16),
                //     ],
                //     _buildSkillStat(
                //       l10n.skillCostLabel,
                //       '${skill.skillCost} SP',
                //       Colors.blue,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillStat(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Unifont',
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Unifont',
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNextFloorButton() {
    final isLastFloor =
        widget.gameProgress.currentFloor >= widget.gameProgress.maxFloor;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: MonochromeButton(
        text: isLastFloor
            ? AppLocalizations.of(context)!.restingFinishDungeon
            : AppLocalizations.of(context)!.restingNextFloor,
        onPressed: () {
          _audioManager.playSfx(AssetManager.sfxClick);
          if (isLastFloor) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => FloorSelectionScreen(
                  dungeon: widget.dungeon,
                  gameProgress: widget.gameProgress.nextFloor(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

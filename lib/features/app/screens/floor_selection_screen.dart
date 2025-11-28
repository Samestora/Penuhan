import 'package:flutter/material.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/floor_option.dart';
import 'package:penuhan/core/models/game_progress.dart';
import 'package:penuhan/core/models/item.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/core/widgets/monochrome_button.dart';
import 'package:penuhan/core/widgets/pause_overlay.dart';
import 'package:penuhan/features/app/screens/resting_screen.dart';
import 'package:penuhan/features/app/screens/shop_screen.dart';
import 'package:penuhan/features/battle/screens/battle_screen.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class FloorSelectionScreen extends StatefulWidget {
  final Dungeon dungeon;
  final GameProgress gameProgress;
  final List<FloorOption>? options;

  const FloorSelectionScreen({
    super.key,
    required this.dungeon,
    required this.gameProgress,
    this.options,
  });

  @override
  State<FloorSelectionScreen> createState() => _FloorSelectionScreenState();
}

class _FloorSelectionScreenState extends State<FloorSelectionScreen> {
  late AudioManager _audioManager;
  late List<FloorOption> _options;
  late GameProgress _progress;
  bool _showStatusDialog = false;
  bool _showItemDialog = false;
  bool _isPaused = false;
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();
    _options = widget.options ?? FloorOption.generateRandomOptions();
    _progress = widget.gameProgress;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioManager = context.read<AudioManager>();
  }

  void _selectOption(FloorOption option) {
    _audioManager.playSfx(AssetManager.sfxClick);

    switch (option.type) {
      case FloorOptionType.battle:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                BattleScreen(dungeon: widget.dungeon, gameProgress: _progress),
          ),
        );
        break;
      case FloorOptionType.shop:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                ShopScreen(dungeon: widget.dungeon, gameProgress: _progress),
          ),
        );
        break;
      case FloorOptionType.rest:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => RestingScreen(
              dungeon: widget.dungeon,
              gameProgress: _progress,
              initialTab: 0, // Open status tab
            ),
          ),
        );
        break;
    }
  }

  void _showStatus() {
    _audioManager.playSfx(AssetManager.sfxClick);
    setState(() => _showStatusDialog = true);
  }

  void _showItems() {
    _audioManager.playSfx(AssetManager.sfxClick);
    setState(() => _showItemDialog = true);
  }

  void _closeDialogs() {
    setState(() {
      _showStatusDialog = false;
      _showItemDialog = false;
    });
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
                Expanded(child: _buildFloorOptions()),
              ],
            ),
            _buildSideButtons(),
            if (_showStatusDialog) _buildStatusDialog(),
            if (_showItemDialog) _buildItemDialog(),

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
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white, width: 2)),
      ),
      child: Column(
        children: [
          Text(
            widget.dungeon.name.toString().split('.').last.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Unifont',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.floorNumber(_progress.currentFloor),
            style: const TextStyle(
              fontFamily: 'Unifont',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorOptions() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.floorChoosePath,
            style: const TextStyle(
              fontFamily: 'Unifont',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ..._options.map(
            (option) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: _buildOptionCard(option),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(FloorOption option) {
    return GestureDetector(
      onTap: () => _selectOption(option),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          color: Colors.black,
        ),
        child: Column(
          children: [
            Text(
              option.getLocalizedName(context).toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Unifont',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              option.getLocalizedDescription(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Unifont',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideButtons() {
    return Positioned(
      right: 16,
      top: 100,
      child: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Column(
            children: [
              MonochromeButton(
                text: l10n.floorStatus,
                onPressed: _showStatus,
                width: 100,
              ),
              const SizedBox(height: 16),
              MonochromeButton(
                text: l10n.floorItem,
                onPressed: _showItems,
                width: 100,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusDialog() {
    final l10n = AppLocalizations.of(context)!;
    return _buildDialog(
      title: l10n.floorStatus,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatRow(
            l10n.restingHp,
            '${_progress.playerHp}/${_progress.playerMaxHp}',
          ),
          _buildStatRow(
            l10n.restingXp,
            '${_progress.playerXp}/${_progress.playerMaxXp}',
          ),
          _buildStatRow('MP', '${_progress.playerMp}/${_progress.playerMaxMp}'),
          _buildStatRow(l10n.restingAttack, '${_progress.playerAttack}'),
          _buildStatRow(l10n.restingSkill, '${_progress.playerSkill}'),
          _buildStatRow(l10n.restingGold, '${_progress.gold}'),
          const SizedBox(height: 8),
          _buildStatRow(l10n.restingFloor, '${_progress.currentFloor}'),
        ],
      ),
    );
  }

  Widget _buildItemDialog() {
    final l10n = AppLocalizations.of(context)!;
    final inventory = _progress.inventory;
    return _buildDialog(
      title: l10n.floorItem,
      child: inventory.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.restingNoItems,
                style: TextStyle(
                  fontFamily: 'Unifont',
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: inventory.map((invItem) {
                final item = Item.allItems.firstWhere(
                  (i) => i.id == invItem.itemId,
                );
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 1),
                  ),
                  child: Row(
                    children: [
                      // Item info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.getLocalizedName(context),
                              style: const TextStyle(
                                fontFamily: 'Unifont',
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.getLocalizedDescription(context),
                              style: const TextStyle(
                                fontFamily: 'Unifont',
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Quantity
                      Text(
                        'x${invItem.quantity}',
                        style: const TextStyle(
                          fontFamily: 'Unifont',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Use button (only for potions)
                      if (item.type == ItemType.potion)
                        SizedBox(
                          width: 60,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () => _useItem(item.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: Text(
                              l10n.restingUse,
                              style: const TextStyle(
                                fontFamily: 'Unifont',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildDialog({required String title, required Widget child}) {
    return GestureDetector(
      onTap: _closeDialogs,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping dialog
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Unifont',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  child,
                  const SizedBox(height: 16),
                  MonochromeButton(text: 'CLOSE', onPressed: _closeDialogs),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontFamily: 'Unifont',
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Unifont',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _useItem(String itemId) {
    _audioManager.playSfx(AssetManager.sfxClick);

    final item = Item.allItems.firstWhere((i) => i.id == itemId);

    // Check if player can benefit from this item
    if (item.hpRestore != null && _progress.playerHp >= _progress.playerMaxHp) {
      // HP already full, can't use potion
      _showCannotUseItemDialog();
      return;
    }

    // Use the item and update game progress
    final updatedProgress = _progress.useItem(itemId);

    // Close dialog and update local progress without reload
    setState(() {
      _progress = updatedProgress;
      _showItemDialog = false;
    });
  }

  void _showCannotUseItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          'Cannot Use Item',
          style: TextStyle(
            fontFamily: 'Unifont',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'HP is already full!',
          style: TextStyle(
            fontFamily: 'Unifont',
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _audioManager.playSfx(AssetManager.sfxClick);
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Unifont',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

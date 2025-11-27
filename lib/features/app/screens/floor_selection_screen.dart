import 'package:flutter/material.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/floor_option.dart';
import 'package:penuhan/core/models/game_progress.dart';
import 'package:penuhan/core/models/item.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/core/widgets/monochrome_button.dart';
import 'package:penuhan/features/app/screens/resting_screen.dart';
import 'package:penuhan/features/app/screens/shop_screen.dart';
import 'package:penuhan/features/battle/screens/battle_screen.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class FloorSelectionScreen extends StatefulWidget {
  final Dungeon dungeon;
  final GameProgress gameProgress;

  const FloorSelectionScreen({
    super.key,
    required this.dungeon,
    required this.gameProgress,
  });

  @override
  State<FloorSelectionScreen> createState() => _FloorSelectionScreenState();
}

class _FloorSelectionScreenState extends State<FloorSelectionScreen> {
  late AudioManager _audioManager;
  late List<FloorOption> _options;
  bool _showStatusDialog = false;
  bool _showItemDialog = false;

  @override
  void initState() {
    super.initState();
    _options = FloorOption.generateRandomOptions();
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
            builder: (_) => BattleScreen(
              dungeon: widget.dungeon,
              gameProgress: widget.gameProgress,
            ),
          ),
        );
        break;
      case FloorOptionType.shop:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ShopScreen(
              dungeon: widget.dungeon,
              gameProgress: widget.gameProgress,
            ),
          ),
        );
        break;
      case FloorOptionType.rest:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => RestingScreen(
              dungeon: widget.dungeon,
              gameProgress: widget.gameProgress,
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
            AppLocalizations.of(
              context,
            )!.floorNumber(widget.gameProgress.currentFloor),
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
            '${widget.gameProgress.playerHp}/${widget.gameProgress.playerMaxHp}',
          ),
          _buildStatRow(
            l10n.restingXp,
            '${widget.gameProgress.playerXp}/${widget.gameProgress.playerMaxXp}',
          ),
          _buildStatRow(
            l10n.restingAttack,
            '${widget.gameProgress.playerAttack}',
          ),
          _buildStatRow(
            l10n.restingSkill,
            '${widget.gameProgress.playerSkill}',
          ),
          _buildStatRow(l10n.restingGold, '${widget.gameProgress.gold}'),
          const SizedBox(height: 8),
          _buildStatRow(
            l10n.restingFloor,
            '${widget.gameProgress.currentFloor}/${widget.gameProgress.maxFloor}',
          ),
        ],
      ),
    );
  }

  Widget _buildItemDialog() {
    final l10n = AppLocalizations.of(context)!;
    final inventory = widget.gameProgress.inventory;
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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.getLocalizedName(context),
                          style: const TextStyle(
                            fontFamily: 'Unifont',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'x${invItem.quantity}',
                        style: const TextStyle(
                          fontFamily: 'Unifont',
                          fontSize: 14,
                          color: Colors.white,
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
}

import 'package:flutter/material.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/game_progress.dart';
import 'package:penuhan/core/models/item.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/core/widgets/monochrome_button.dart';
import 'package:penuhan/features/app/screens/floor_selection_screen.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  final Dungeon dungeon;
  final GameProgress gameProgress;

  const ShopScreen({
    super.key,
    required this.dungeon,
    required this.gameProgress,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late AudioManager _audioManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioManager = context.read<AudioManager>();
  }

  void _buyItem(ShopItem shopItem) {
    _audioManager.playSfx(AssetManager.sfxClick);
    setState(() {
      final updatedProgress = widget.gameProgress.buyItem(
        shopItem.item,
        shopItem.price,
      );
      // Refresh dengan progress baru
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ShopScreen(
            dungeon: widget.dungeon,
            gameProgress: updatedProgress,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildShopContent()),
            _buildNextFloorButton(),
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on, color: Colors.yellow, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(
                  context,
                )!.shopGold(widget.gameProgress.gold),
                style: const TextStyle(
                  fontFamily: 'Unifont',
                  fontSize: 16,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.shopTitle,
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

  Widget _buildShopContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ShopItem.shopItems.length,
      itemBuilder: (context, index) {
        final shopItem = ShopItem.shopItems[index];
        final canAfford = widget.gameProgress.gold >= shopItem.price;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        shopItem.item.getLocalizedName(context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Unifont',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.shopPrice(shopItem.price),
                      style: TextStyle(
                        color: canAfford ? Colors.yellow : Colors.red,
                        fontFamily: 'Unifont',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  shopItem.item.getLocalizedDescription(context),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Unifont',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canAfford ? () => _buyItem(shopItem) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey[800],
                      disabledForegroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      canAfford
                          ? AppLocalizations.of(context)!.shopBuy
                          : AppLocalizations.of(context)!.shopNotEnoughGold,
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
          ),
        );
      },
    );
  }

  Widget _buildNextFloorButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: MonochromeButton(
        text: AppLocalizations.of(context)!.shopNextFloor,
        onPressed: () {
          _audioManager.playSfx(AssetManager.sfxClick);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => FloorSelectionScreen(
                dungeon: widget.dungeon,
                gameProgress: widget.gameProgress.nextFloor(),
              ),
            ),
          );
        },
      ),
    );
  }
}

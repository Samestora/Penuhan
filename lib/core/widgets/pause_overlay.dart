import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:provider/provider.dart';
import 'package:penuhan/core/widgets/monochrome_modal.dart';
import 'package:penuhan/core/widgets/settings_content.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';

class PauseButton extends StatelessWidget {
  final VoidCallback onPause;

  const PauseButton({super.key, required this.onPause});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.black,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.pause, color: Colors.white, size: 24),
        onPressed: onPause,
      ),
    );
  }
}

class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback? onOption;
  final VoidCallback onMainMenu;
  final VoidCallback? onSave;

  const PauseOverlay({
    super.key,
    required this.onResume,
    this.onOption,
    required this.onMainMenu,
    this.onSave,
  });

  void _showExitConfirmation(BuildContext context, AudioManager audioManager) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.red, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'EXIT GAME?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Unifont',
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'All unsaved progress will be lost.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Unifont',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        audioManager.playSfx(AssetManager.sfxClick);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          fontFamily: 'Unifont',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        audioManager.playSfx(AssetManager.sfxClick);
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        side: const BorderSide(color: Colors.red, width: 2),
                      ),
                      child: const Text(
                        'EXIT',
                        style: TextStyle(
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioManager = context.read<AudioManager>();

    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'PAUSED',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Unifont',
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              _buildPauseButton(
                label: 'RESUME',
                onPressed: () {
                  audioManager.playSfx(AssetManager.sfxClick);
                  onResume();
                },
              ),
              const SizedBox(height: 12),
              if (onSave != null) ...[
                _buildPauseButton(
                  label: 'SAVE',
                  onPressed: () {
                    audioManager.playSfx(AssetManager.sfxClick);
                    onSave!();
                  },
                ),
                const SizedBox(height: 12),
              ],
              if (onOption != null) ...[
                _buildPauseButton(
                  label: 'OPTION',
                  onPressed: () {
                    audioManager.playSfx(AssetManager.sfxClick);
                    showDialog(
                      context: context,
                      builder: (ctx) => MonochromeModal(
                        title: AppLocalizations.of(ctx)!.mainMenuSettings,
                        child: const SettingsContent(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
              _buildPauseButton(
                label: 'MAIN MENU',
                onPressed: () {
                  audioManager.playSfx(AssetManager.sfxClick);
                  onMainMenu();
                },
              ),
              const SizedBox(height: 12),
              _buildPauseButton(
                label: 'EXIT',
                onPressed: () {
                  audioManager.playSfx(AssetManager.sfxClick);
                  _showExitConfirmation(context, audioManager);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Unifont',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettingsOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const SettingsOverlay({super.key, required this.onClose});

  @override
  State<SettingsOverlay> createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay> {
  @override
  Widget build(BuildContext context) {
    final audioManager = context.read<AudioManager>();
    final bgmOn = audioManager.isBgmEnabled;
    final sfxOn = audioManager.isSfxEnabled;

    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'SETTINGS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Unifont',
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildSettingButton(
                label: 'BGM: ${bgmOn ? 'ON' : 'OFF'}',
                onPressed: () async {
                  await audioManager.toggleBgm();
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),
              _buildSettingButton(
                label: 'SFX: ${sfxOn ? 'ON' : 'OFF'}',
                onPressed: () async {
                  await audioManager.toggleSfx();
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),
              _buildSettingButton(label: 'BACK', onPressed: widget.onClose),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Unifont',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

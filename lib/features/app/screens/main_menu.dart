import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/game_progress.dart';
import 'package:penuhan/features/app/screens/resting_screen.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/core/utils/save_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:penuhan/core/widgets/monochrome_button.dart';
import 'package:penuhan/core/widgets/monochrome_modal.dart';
import 'package:penuhan/core/widgets/settings_content.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/features/app/widgets/dungeon_card.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with WidgetsBindingObserver {
  String _versionNumberText = "Loading...";
  late final AudioManager _audioManager;
  bool _isMusicStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _versionNumberText = 'v${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only run this logic once.
    if (!_isMusicStarted) {
      // Get the instance from Provider and store it.
      _audioManager = context.read<AudioManager>();
      _audioManager.playBgm(AssetManager.bgmTitle, looping: true);
      _isMusicStarted = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioManager.stopBgm();
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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(AssetManager.gameLogo, height: 150.0),
              const SizedBox(height: 60.0),

              // Embark Button
              MonochromeButton(
                text: localizations.mainMenuEmbark,
                onPressed: () {
                  _audioManager.playSfx(AssetManager.sfxClick);
                  _showEmbarkDialog();
                },
              ),
              const SizedBox(height: 20.0),

              // Load Button
              MonochromeButton(
                text: localizations.loadGame,
                onPressed: () {
                  _audioManager.playSfx(AssetManager.sfxClick);
                  _showLoadDialog();
                },
              ),
              const SizedBox(height: 20.0),

              // Settings Button - Now enabled!
              MonochromeButton(
                text: localizations.mainMenuSettings,
                onPressed: () {
                  _audioManager.playSfx(AssetManager.sfxClick);
                  _showSettingsDialog();
                },
              ),
              const SizedBox(height: 20.0),

              // About Button
              MonochromeButton(
                text: localizations.mainMenuAbout,
                onPressed: () {
                  _audioManager.playSfx(AssetManager.sfxClick);
                  _showAboutDialog();
                },
              ),
              const Spacer(),

              // Copyright and Version Text
              Column(
                children: [
                  Text(
                    _versionNumberText,
                    style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                  Text(
                    localizations.copyrightNotice,
                    style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper functions
  /// Shows the select save game dialog using the [_EmbarkContent] class
  void _showEmbarkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MonochromeModal(
          title: AppLocalizations.of(context)!.mainMenuEmbark,
          child: const _EmbarkContent(),
        );
      },
    );
  }

  /// Shows the settings dialog using the [_SettingsContent] class
  void _showSettingsDialog() {
    // use built in but with custom looks
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // The builder returns your custom widget, which will be shown as a dialog.
        return MonochromeModal(
          title: AppLocalizations.of(context)!.mainMenuSettings,
          child: const SettingsContent(),
        );
      },
    );
  }

  /// Shows the about dialog using the [_AboutContent] class
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MonochromeModal(
          title: AppLocalizations.of(context)!.mainMenuAbout,
          child: const _AboutContent(),
        );
      },
    );
  }

  /// Shows the load game dialog
  void _showLoadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MonochromeModal(
          title: AppLocalizations.of(context)!.loadGame,
          child: const _LoadContent(),
        );
      },
    );
  }
}

class _LoadContent extends StatefulWidget {
  const _LoadContent();

  @override
  State<_LoadContent> createState() => __LoadContentState();
}

class __LoadContentState extends State<_LoadContent> {
  @override
  Widget build(BuildContext context) {
    final audioManager = context.read<AudioManager>();
    final saveManager = SaveManager.instance;
    final saves = saveManager.getAllSaves();

    return SizedBox(
      height: 400,
      width: 450,
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          final slotNumber = index + 1;
          final saveData = saves[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.black,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                '${AppLocalizations.of(context)!.slot} $slotNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Unifont',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: saveData != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Level ${saveData.playerLevel} • Floor ${saveData.currentFloor}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Unifont',
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat(
                            'yyyy-MM-dd HH:mm',
                          ).format(saveData.savedAt),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Unifont',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      AppLocalizations.of(context)!.emptySlot,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Unifont',
                        fontSize: 14,
                      ),
                    ),
              trailing: saveData != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            audioManager.playSfx(AssetManager.sfxClick);
                            audioManager.stopBgm();
                            Navigator.of(context).pop();

                            final progress = saveData.toGameProgress();
                            final dungeon = saveData.getDungeon();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RestingScreen(
                                  dungeon: dungeon,
                                  gameProgress: progress,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            audioManager.playSfx(AssetManager.sfxClick);
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.zero,
                                ),
                                title: const Text(
                                  'Delete Save?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Unifont',
                                  ),
                                ),
                                content: const Text(
                                  'This action cannot be undone.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'Unifont',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await saveManager.deleteSave(slotNumber);
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _EmbarkContent extends StatefulWidget {
  const _EmbarkContent();

  @override
  State<_EmbarkContent> createState() => __EmbarkContentState();
}

class __EmbarkContentState extends State<_EmbarkContent> {
  @override
  Widget build(BuildContext context) {
    final audioManager = context.read<AudioManager>();

    return SizedBox(
      height: 300, // Constrain the height of the dialog content
      width: 400,
      child: ListView.builder(
        itemCount: Dungeon.values.length,
        itemBuilder: (context, index) {
          final dungeon = Dungeon.values[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: DungeonCard(
              dungeon: dungeon,
              onTap: () {
                audioManager.playSfx(AssetManager.sfxClick);
                audioManager.stopBgm();
                Navigator.of(context).pop(); // Close dialog

                // Initialize game progress
                final initialProgress = GameProgress(
                  currentFloor: 1,
                  maxFloor: 5,
                  playerLevel: 1,
                  playerHp: 150,
                  playerMaxHp: 150,
                  playerXp: 0,
                  playerMaxXp: 150,
                  playerMp: 50,
                  playerMaxMp: 50,
                  playerAttack: 10,
                  playerSkill: 10,
                  playerDefense: 5,
                  gold: 0,
                  purchasedBoostItemIds: const [],
                );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RestingScreen(
                      dungeon: dungeon,
                      gameProgress: initialProgress,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Settings content moved to core/widgets/settings_content.dart for reuse

class _AboutContent extends StatefulWidget {
  const _AboutContent();

  @override
  State<_AboutContent> createState() => __AboutContentState();
}

class __AboutContentState extends State<_AboutContent> {
  // A robust method to launch URLs with error handling.
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      // If launching fails, show a snackbar to the user.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade800,
            content: Text('Could not open link: $e'),
          ),
        );
      }
    }
  }

  // Helper widget for building a credit section with a title and icon.
  Widget _buildCreditSection({
    required IconData icon,
    required String title,
    required String credit,
    String? url, // Make the URL optional
  }) {
    // Determine if the section should be tappable.
    final bool isTappable = url != null && url.isNotEmpty;

    return InkWell(
      onTap: isTappable ? () => _launchURL(url) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      credit,
                      style: TextStyle(
                        color: isTappable
                            ? Colors.blue.shade200
                            : Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                        // Add an underline to visually indicate it's a link.
                        decoration: isTappable
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: Colors.blue.shade200,
                      ),
                    ),
                  ),
                  // Show a link icon if it's tappable.
                  if (isTappable)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.open_in_new,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.aboutCreditsHeader,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Music Credits Section - Now with URL
          _buildCreditSection(
            icon: Icons.music_note_rounded,
            title: localizations.aboutMusicTitle,
            credit: localizations.aboutMusicCredit,
            url: localizations.aboutMusicUrl,
          ),
          const SizedBox(height: 24),

          // Sound Effects Credits Section - Now with URL
          _buildCreditSection(
            icon: Icons.volume_up_rounded,
            title: localizations.aboutSfxTitle,
            credit: localizations.aboutSfxCredit,
            url: localizations.aboutSfxUrl,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

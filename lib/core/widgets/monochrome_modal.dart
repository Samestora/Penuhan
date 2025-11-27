import 'package:flutter/material.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:provider/provider.dart';

/// A reusable, monochrome-styled modal that looks like a window decorator.
///
/// It includes a title bar with a title on the left and a close button on the right.
class MonochromeModal extends StatelessWidget {
  final String title;
  final Widget child;

  const MonochromeModal({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    return Dialog(
      backgroundColor:
          Colors.transparent, // Required to see our custom decorations
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withValues(alpha: .95),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.white24,
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Shrink wraps the content
          children: [
            // 1. The custom "Window Decorator" Title Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title on the left
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Close button on the right
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    audioManager.playSfx(AssetManager.sfxClick);
                    Navigator.of(context).pop();
                  },
                  tooltip: 'Close',
                  splashRadius: 20,
                ),
              ],
            ),
            // A subtle divider to separate title from content
            const Divider(color: Colors.white38, thickness: 1, height: 16),
            const SizedBox(height: 8),

            // 2. The content of the modal
            child,
          ],
        ),
      ),
    );
  }
}

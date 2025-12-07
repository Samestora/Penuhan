import 'package:flutter/material.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/utils/localization_extensions.dart';

class DungeonCard extends StatelessWidget {
  final Dungeon dungeon;
  final VoidCallback onTap;

  const DungeonCard({super.key, required this.dungeon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.grey[850],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(
                dungeon.imageAsset,
                width: 128,
                height: 128,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 32.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dungeon.name.getName(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      dungeon.difficulty.getName(context),
                      style: TextStyle(
                        color: _getDifficultyColor(dungeon.difficulty),
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(DungeonDifficulty difficulty) {
    switch (difficulty) {
      case DungeonDifficulty.hard:
        return Colors.red;
      case DungeonDifficulty.normal:
        return Colors.orange;
      case DungeonDifficulty.easy:
        return Colors.green;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:penuhan/models/dungeon.dart';

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
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dungeon.name,
                      style: const TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      dungeon.difficulty,
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'hard':
        return Colors.red;
      case 'normal':
        return Colors.orange;
      case 'easy':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

import 'package:hive/hive.dart';

// This is a command for the build_runner to generate the adapter
part 'save_data.g.dart';

/// Represents a single save slot in the game
/// Will be in JSON format
/// [int slotNumber, DateTime lastSaved, String progress]
@HiveType(typeId: 0)
class SaveData extends HiveObject {
  /// A unique ID for the slot [1, 2, 3]
  @HiveField(0)
  final int slotNumber;

  // The date and time the game was last saved
  @HiveField(1)
  DateTime lastSaved;

  // A string to represent player progress, e.g., "Chapter 2"
  @HiveField(2)
  String progress;

  // You could add more fields here later, like:
  // @HiveField(3)
  // int playerLevel;
  // @HiveField(4)
  // Uint8List? screenshot;

  SaveData({
    required this.slotNumber,
    required this.lastSaved,
    required this.progress,
  });

  // A method to convert our object to a JSON map for exporting
  Map<String, dynamic> toJson() => {
        'slotNumber': slotNumber,
        'lastSaved': lastSaved.toIso8601String(),
        'progress': progress,
      };

  // A factory to create an object from a JSON map for importing
  factory SaveData.fromJson(Map<String, dynamic> json) => SaveData(
        slotNumber: json['slotNumber'],
        lastSaved: DateTime.parse(json['lastSaved']),
        progress: json['progress'],
      );
}
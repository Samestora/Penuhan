import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/game_progress.dart';
import 'package:penuhan/core/models/save_data.dart';

const String saveDataBoxName = 'save_data_box';

class SaveManager {
  SaveManager._privateConstructor();
  static final SaveManager instance = SaveManager._privateConstructor();

  late Box<SaveData> _saveDataBox;

  Future<void> initialize() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(SaveDataAdapter());
    Hive.registerAdapter(SaveInventoryItemAdapter());
    _saveDataBox = await Hive.openBox<SaveData>(saveDataBoxName);
  }

  Box<SaveData> get saveDataBox => _saveDataBox;

  Future<void> saveGame({
    required int slotNumber,
    required Dungeon dungeon,
    required GameProgress progress,
  }) async {
    final saveData = SaveData.fromGameProgress(
      slotNumber: slotNumber,
      dungeon: dungeon,
      progress: progress,
    );
    await _saveDataBox.put(slotNumber, saveData);
  }

  SaveData? loadGame(int slotNumber) {
    return _saveDataBox.get(slotNumber);
  }

  List<SaveData?> getAllSaves() {
    return [1, 2, 3, 4].map((slot) => _saveDataBox.get(slot)).toList();
  }

  Future<void> deleteSave(int slotNumber) async {
    await _saveDataBox.delete(slotNumber);
  }

  bool hasSave(int slotNumber) {
    return _saveDataBox.containsKey(slotNumber);
  }

  // Exports all save data to a single .json file
  Future<bool> exportSaves() async {
    List<Map<String, dynamic>> allSavesJson = _saveDataBox.values
        .map((save) => save.toJson())
        .toList();

    if (allSavesJson.isEmpty) {
      return false; // Nothing to save
    }

    String jsonData = jsonEncode(allSavesJson);
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Your Game Data',
      fileName:
          'penuhan_saves_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.json',
    );

    if (outputFile != null) {
      final file = File(outputFile);
      await file.writeAsString(jsonData);
      return true;
    }
    return false;
  }

  // Imports saves from a .json file, replacing all existing data
  Future<bool> importSaves() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      String jsonData = await file.readAsString();

      List<dynamic> decodedList = jsonDecode(jsonData);
      List<SaveData> importedSaves = decodedList
          .map((item) => SaveData.fromJson(item))
          .toList();

      // IMPORTANT: Clear existing data before importing
      await _saveDataBox.clear();

      // Add the new data
      for (var save in importedSaves) {
        await _saveDataBox.put(save.slotNumber, save);
      }
      return true;
    }
    return false;
  }
}

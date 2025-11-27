import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:penuhan/core/models/save_data.dart';

const String saveDataBoxName = 'save_data_box';

class SaveManager {
  SaveManager._privateConstructor();
  static final SaveManager instance = SaveManager._privateConstructor();

  late Box<SaveData> _saveDataBox;

  // Call this from main.dart before runApp()
  Future<void> initialize() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(SaveDataAdapter());
    _saveDataBox = await Hive.openBox<SaveData>(saveDataBoxName);
  }

  Box<SaveData> get saveDataBox => _saveDataBox;

  // Creates a brand new save file when an empty slot is clicked
  Future<void> createNewSave(int slotNumber) async {
    final newSave = SaveData(
      slotNumber: slotNumber,
      lastSaved: DateTime.now(),
      progress: "New Game", // Or "Chapter 1", etc.
    );
    // Hive uses a key-value system. We'll use the slot number as the key.
    await _saveDataBox.put(slotNumber, newSave);
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

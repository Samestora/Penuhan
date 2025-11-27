## Quick Reference - Import Paths

### ✅ Gunakan Path Ini

```dart
// Core imports
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/save_data.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/core/utils/save_manager.dart';
import 'package:penuhan/core/widgets/monochrome_button.dart';

// Feature imports (gunakan barrel)
import 'package:penuhan/features/app/app.dart';
import 'package:penuhan/features/battle/battle.dart';
import 'package:penuhan/features/exploration/exploration.dart';

// Atau import spesifik
import 'package:penuhan/features/app/screens/main_menu.dart';
import 'package:penuhan/features/battle/screens/battle_screen.dart';
import 'package:penuhan/features/exploration/game/penuhan_game.dart';
```

### ❌ Jangan Gunakan Path Lama

```dart
// ❌ DEPRECATED
import 'package:penuhan/models/dungeon.dart';
import 'package:penuhan/screens/battle_screen.dart';
import 'package:penuhan/game/game.dart';
import 'package:penuhan/utils/audio_manager.dart';
import 'package:penuhan/widgets/monochrome_button.dart';
```

## Folder yang Bisa Dihapus

Setelah memastikan semua berjalan dengan baik, hapus folder lama:

```powershell
Remove-Item "lib\game" -Recurse -Force
Remove-Item "lib\models" -Recurse -Force
Remove-Item "lib\screens" -Recurse -Force
Remove-Item "lib\utils" -Recurse -Force
Remove-Item "lib\widgets" -Recurse -Force
```

## Struktur Akhir

```
lib/
├── core/                    ✅ GUNAKAN INI
│   ├── models/
│   ├── utils/
│   ├── widgets/
│   └── core.dart
│
├── features/                ✅ GUNAKAN INI
│   ├── app/
│   ├── battle/
│   └── exploration/
│
├── l10n/
├── main.dart
├── STRUCTURE.md
└── ARCHITECTURE.md
```

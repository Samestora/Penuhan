# Struktur Project Penuhan - Feature-First Architecture

## 📁 Struktur Direktori

```
lib/
│
├── 🎯 core/                          # Kode bersama (shared code)
│   ├── models/                       # Model domain
│   │   ├── dungeon.dart              # Model dungeon & difficulty
│   │   ├── save_data.dart            # Model save game
│   │   └── save_data.g.dart          # Generated code
│   │
│   ├── utils/                        # Utilitas & Services
│   │   ├── audio_manager.dart        # Manajemen BGM & SFX
│   │   ├── asset_manager.dart        # Path aset (images, audio)
│   │   ├── save_manager.dart         # Save/load game
│   │   ├── hive_constants.dart       # Konstanta Hive
│   │   └── localization_extensions.dart
│   │
│   ├── widgets/                      # Widget reusable
│   │   ├── monochrome_button.dart
│   │   ├── monochrome_dropdown.dart
│   │   └── monochrome_modal.dart
│   │
│   └── core.dart                     # 📦 Barrel export
│
├── 🎮 features/                      # Modul fitur
│   │
│   ├── app/                          # Fitur aplikasi umum
│   │   ├── screens/
│   │   │   ├── splash_screen.dart    # Loading awal
│   │   │   ├── title_screen.dart     # Title dengan animasi
│   │   │   └── main_menu.dart        # Menu utama + settings
│   │   │
│   │   ├── widgets/
│   │   │   └── dungeon_card.dart     # Card pilihan dungeon
│   │   │
│   │   └── app.dart                  # 📦 Barrel export
│   │
│   ├── battle/                       # Sistem battle turn-based
│   │   ├── models/
│   │   │   ├── battle_character.dart # Stats karakter (HP, XP, ATK)
│   │   │   └── battle_state.dart     # State battle (phase, log)
│   │   │
│   │   ├── screens/
│   │   │   └── battle_screen.dart    # UI battle dengan animasi
│   │   │
│   │   └── battle.dart               # 📦 Barrel export
│   │
│   └── exploration/                  # Dungeon exploration (Flame)
│       ├── game/
│       │   └── penuhan_game.dart     # 🔥 Main FlameGame class
│       │
│       ├── components/               # Flame components
│       │   ├── player.dart           # Player sprite (200x200)
│       │   └── enemy.dart            # Enemy sprite (placeholder)
│       │
│       ├── screens/
│       │   ├── game_play.dart        # Flutter wrapper untuk Flame
│       │   └── tap_circle_indicator.dart
│       │
│       └── exploration.dart          # 📦 Barrel export
│
├── 🌍 l10n/                          # Localization (i18n)
│   └── generated/
│       ├── app_localizations.dart
│       ├── app_localizations_en.dart
│       └── app_localizations_id.dart
│
├── main.dart                         # 🚀 Entry point
└── STRUCTURE.md                      # Dokumentasi ini

```

## 🔄 Alur Aplikasi

```
SplashScreen (2s fade in/out)
    ↓
TitleScreen (animasi judul + tap to start)
    ↓
MainMenu (pilih dungeon + settings)
    ↓
GamePlay (Flame exploration)
    ↓ (nabrak enemy)
BattleScreen (turn-based combat)
    ↓ (victory/defeat)
Kembali ke GamePlay atau MainMenu
```

## 🎯 Konsep Arsitektur

### Feature-First vs Layer-First

❌ **Layer-First (old)**

```
lib/
├── models/          # Semua model campur
├── screens/         # Semua screen campur
├── widgets/         # Semua widget campur
└── utils/           # Semua utils campur
```

✅ **Feature-First (new)**

```
lib/
├── core/            # Shared saja
└── features/
    ├── battle/      # Semua tentang battle
    ├── exploration/ # Semua tentang exploration
    └── app/         # Semua tentang menu/nav
```

### Keuntungan:

1. **Scalable**: Mudah tambah fitur baru
2. **Maintainable**: Fitur terisolasi, mudah debug
3. **Team-friendly**: Bisa kerja parallel per feature
4. **Flame-optimized**: Exploration module terpisah jelas

## 🔥 Integrasi Flame Engine

### Hierarchy

```
Flutter Layer (UI)
    ↓
GamePlay (StatefulWidget)
    ├── Lifecycle management
    ├── Audio handling
    └── Context bridge
        ↓
PenuhanGame (FlameGame)
    ├── Game loop
    ├── Component management
    └── Collision detection
        ↓
Components (SpriteComponent)
    ├── Player
    ├── Enemy
    ├── Map (future)
    └── Items (future)
```

### Komunikasi Flame ↔ Flutter

**Pattern: Callback**

```dart
// GamePlay.dart
PenuhanGame(
  onBattleTriggered: () {
    Navigator.push(...BattleScreen);
  }
)

// PenuhanGame.dart
void checkCollision() {
  if (playerHitsEnemy) {
    onBattleTriggered?.call();
  }
}
```

## 📦 Barrel Exports

Untuk import yang lebih bersih:

```dart
// ❌ Sebelum
import 'package:penuhan/features/battle/models/battle_character.dart';
import 'package:penuhan/features/battle/models/battle_state.dart';
import 'package:penuhan/features/battle/screens/battle_screen.dart';

// ✅ Sesudah
import 'package:penuhan/features/battle/battle.dart';
```

## 🚀 Cara Menambah Fitur Baru

### 1. Buat Feature Module

```
lib/features/shop/
├── models/
│   └── item.dart
├── screens/
│   └── shop_screen.dart
├── widgets/
│   └── item_card.dart
└── shop.dart          # Barrel export
```

### 2. Buat Barrel Export

```dart
// shop.dart
export 'models/item.dart';
export 'screens/shop_screen.dart';
export 'widgets/item_card.dart';
```

### 3. Gunakan Core untuk Shared Code

```dart
import 'package:penuhan/core/core.dart';  // Audio, Save, dll
import 'package:penuhan/features/shop/shop.dart';
```

## 🎨 Menambah Flame Component

### 1. Buat Component

```dart
// lib/features/exploration/components/npc.dart
import 'package:flame/components.dart';

class NPC extends SpriteComponent {
  NPC({super.position})
    : super(size: Vector2(64, 64));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('sprite/npc.png');
  }
}
```

### 2. Register di PenuhanGame

```dart
// penuhan_game.dart
@override
FutureOr<void> onLoad() async {
  add(Player());
  add(NPC(position: Vector2(100, 100)));
}
```

### 3. Export di exploration.dart

```dart
export 'components/npc.dart';
```

## ⚡ Best Practices

1. **Core hanya untuk shared code** - Jangan taruh feature-specific di core
2. **Feature harus independen** - Battle tidak boleh import dari Exploration
3. **Gunakan barrel exports** - Import dari `feature.dart`, bukan file spesifik
4. **Flame di exploration saja** - Jangan campur Flame code di feature lain
5. **Models di feature yang relevan** - BattleCharacter di battle/, bukan core/

## 🔍 Troubleshooting

### Import Error

```
Error: Can't import 'package:penuhan/models/dungeon.dart'
```

**Fix:** Update ke `package:penuhan/core/models/dungeon.dart`

### Flame Component Tidak Muncul

1. Cek apakah sudah `add()` di `PenuhanGame.onLoad()`
2. Cek size tidak 0
3. Cek position dalam bounds kamera

### State Tidak Sync Battle ↔ Exploration

**Solusi:** Gunakan Provider atau pass data via Navigator

## 📚 Resources

- [Flame Documentation](https://docs.flame-engine.org/)
- [Flutter Architecture](https://docs.flutter.dev/data-and-backend/state-mgmt/options)
- [Feature-First Architecture](https://codewithandrea.com/articles/flutter-project-structure/)

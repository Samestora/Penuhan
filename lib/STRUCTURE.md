# Project Structure

This project follows a **feature-first architecture** optimized for scalability and Flame engine integration.

## Directory Structure

```
lib/
├── core/                      # Shared utilities and models
│   ├── models/               # Domain models (Dungeon, SaveData)
│   ├── utils/                # Utilities (Audio, Asset, Save managers)
│   ├── widgets/              # Reusable UI widgets
│   └── core.dart             # Barrel export file
│
├── features/                  # Feature modules
│   ├── app/                  # App-level features (menu, splash)
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── app.dart
│   │
│   ├── battle/               # Turn-based battle system
│   │   ├── models/           # Battle-specific models
│   │   ├── screens/          # Battle UI
│   │   ├── widgets/          # Battle-specific widgets
│   │   └── battle.dart
│   │
│   └── exploration/          # Flame game engine for dungeon exploration
│       ├── game/             # Main game engine (PenuhanGame)
│       ├── components/       # Flame components (Player, Enemy)
│       ├── screens/          # Game screen wrapper (GamePlay)
│       └── exploration.dart
│
├── l10n/                     # Localization files
└── main.dart                 # App entry point
```

## Import Guidelines

### Using Barrel Exports (Recommended)

```dart
// Import entire feature
import 'package:penuhan/features/battle/battle.dart';
import 'package:penuhan/core/core.dart';
```

### Direct Imports

```dart
// Import specific files
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/features/exploration/game/penuhan_game.dart';
```

## Feature Modules

### Core (`lib/core/`)

Shared code used across multiple features:

- **models/**: Domain entities (Dungeon, SaveData)
- **utils/**: Services (AudioManager, AssetManager, SaveManager)
- **widgets/**: Reusable UI components (MonochromeButton, etc.)

### App (`lib/features/app/`)

Application-level screens and navigation:

- SplashScreen
- TitleScreen
- MainMenu
- DungeonCard widget

### Battle (`lib/features/battle/`)

Turn-based combat system:

- BattleScreen (UI)
- BattleCharacter (model)
- BattleState (state management)

### Exploration (`lib/features/exploration/`)

Real-time dungeon exploration using Flame engine:

- **game/**: PenuhanGame (FlameGame instance)
- **components/**: Flame components (Player, Enemy sprites)
- **screens/**: GamePlay (Flutter wrapper for Flame)

## Flame Engine Integration

### Game Structure

```
GamePlay (StatefulWidget)
    ↓ wraps
PenuhanGame (FlameGame)
    ↓ contains
Player, Enemy (SpriteComponent)
```

### Adding New Flame Components

1. Create component in `features/exploration/components/`
2. Extend `SpriteComponent` or appropriate Flame component
3. Add to `PenuhanGame` in `onLoad()`
4. Export in `exploration.dart`

### Triggering Battle from Exploration

Use callback pattern in GamePlay:

```dart
PenuhanGame(
  dungeon: dungeon,
  audioManager: audioManager,
  onBattleTriggered: () {
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => BattleScreen(dungeon: dungeon))
    );
  },
)
```

## Best Practices

1. **Feature Independence**: Features should be loosely coupled
2. **Shared Code in Core**: Only put truly shared code in `core/`
3. **Barrel Exports**: Use barrel files for cleaner imports
4. **Flame Components**: Keep all Flame-specific code in `exploration/`
5. **State Management**: Use Provider for cross-feature state

## Scaling Guidelines

### Adding New Features

1. Create new folder in `features/`
2. Add subfolders: `models/`, `screens/`, `widgets/`
3. Create barrel export file
4. Update relevant imports

### Adding New Flame Components

1. Create in `features/exploration/components/`
2. Follow Flame component lifecycle
3. Register in `PenuhanGame`
4. Export in `exploration.dart`

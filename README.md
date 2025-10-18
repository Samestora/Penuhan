# Penuhan : Continuation of Kosongan
![Images](assets/images/engine/logo.png)

## Getting Started
When you start to develop please run this command first
```bash
flutter pub get
```
Look the [`to do list`](TODO.md) and start from there.

## Localization
To add a translation please add it inside the [`l10n/`](lib/l10n/) as `app_{language_id}.arb` then run :
```bash
flutter gen-l10n
```

## Hive Generator
When adding a new persistency and trying to add `Adapter` with Hive please run this command after adding `<persistency_name>.g.part`
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Contributors
![Images](assets/images/engine/sgdc_logo.png)
- Putranto Surya Wijanarko
- Raden Demas Amirul Plawirakusumah
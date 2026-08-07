# M2Health mobile

The Flutter client for M2Health, a home healthcare platform. It serves both patients and professionals, covering booking, clinical records, screening, questionnaires, and the clinical programs. It talks to the AdonisJS backend.

If you are an AI coding assistant, start with [AGENTS.md](AGENTS.md).

## Documentation

| Document | Covers |
| --- | --- |
| [AGENTS.md](AGENTS.md) | The rules to follow when changing this code |
| [CONTEXT.md](CONTEXT.md) | What the words mean |
| [docs/agents/backend-api-reference.md](docs/agents/backend-api-reference.md) | The API this app calls |
| [.scratch](.scratch/) | Specs, plans, and open issues |

The system architecture lives in the backend repository, in `docs/agents/ARCHITECTURE.md`.

## Getting set up

Flutter is pinned with [FVM](https://fvm.app/), so install that first and prefix every Flutter and Dart command with `fvm`. The pinned version is in `.fvmrc`.

Run everything from the repository root, the folder that contains `pubspec.yaml`. Running from a parent folder picks up stale code, and your changes will not appear.

```bash
fvm flutter pub get
fvm flutter run
```

## Everyday commands

```bash
fvm flutter analyze     # static analysis, must be clean before you commit
fvm dart format .       # format
fvm flutter test        # tests
fvm flutter gen-l10n    # regenerate localization after editing an .arb file
```

Release builds are `fvm flutter build apk` and `fvm flutter build ios`.

## Contributing

Read [AGENTS.md](AGENTS.md) first. In short: `fvm flutter analyze` must be clean, `dart format` must be applied, commit messages are a single conventional line, and you branch before you commit rather than working on `develop` directly.

Single sign-on setup is documented in [SSO_README.md](SSO_README.md).

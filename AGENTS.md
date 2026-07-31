# AGENTS.md

The Flutter client for M2Health, a home healthcare platform. It serves both patients and professionals, and it covers booking, clinical records, screening, questionnaires, and the clinical programs. It talks to the AdonisJS backend.

This file is the contract, and it applies to every session whatever you are working on. It is deliberately short.

Flutter is pinned with FVM, so prefix commands with `fvm`. Run them from the repository root, the folder that contains `pubspec.yaml`. Running from a parent folder picks up stale code and your changes will not appear.

## Where to read what

| Document | Covers | Read it |
| --- | --- | --- |
| [CONTEXT.md](CONTEXT.md) | What the words mean | Before you name anything |
| [.scratch](.scratch/) | Specs, plans, and open issues | When you need to know what is planned |
| `docs/temp` | Your own working notes. Not committed. | Whenever you like |

The architecture and the shared vocabulary live in the **backend repository**, not here, so that they do not drift out of step. Read `docs/agents/ARCHITECTURE.md` and `CONTEXT.md` there before you work anywhere. If your task touches the booking assistant, read `docs/agents/subsystems/conversational-booking.md` there as well, and not otherwise. If you do not have the backend repository checked out, carry on without it.

`docs/agents` describes the system as it exists. `.scratch` describes what we intend to build. Never read a plan as though it were a description of reality.

## The two booking flows

The app carries both, and neither is deprecated. Both are defined in [CONTEXT.md](CONTEXT.md).

Self-service booking is in `features/booking_appointment`. Conversational booking is in `features/intake_booking`, and it is server driven, meaning the backend describes what to show and the app renders it. Do not hardcode intake screens.

## Rules

1. Each feature lives under `lib/features/<name>` and is self-contained across three layers: `domain` for entities, repository interfaces, and use cases, `data` for models, data sources, and repository implementations, and `presentation` for cubits, pages, and widgets. Shared code goes in `lib/core`.
2. Dependencies point inward. Presentation depends on domain. Data depends on domain. Domain depends on nothing. Never let a data model reach the presentation layer. Map it to a domain entity first.
3. Never reach into another feature's internals. Share through `lib/core`.
4. Use Cubit for state. Reach for a full BLoC only when the event flow is genuinely complex.
5. Errors are values. Repository methods return `Either<Failure, T>` from dartz. Model failures as a hierarchy, and fold them in the cubit.
6. Register dependencies with `get_it`. Each feature has its own `injection.dart`, gathered by `service_locator.dart`.
7. Navigate with `go_router`. Use `Navigator.push` only for things that are transient and not deep linkable, such as a dialog or a sheet.
8. Never edit dependencies in `pubspec.yaml` by hand. Use `fvm flutter pub add <package>` and `fvm flutter pub remove <package>`.
9. Never edit generated files, including localization output and anything ending in `.g.dart`. Regenerate them instead.
10. `fvm flutter analyze` must be clean and `dart format` must be applied before you commit.
11. Write commit messages as a single conventional line, for example `fix(booking): guard against a null slot`. No body and no co-author line. Branch first if you are on `develop`. Only commit or push when you are asked to.
12. Keep comments to a minimum. Explain why, not what. Use `///` only on public APIs.

## Conventions

**Naming.** Files are `snake_case`, classes are `PascalCase`, variables and members are `camelCase`.

**Widgets.** Prefer a real `StatelessWidget` or `StatefulWidget` class over a helper method that returns a widget. Use `const` constructors wherever you can. Keep widget trees shallow. Long lists use `ListView.builder` or `GridView.builder`.

**Serialization.** Write `fromJson` and `toJson` by hand on the models in `data/models`.

**Theming.** Colors and constants live in `lib/const.dart`. Add new ones there rather than hardcoding them in a widget.

**Layout.** Use `LayoutBuilder` and `MediaQuery`. Do not use fixed sizes.

**Logging.** Use `log` from `dart:developer` with a `name` such as `booking.cubit`. On a caught error, pass both the error and the stack trace.

**Localization.** Edit the `.arb` files in `lib/l10n`, then run `fvm flutter gen-l10n`. Never edit the generated strings.

**Tests.** Mirror the structure of `lib` under `test`. Arrange, act, assert. Use `mocktail` for mocks.

**Privacy.** The consent banners and privacy notices in the chat and AI features are load bearing. Do not remove or bypass them.

## Commands

| Command | What it does |
| --- | --- |
| `fvm flutter pub get` | Install dependencies |
| `fvm flutter run` | Run the app on a device or emulator |
| `fvm flutter analyze` | Static analysis. Must be clean before you commit. |
| `fvm dart format .` | Format |
| `fvm flutter test` | Run the tests |
| `fvm flutter gen-l10n` | Regenerate localization after editing an `.arb` file |
| `fvm flutter build apk` and `fvm flutter build ios` | Release builds |

If a Dart MCP server is available in your session, prefer its analyze, test, format, and pub tools over the shell equivalents.

## Before you commit

Read your own change critically. Does it respect the layer boundaries and keep features isolated? Then run `fvm flutter analyze`, apply `dart format`, run the tests, and write the single-line commit message.

## Agent skills

**Issue tracker.** Issues are markdown files in [.scratch](.scratch/), committed to git. One directory per feature, one file per ticket. There is no external tracker. See [docs/agents/issue-tracker.md](docs/agents/issue-tracker.md).

**Triage labels.** The five standard labels, used as written: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See [docs/agents/triage-labels.md](docs/agents/triage-labels.md).

**Domain docs.** Read the backend repository's `CONTEXT.md` and `docs/agents/ARCHITECTURE.md` before exploring. See [docs/agents/domain.md](docs/agents/domain.md).

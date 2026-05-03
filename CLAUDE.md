# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Smart Chef is a Flutter mobile app (Android + iOS) — an AI-powered recipe manager with Hebrew UI (RTL layout, `he_IL` locale). It uses Firebase for auth/database and Google Gemini AI for recipe extraction and meal planning.

## Common Commands

| Task | Command |
|---|---|
| Get dependencies | `flutter pub get` |
| Run app | `flutter run` |
| Build APK | `flutter build apk` |
| Run all tests | `flutter test` |
| Run single test file | `flutter test test/unit/scaling_service_test.dart` |
| Lint / analyze | `flutter analyze` |
| Code generation (Freezed, Riverpod, JSON) | `dart run build_runner build --delete-conflicting-outputs` |
| Code generation (watch) | `dart run build_runner watch --delete-conflicting-outputs` |

**Important:** After modifying any Freezed model or Riverpod annotated provider, run code generation before testing or building.

## Architecture

### State Management
Riverpod 3.x with code generation (`@riverpod` annotations). Generated files use `*.g.dart` and `*.freezed.dart` suffixes. Models use Freezed + `json_serializable` with `explicit_to_json: true` (configured in `build.yaml`).

### Feature Structure (`lib/features/`)
Each feature follows: `models/`, `repositories/`, `providers/`, `services/`, `screens/`, `widgets/`.

- **auth** — Firebase Email/Password auth. `AuthRepository` wraps `FirebaseAuth`. `authStateProvider` streams auth state and controls GoRouter redirects.
- **recipes** — Full CRUD with Firestore. Includes serving scaling, unit conversion (volume↔weight with density table), cook mode (step-by-step with timers + Hebrew voice commands), version history (auto-snapshot before each update), and shopping list generation.
- **ingestion** — AI recipe import pipeline. Accepts text, images, PDFs, or URLs. `GeminiService` extracts structured recipe data via `firebase_ai` and returns Hebrew-normalized JSON. `UrlScraperService` tries Schema.org JSON-LD first, falls back to cleaned HTML. State machine: Idle → Loading → Preview → Saving → Done.
- **planner** — Meal planner with AI timeline orchestration. `OrchestratorService` calls Gemini to schedule recipe steps so all dishes finish at the target meal time, respecting active/passive time and atomic blocks.

### Core (`lib/core/`)
- `router/` — GoRouter with auth-guarded routes. `MainShell` provides bottom navigation (recipes tab, planner tab).
- `constants/` — App config (Gemini model name, Cloudinary config, Firestore collection names).
- `errors/` — Typed exception hierarchy: `AppException` base with `AuthException`, `RecipeException`, `IngestionException`, `PlannerException`, `VersionException`.
- `theme/` — Material 3 theme with deep green primary, amber secondary.

### Shared (`lib/shared/`)
Reusable Freezed models (`CookStepModel`, `IngredientModel`, `UnitType` enum) and common widgets.

### Firestore Data Model
```
users/{userId}/
  recipes/{recipeId}              → RecipeModel
    versions/{versionId}          → RecipeVersionModel (auto-created snapshots)
  daily_plans/{planId}            → DailyPlanModel (meal time, recipes, AI timeline)
```
Security rules: users can only access their own data under `/users/{userId}/`.

### Routing
```
/login → LoginScreen (unauth only)
/recipes → RecipeListScreen (tab 0)
/recipes/:id → RecipeDetailScreen
/recipes/:id/edit → RecipeEditScreen
/recipes/:id/cook → CookModeScreen
/recipes/:id/versions → RecipeVersionsScreen
/planner → OrchestratorScreen (tab 1)
/ingest → IngestionScreen (from FAB)
```

## Key External Services

- **Firebase Auth** — email/password authentication
- **Cloud Firestore** — primary database
- **Firebase AI (Gemini)** — `gemini-3-flash-preview` model via `firebase_ai` package for recipe extraction and timeline orchestration
- **Cloudinary** — image uploads via HTTP multipart POST
- **Syncfusion PDF** — PDF text extraction for recipe import
- **speech_to_text** — Hebrew voice commands in cook mode

## Conventions

- All user-facing text is in Hebrew
- Dart SDK constraint: `>=3.8.0 <4.0.0`
- Linting: `package:flutter_lints/flutter.yaml`
- Tests are in `test/unit/` and `test/widget/`; Mockito is used for mocking services

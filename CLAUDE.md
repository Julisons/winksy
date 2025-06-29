# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

**Flutter Development:**
- `flutter pub get` - Install dependencies
- `flutter run` - Run app in debug mode  
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter analyze` - Run static analysis
- `flutter test` - Run unit tests

**Linting and Code Quality:**
- Uses `flutter_lints` package for code quality
- Analysis configuration in `analysis_options.yaml`
- Follow standard Flutter linting rules

## Project Architecture

**Winksy** is a Flutter-based social gaming app with dating features. The app combines social interaction, gaming, and matchmaking functionality.

### Core Structure

**Main App Flow:**
- Entry point: `lib/main.dart` (currently configured for chess-only mode)
- Main dashboard: `lib/screen/dashboard/dashboard.dart` - Tab-based navigation
- Theme management: `lib/provider/theme_provider.dart` - Light/dark theme switching

**Key Features:**
1. **Social/Dating Platform** - User profiles, matching, messaging
2. **Gaming Hub** - Multiple games including Chess, Ludo, Tic-tac-toe, Quadrix, Spinner
3. **Virtual Pet System** - Pet ownership, ranking, wishes
4. **Social Features** - Friends, chat, notifications, treats/gifts

### Directory Organization

**Models (`lib/model/`):**
- Core data structures: User, Chat, Message, Friend, Pet, etc.
- Game models: Quad, Spinner
- Payment models: Invoice, Transaction, Payment

**Screens (`lib/screen/`):**
- `dashboard/` - Main app navigation
- `authenticate/` - Login, signup, social auth
- `account/` - Profile management, settings
- `people/` - User discovery
- `interest/` - Matching system (likes, matches)
- `message/` - Chat functionality
- `zoo/` - Virtual pet system
- `notification/` - Push notifications

**Games (`lib/games/`):**
- `chess/` - Chess game with AI
- `chesa/` - Advanced chess engine with themes
- `ludo/` - Ludo board game with multiplayer
- `quadrix/` - Connect Four variant with AI
- `tic_tac_toe/` - Classic tic-tac-toe
- `spinner/` - Fortune wheel game
- `setting/` - Game settings

**Components (`lib/component/`):**
- Reusable UI components and widgets
- Glass morphism effects, animations, loaders

### Key Dependencies

**Core Flutter:**
- `flutter_screenutil` - Responsive design
- `provider` - State management
- `google_fonts` - Typography

**UI/UX:**
- `persistent_bottom_nav_bar` - Navigation
- `shimmer` - Loading animations
- Glass morphism components for modern UI

**Social Features:**
- `socket_io_client` - Real-time messaging
- `firebase_core`, `firebase_messaging` - Push notifications
- `google_sign_in` - Social authentication

**Gaming:**
- `flame` - Game engine for some games
- Custom game logic in respective directories

**Media/Camera:**
- `camera`, `image_picker`, `image_cropper` - Photo handling
- `google_mlkit_face_detection` - Face detection features

### State Management

- Uses `Provider` pattern for theme management
- Individual game states managed within respective game directories
- Socket.io for real-time features

### Important Notes

- **Main Entry:** Currently set to chess-only mode in `main.dart` - may need modification for full app functionality
- **Multi-platform:** Supports Android, iOS, Web, Windows, macOS, Linux
- **Real-time Features:** Socket.io integration for live chat and gaming
- **Firebase Integration:** Push notifications and potentially other Firebase services
- **Game Engine:** Mix of Flutter widgets and Flame engine for different games
- **Theme System:** Custom light/dark theme implementation with glass morphism effects

### Development Workflow

1. Use `flutter pub get` after any dependency changes
2. Run `flutter analyze` before committing changes  
3. Test on multiple platforms if making UI changes
4. Games have individual promotion/dashboard screens - follow existing patterns
5. Use existing component library for consistent UI
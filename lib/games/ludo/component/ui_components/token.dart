import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../../state/game_state.dart';
import '../../ludo.dart';
import '../../state/token_manager.dart';
import '../../../../mixin/mixins.dart';

// Enum to define token states
enum TokenState {
  inBase,
  onBoard,
  inHome,
}

class Token extends PositionComponent with TapCallbacks {
  final String tokenId; // Mandatory unique ID for the token
  String playerId; // Store only the player ID
  bool enableToken; // Store the enableToken state directly
  String positionId; // Mandatory position ID for the token
  TokenState state; // Current state of the token

  Color topColor;
  Color sideColor;

  bool _shouldDrawCircle = false; // Flag to control circle rendering and animation
  double _circleScale = 1.0;
  Timer? _circleAnimationTimer; //

  Token({
    required this.tokenId, // Mandatory unique ID for the token
    required this.positionId, // Mandatory position ID for the token
    required Vector2 position, // Initial position of the token
    required Vector2 size, // Size of the token
    required this.playerId, // Initialize playerId
    this.enableToken = false, // Initialize enableToken
    this.state = TokenState.inBase, // Default state
    required this.topColor,
    required this.sideColor,
  }) : super(position: position, size: size);

  bool isInBase() => state == TokenState.inBase;
  bool isOnBoard() => state == TokenState.onBoard;
  bool isInHome() => state == TokenState.inHome;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Define the radius of the outer circle
    final outerRadius = size.x / 2;
    final sideOuterRadius = size.x / 1.9;

    // Define the radius of the smaller inner circle
    final smallerCircle = outerRadius / 2.5; // Radius of the smaller circle
    final smallerCircleDepth = smallerCircle * 0.90;

    // Define the center of the circles
    final center = Offset(size.x / 2, size.y / 2);
    final centerShadow = Offset(size.x / 2, size.y / 1.70);
    final tokenShadow = Offset(size.x / 2, size.y / 1.5);
    final smallerCircleShadow = Offset(size.x / 2, size.y / 1.75);

    // Check if this token belongs to the current user
    final isOwnToken = _doesCurrentUserOwnPlayer(playerId);
    
    // Apply visual styling based on ownership
    final double opacity = isOwnToken ? 1.0 : 0.6; // Dim opponent tokens
    final Color borderColor = isOwnToken ? topColor : topColor.withOpacity(0.7);
    final Color innerColor = isOwnToken ? Colors.white : Colors.grey.shade300;

    canvas.drawCircle(tokenShadow, outerRadius,
        Paint()..color = const Color(0xFF3C3D37).withOpacity(0.6));
    canvas.drawCircle(centerShadow, sideOuterRadius,
        Paint()..color = sideColor.withOpacity(opacity)); // Draw outer circle

    canvas.drawCircle(
        center, outerRadius, Paint()..color = borderColor); // Draw border

    canvas.drawCircle(smallerCircleShadow, smallerCircleDepth,
        Paint()..color = const Color(0xFF3C3D37).withOpacity(0.7));
    canvas.drawCircle(center, smallerCircle, Paint()..color = innerColor);

    // Add a subtle lock icon or X for opponent tokens
    if (!isOwnToken) {
      _renderOpponentIndicator(canvas, center, smallerCircle);
    }

    // Conditionally render the circle around the token
    if (_shouldDrawCircle) {
      _renderCircleAroundToken(canvas);
    }
  }

  void _renderCircleAroundToken(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 1.8);

    final paint = Paint()
      ..color = Colors.black.withOpacity(0.4) // Blue color with transparency
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    // Scale the circle based on _circleScale
    final scaledRadius = (size.x / 2) * _circleScale;
    canvas.drawCircle(center, scaledRadius, paint);
  }

  // Render a visual indicator on opponent tokens to show they can't be controlled
  void _renderOpponentIndicator(Canvas canvas, Offset center, double radius) {
    // Draw a subtle lock icon using simple shapes
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final lockSize = radius * 0.6;
    final lockCenter = center;
    
    // Draw lock body (rectangle)
    final lockBody = Rect.fromCenter(
      center: Offset(lockCenter.dx, lockCenter.dy + lockSize * 0.15),
      width: lockSize * 0.8,
      height: lockSize * 0.6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(lockBody, Radius.circular(lockSize * 0.1)),
      paint..style = PaintingStyle.fill
    );
    
    // Draw lock shackle (arc)
    final shackleRect = Rect.fromCenter(
      center: Offset(lockCenter.dx, lockCenter.dy - lockSize * 0.1),
      width: lockSize * 0.5,
      height: lockSize * 0.4,
    );
    canvas.drawArc(
      shackleRect,
      -3.14159, // Start from top (pi radians)
      3.14159,  // Sweep pi radians (half circle)
      false,    // Don't use center
      paint..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
  }

  // Enable circle rendering and animation
  void enableCircleAnimation() {
    if (_shouldDrawCircle) return; // Already active, do nothing

    _shouldDrawCircle = true;

    // Start a timer to simulate the scale effect
    _circleAnimationTimer = Timer(
      0.070, // Frame interval
      onTick: () {
        _circleScale += 0.05; // Increase scale
        if (_circleScale >= 2) {
          _circleScale = 1.0; // Reset scale
        }
      },
      repeat: true,
    )..start();
  }

  // Disable circle rendering and animation
  void disableCircleAnimation() {
    _shouldDrawCircle = false;

    // Stop the animation timer
    _circleAnimationTimer?.stop();
    _circleAnimationTimer = null;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the timer for the animation
    _circleAnimationTimer?.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) async {
    super.onTapDown(event);

    final world = parent?.parent;

    if (!spaceToMove() ||
        !enableToken ||
        world is! World ||
        (isInBase() && GameState().diceNumber != 6) ||
        isInHome()) return;

    // Check if the current user owns this player/token
    if (!_doesCurrentUserOwnPlayer(playerId)) {
      print('You cannot move ${playerId} tokens! You can only control your own player.');
      return;
    }

    // Check if it's this player's turn
    if (GameState().currentPlayer.playerId != playerId) return;

    enableToken = false;

    final tokens = TokenManager().allTokens;
    for (var token in tokens) {
      token.disableCircleAnimation();
      token.enableToken = false;
    }

    if (GameState().diceNumber == 6) {
      // Handle movement logic
      if (state == TokenState.inBase && GameState().canMoveTokenFromBase) {
        moveOutOfBase(
            world: world,
            token: this,
            tokenPath: GameState().getTokenPath(playerId));
        // Consider reducing delay or making it conditional
      } else if (state == TokenState.onBoard &&
          GameState().canMoveTokenOnBoard) {
        moveForward(
            world: world,
            token: this,
            tokenPath: GameState().getTokenPath(playerId),
            diceNumber: GameState().diceNumber);
      }
      return;
    }

    // Non-six logic
    if (state == TokenState.onBoard && GameState().canMoveTokenOnBoard) {
      moveForward(
          world: world,
          token: this,
          tokenPath: GameState().getTokenPath(playerId),
          diceNumber: GameState().diceNumber);
    }
  }

  bool spaceToMove() {
    final tokenPath = GameState().getTokenPath(playerId);
    final index = tokenPath.indexOf(positionId);
    final newIndex = index + GameState().diceNumber;

    return newIndex < tokenPath.length;
  }

  // Helper function to check if the current user owns a specific player
  bool _doesCurrentUserOwnPlayer(String playerId) {
    if (Mixin.quad?.quadType == 'AI_MODE') {
      // In AI mode, user only owns BP (Blue Player)
      return playerId == 'BP';
    }
    
    // In multiplayer mode, check which player this user controls
    if (Mixin.user?.usrId?.toString() == Mixin.quad?.quadUsrId?.toString()) {
      // This user created the game, they are BP (Blue Player)
      return playerId == 'BP';
    } else if (Mixin.user?.usrId?.toString() == Mixin.quad?.quadAgainstId?.toString()) {
      // This user joined the game, they are RP (Red Player)  
      return playerId == 'RP';
    }
    
    return false; // User is not part of this game or invalid player
  }
}

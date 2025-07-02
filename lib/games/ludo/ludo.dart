import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:math' as math;

import '../../mixin/mixins.dart';
import '../../model/quad.dart' as Q;
import 'state/player.dart';
import 'component/home/home.dart';
import 'state/token_manager.dart';
import 'state/event_bus.dart';
import 'component/home/home_spot.dart';
import 'state/game_state.dart';
import 'state/audio_manager.dart';
import 'component/controller/upper_controller.dart';
import 'component/controller/lower_controller.dart';
import 'ludo_board.dart';
import 'component/ui_components/token.dart';
import 'component/ui_components/spot.dart';
import 'component/ui_components/ludo_dice.dart';
import 'component/ui_components/rank_modal_component.dart';

class Ludo extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
  List<String> teams;
  final BuildContext context;
  static Ludo? _instance;

  // Add an unnamed constructor
  Ludo(this.teams, this.context) {
    _instance = this;
  }

  // Public getter for the instance
  static Ludo? get instance => _instance;

  final rand = Random();
  double get width => size.x;
  double get height => size.y;

  ColorEffect? _greenBlinkEffect;
  ColorEffect? _greenStaticEffect;

  ColorEffect? _blueBlinkEffect;
  ColorEffect? _blueStaticEffect;

  ColorEffect? _yellowBlinkEffect;
  ColorEffect? _yellowStaticEffect;

  ColorEffect? _redBlinkEffect;
  ColorEffect? _redStaticEffect;

  @override
  void onLoad() async {
    super.onLoad();
    _remotePlay();
    _initializeMultiplayerTurns();

    camera = CameraComponent.withFixedResolution(
      width: width,
      height: height,
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(UpperController(
        position: Vector2(0, width * 0.05),
        width: width,
        height: width * 0.20));
    world.add(LudoBoard(
        width: width, height: width, position: Vector2(0, height * 0.175)));
    world.add(LowerController(
        position: Vector2(0, width + (width * 0.35)),
        width: width,
        height: width * 0.20));

    /*
    add(FpsTextComponent(
      position: Vector2(10, 10), // Adjust position as needed
      anchor: Anchor.topLeft, // Set anchor to align top-left
    ));
    */

    GameState().ludoBoard = world.children.whereType<LudoBoard>().first;
    final ludoBoard = GameState().ludoBoard as PositionComponent;
    GameState().ludoBoardAbsolutePosition = ludoBoard.absolutePosition;

    EventBus().on<OpenPlayerModalEvent>((event) {
      showPlayerModal();
    });

    EventBus().on<SwitchPointerEvent>((event) {
      switchOffPointer();
    });

    EventBus().on<BlinkGreenBaseEvent>((event) {
      blinkGreenBase(true);
      blinkBlueBase(false);
      blinkRedBase(false);
      blinkYellowBase(false);
    });

    EventBus().on<BlinkBlueBaseEvent>((event) {
      blinkBlueBase(true);
      blinkGreenBase(false);
      blinkRedBase(false);
      blinkYellowBase(false);
    });

    EventBus().on<BlinkRedBaseEvent>((event) {
      blinkRedBase(true);
      blinkGreenBase(false);
      blinkBlueBase(false);
      blinkYellowBase(false);
    });

    EventBus().on<BlinkYellowBaseEvent>((event) {
      blinkYellowBase(true);
      blinkGreenBase(false);
      blinkBlueBase(false);
      blinkRedBase(false);
    });

    EventBus().on<AITurnEvent>((event) {
      _triggerAITurn();
    });

    await startGame();
  }

  late Q.Quad _quad = Q.Quad();

  void _remotePlay(){
    Mixin.quadrixSocket?.on('play', (message) async {
      print(jsonEncode(message));
      _quad = Q.Quad.fromJson(message);

      /**
       * THIS MOVE IS FROM ME, SO JUST IGNORE
       */
      if(Mixin.user?.usrId.toString() == _quad.quadUsrId.toString()) {
        return;
      }

      debugPrint('------ROLLING THE DICE----');
      callRollDice();

      if(Mixin.user?.usrId.toString() == _quad.quadPlayerId.toString()) {
       // quadPlayer = 'Your turn';
        //_startTimer();
      }else {
        //quadPlayer = '${_quad.quadPlayer}\'s turn';
      }
    });

    // Listen for token moves from other players
    Mixin.quadrixSocket?.on('token_move', (message) async {
      print('Received token move: ${jsonEncode(message)}');
      
      // Only process moves from AI mode or from other real players
      if (Mixin.quad?.quadType == 'AI_MODE') {
        return; // In AI mode, no remote moves needed
      }
      
      // Parse the move data
      final moveData = message as Map<String, dynamic>;
      final tokenId = moveData['quadTokenId'] as String;
      final playerId = moveData['quadPlayerId'] as String; // This is the user UUID
      final newPositionId = moveData['quadNewPositionId'] as String;
      final moveType = moveData['quadMoveType'] as String;
      final diceValue = moveData['quadDiceValue'] as int;
      
      // Session-based validation: Ensure the move is from a legitimate player
      if (playerId == null || playerId.isEmpty) {
        print('Invalid token move: missing player ID');
        return;
      }
      
      // Validate that the move sender is actually part of this game
      if (playerId != Mixin.quad?.quadUsrId?.toString() && 
          playerId != Mixin.quad?.quadAgainstId?.toString()) {
        print('Unauthorized token move from user: $playerId');
        return;
      }
      
      // Don't process moves from ourselves
      if (playerId == Mixin.user?.usrId?.toString()) {
        print('Ignoring token move from ourselves');
        return;
      }
      
      // Find the token that needs to be moved by tokenId only
      // Note: playerId here is the user UUID, not the token's playerId (BP, RP, etc.)
      final token = TokenManager().allTokens.firstWhere(
        (t) => t.tokenId == tokenId,
        orElse: () => throw Exception('Token not found: $tokenId'),
      );
      
      // Apply the move locally
      token.positionId = newPositionId;
      
      // Apply visual movement effect
      await _applyEffect(
        token,
        MoveToEffect(
          SpotManager()
              .getSpots()
              .firstWhere((spot) => spot.uniqueId == token.positionId)
              .tokenPosition,
          EffectController(duration: 0.3, curve: Curves.easeInOut),
        ),
      );
      
      // Update token state based on move type
      if (moveType == 'moveOutOfBase') {
        token.state = TokenState.onBoard;
      }
      
      // Handle collision and resizing
      tokenCollision(world, token);
      resizeTokensOnSpot(world);
    });

    // Listen for turn switches from other players
    Mixin.quadrixSocket?.on('turn_switch', (message) async {
      print('Received turn switch: ${jsonEncode(message)}');
      
      // Only process turn switches in multiplayer mode
      if (Mixin.quad?.quadType == 'AI_MODE') {
        return;
      }
      
      // Parse turn switch data
      final turnData = message as Map<String, dynamic>;
      final nextPlayerIndex = turnData['nextPlayerIndex'] as int;
      final senderUserId = turnData['quadUsrId'] as String?;
      final currentPlayerId = turnData['currentPlayerId'] as String?;
      
      // Session-based validation: Ensure the turn switch is from a legitimate player
      if (senderUserId == null || currentPlayerId == null) {
        print('Invalid turn switch: missing sender or current player ID');
        return;
      }
      
      // Validate that the sender is actually part of this game
      if (senderUserId != Mixin.quad?.quadUsrId?.toString() && 
          senderUserId != Mixin.quad?.quadAgainstId?.toString()) {
        print('Unauthorized turn switch from user: $senderUserId');
        return;
      }
      
      // In multiplayer mode, process turn switches from all legitimate players
      // including ourselves to ensure synchronization
      
      // Safety check for empty players list
      if (GameState().players.isEmpty) {
        print('Players list is empty, cannot process turn switch');
        return;
      }
      
      // Safety check for valid next player index
      if (nextPlayerIndex >= GameState().players.length) {
        print('Invalid next player index: $nextPlayerIndex, max: ${GameState().players.length - 1}');
        return;
      }
      
      // Get the user's player ID to check if it's their turn
      final userPlayerId = _getCurrentUserPlayerId();
      if (userPlayerId == null) return;
      
      // Disable all players first
      for (var player in GameState().players) {
        player.enableDice = false;
        player.isCurrentTurn = false;
        
        // Disable all tokens
        for (var token in player.tokens) {
          token.enableToken = false;
        }
      }
      
      // Enable the current turn player
      final currentPlayer = GameState().players[nextPlayerIndex];
      if (currentPlayer.playerId == userPlayerId) {
        currentPlayer.enableDice = true;
        currentPlayer.isCurrentTurn = true;
        print('It\'s your turn! You are playing as ${userPlayerId}');
      } else {
        print('Waiting for ${currentPlayer.playerId} to play...');
      }
      
      // Update the current player index
      GameState().currentPlayerIndex = nextPlayerIndex;
      
      print('Turn switched to player: ${currentPlayer.playerId}');
    });
  }

  void _triggerAITurn() {
    if (Mixin.quad?.quadType != 'AI_MODE') return;
    
    final currentPlayer = GameState().currentPlayer;
    if (currentPlayer.playerId == 'RP') { // AI player is red
      Future.delayed(Duration(milliseconds: 1000), () {
        _performAIMove();
      });
    }
  }

  void _performAIMove() {
    final currentPlayer = GameState().currentPlayer;
    if (currentPlayer.playerId != 'RP' || !currentPlayer.enableDice) return;

    // Find the appropriate dice for AI player (Red - upper left)
    final upperController = world.children.whereType<UpperController>().first;
    final upperControllerComponents = upperController.children.toList();
    final leftDice = upperControllerComponents[0]
        .children
        .whereType<RectangleComponent>()
        .first;
    final rightDiceContainer = leftDice.children.whereType<RectangleComponent>().first;
    final ludoDice = rightDiceContainer.children.whereType<LudoDice>().firstOrNull;

    if (ludoDice != null) {
      _aiRollDice(ludoDice);
    }
  }

  void _aiRollDice(LudoDice dice) async {
    final player = GameState().currentPlayer;
    if (!player.enableDice || !player.isCurrentTurn) return;

    GameState().hidePointer();
    player.enableDice = false;

    // AI rolls dice
    GameState().diceNumber = Random().nextInt(6) + 1;
    dice.diceFace.updateDiceValue(GameState().diceNumber);

    // Apply dice rotation effect
    dice.add(
      RotateEffect.by(
        math.pi * 2, // Full 360-degree rotation (2π radians)
        EffectController(
          duration: 0.3,
          curve: Curves.linear,
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    final world = this.world;
    final diceNumber = GameState().diceNumber;

    if (diceNumber == 6) {
      _aiHandleSixRoll(world, GameState().ludoBoard as LudoBoard, diceNumber, player);
    } else {
      _aiHandleNonSixRoll(world, GameState().ludoBoard as LudoBoard, diceNumber, player);
    }
  }

  void _aiHandleSixRoll(World world, LudoBoard ludoBoard, int diceNumber, Player player) {
    player.grantAnotherTurn();

    if (player.hasRolledThreeConsecutiveSixes()) {
      GameState().switchToNextPlayer();
      return;
    }

    final tokensInBase = player.tokens
        .where((token) => token.state == TokenState.inBase)
        .toList();
    final tokensOnBoard = player.tokens
        .where((token) => token.state == TokenState.onBoard)
        .toList();
    final movableTokens = tokensOnBoard.where((token) => token.spaceToMove()).toList();

    final allMovableTokens = [...movableTokens, ...tokensInBase];

    if (allMovableTokens.isEmpty) {
      GameState().switchToNextPlayer();
      return;
    }

    String difficulty = Mixin.quad?.quadDesc ?? 'Medium';
    Token? selectedToken = _aiSelectToken(tokensInBase, movableTokens, diceNumber, difficulty);

    if (selectedToken != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (selectedToken.state == TokenState.inBase) {
          moveOutOfBase(
            world: world,
            token: selectedToken,
            tokenPath: GameState().getTokenPath(player.playerId),
          );
        } else {
          moveForward(
            world: world,
            token: selectedToken,
            tokenPath: GameState().getTokenPath(player.playerId),
            diceNumber: diceNumber,
          );
        }
      });
    } else {
      GameState().switchToNextPlayer();
    }
  }

  void _aiHandleNonSixRoll(World world, LudoBoard ludoBoard, int diceNumber, Player player) {
    final tokensOnBoard = player.tokens
        .where((token) => token.state == TokenState.onBoard)
        .toList();

    if (tokensOnBoard.isEmpty) {
      GameState().switchToNextPlayer();
      return;
    }

    final movableTokens = tokensOnBoard.where((token) => token.spaceToMove()).toList();

    if (movableTokens.isEmpty) {
      GameState().switchToNextPlayer();
      return;
    }

    String difficulty = Mixin.quad?.quadDesc ?? 'Medium';
    Token? selectedToken = _aiSelectToken([], movableTokens, diceNumber, difficulty);

    if (selectedToken != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        moveForward(
          world: world,
          token: selectedToken,
          tokenPath: GameState().getTokenPath(player.playerId),
          diceNumber: diceNumber,
        );
      });
    } else {
      GameState().switchToNextPlayer();
    }
  }

  Token? _aiSelectToken(List<Token> tokensInBase, List<Token> movableTokens, int diceNumber, String difficulty) {
    List<Token> allOptions = [...tokensInBase, ...movableTokens];
    if (allOptions.isEmpty) return null;

    switch (difficulty) {
      case 'Easy':
        return _aiSelectTokenEasy(allOptions);
      case 'Medium':
        return _aiSelectTokenMedium(allOptions, diceNumber);
      case 'Hard':
        return _aiSelectTokenHard(allOptions, diceNumber);
      default:
        return _aiSelectTokenMedium(allOptions, diceNumber);
    }
  }

  Token? _aiSelectTokenEasy(List<Token> tokens) {
    // Easy: Random selection with slight preference for tokens closer to home
    if (tokens.isEmpty) return null;
    final random = Random();
    return tokens[random.nextInt(tokens.length)];
  }

  Token? _aiSelectTokenMedium(List<Token> tokens, int diceNumber) {
    if (tokens.isEmpty) return null;

    // Medium: Prioritize tokens that can attack opponents or advance safely
    final playerTokens = GameState().players
        .where((p) => p.playerId != 'RP')
        .expand((p) => p.tokens)
        .where((t) => t.state == TokenState.onBoard)
        .toList();

    // Check for attack opportunities
    for (var token in tokens) {
      if (token.state == TokenState.onBoard) {
        final tokenPath = GameState().getTokenPath('RP');
        final currentIndex = tokenPath.indexOf(token.positionId);
        if (currentIndex >= 0 && currentIndex + diceNumber < tokenPath.length) {
          final newPositionId = tokenPath[currentIndex + diceNumber];
          
          // Check if we can attack an opponent
          Token? opponentAtPosition;
          try {
            opponentAtPosition = playerTokens.firstWhere(
              (t) => t.positionId == newPositionId,
            );
          } catch (e) {
            opponentAtPosition = null;
          }
          
          if (opponentAtPosition != null && opponentAtPosition.positionId.isNotEmpty && 
              !['B04', 'B23', 'R22', 'R10', 'G02', 'G21', 'Y30', 'Y42'].contains(newPositionId)) {
            return token; // Attack opportunity
          }
        }
      }
    }

    // If no attack opportunity, prioritize tokens closest to home
    tokens.sort((a, b) {
      if (a.state == TokenState.inBase && b.state != TokenState.inBase) return 1;
      if (b.state == TokenState.inBase && a.state != TokenState.inBase) return -1;
      
      final pathA = GameState().getTokenPath('RP');
      final pathB = GameState().getTokenPath('RP');
      final indexA = pathA.indexOf(a.positionId);
      final indexB = pathB.indexOf(b.positionId);
      
      return indexB.compareTo(indexA); // Higher index = closer to home
    });

    return tokens.first;
  }

  Token? _aiSelectTokenHard(List<Token> tokens, int diceNumber) {
    if (tokens.isEmpty) return null;

    // Hard: Advanced strategy considering multiple factors
    final playerTokens = GameState().players
        .where((p) => p.playerId != 'RP')
        .expand((p) => p.tokens)
        .where((t) => t.state == TokenState.onBoard)
        .toList();

    int scoreToken(Token token) {
      int score = 0;
      
      if (token.state == TokenState.inBase) {
        score += 50; // Prioritize getting tokens out
        return score;
      }

      final tokenPath = GameState().getTokenPath('RP');
      final currentIndex = tokenPath.indexOf(token.positionId);
      
      if (currentIndex >= 0 && currentIndex + diceNumber < tokenPath.length) {
        final newPositionId = tokenPath[currentIndex + diceNumber];
        
        // Check for attack opportunities
        Token? opponentAtPosition;
        try {
          opponentAtPosition = playerTokens.firstWhere(
            (t) => t.positionId == newPositionId,
          );
        } catch (e) {
          opponentAtPosition = null;
        }
        
        if (opponentAtPosition != null && opponentAtPosition.positionId.isNotEmpty && 
            !['B04', 'B23', 'R22', 'R10', 'G02', 'G21', 'Y30', 'Y42'].contains(newPositionId)) {
          score += 100; // High priority for attacks
        }

        // Prefer moving tokens closer to home
        score += currentIndex;

        // Avoid landing on safe spots where opponents can't be attacked
        if (['B04', 'B23', 'R22', 'R10', 'G02', 'G21', 'Y30', 'Y42'].contains(newPositionId)) {
          score -= 20;
        }

        // Check if moving puts us in danger
        for (var opponent in playerTokens) {
          final opponentPath = GameState().getTokenPath(opponent.playerId);
          final opponentIndex = opponentPath.indexOf(opponent.positionId);
          
          // Check if opponent can reach our new position with any dice roll (1-6)
          for (int roll = 1; roll <= 6; roll++) {
            if (opponentIndex + roll < opponentPath.length && 
                opponentPath[opponentIndex + roll] == newPositionId &&
                !['B04', 'B23', 'R22', 'R10', 'G02', 'G21', 'Y30', 'Y42'].contains(newPositionId)) {
              score -= 30; // Penalty for danger
              break;
            }
          }
        }
      }
      
      return score;
    }

    tokens.sort((a, b) => scoreToken(b).compareTo(scoreToken(a)));
    return tokens.first;
  }

  // In your Ludo class
  void callRollDice() {
    // Get the current player
    final currentPlayer = GameState().currentPlayer;

    // Find the appropriate controller based on player
    if (currentPlayer.playerId == 'BP') {
      // Blue player - lower left dice
      final lowerController = world.children.whereType<LowerController>().first;
      final lowerControllerComponents = lowerController.children.toList();
      final leftDice = lowerControllerComponents[0]
          .children
          .whereType<RectangleComponent>()
          .first;
      final leftDiceContainer = leftDice.children.whereType<RectangleComponent>().first;
      final ludoDice = leftDiceContainer.children.whereType<LudoDice>().firstOrNull;

      ludoDice?.rollDice();
    } else if (currentPlayer.playerId == 'GP') {
      // Green player - upper right dice
      final upperController = world.children.whereType<UpperController>().first;
      final upperControllerComponents = upperController.children.toList();
      final rightDice = upperControllerComponents[2]
          .children
          .whereType<RectangleComponent>()
          .first;
      final rightDiceContainer = rightDice.children.whereType<RectangleComponent>().first;
      final ludoDice = rightDiceContainer.children.whereType<LudoDice>().firstOrNull;

      ludoDice?.rollDice();
    } else if (currentPlayer.playerId == 'YP') {
      // Yellow player - lower right dice
      final lowerController = world.children.whereType<LowerController>().first;
      final lowerControllerComponents = lowerController.children.toList();
      final rightDice = lowerControllerComponents[2]
          .children
          .whereType<RectangleComponent>()
          .first;
      final rightDiceContainer = rightDice.children.whereType<RectangleComponent>().first;
      final ludoDice = rightDiceContainer.children.whereType<LudoDice>().firstOrNull;

      ludoDice?.rollDice();
    } else if (currentPlayer.playerId == 'RP') {
      // Red player - upper left dice
      final upperController = world.children.whereType<UpperController>().first;
      final upperControllerComponents = upperController.children.toList();
      final leftDice = upperControllerComponents[0]
          .children
          .whereType<RectangleComponent>()
          .first;
      final rightDiceContainer = leftDice.children.whereType<RectangleComponent>().first;
      final ludoDice = rightDiceContainer.children.whereType<LudoDice>().firstOrNull;

      ludoDice?.rollDice();
    }
  }

  void switchOffPointer() {
    final player = GameState().players[GameState().currentPlayerIndex];
    final lowerController = world.children.whereType<LowerController>().first;
    lowerController.hidePointer(player.playerId);
    final upperController = world.children.whereType<UpperController>().first;
    upperController.hidePointer(player.playerId);
  }

  void blinkRedBase(bool shouldBlink) {
    final childrenOfLudoBoard = GameState().ludoBoard?.children.toList();
    final child = childrenOfLudoBoard![0];
    final home = child.children.toList();
    final homePlate = home[0] as Home;

    // Initialize effects if they haven't been created yet
    _redBlinkEffect ??= ColorEffect(
      const Color(0xffa3333d),
      EffectController(
        duration: 0.2,
        reverseDuration: 0.2,
        infinite: true,
        alternate: true,
      ),
    );

    _redStaticEffect ??= ColorEffect(
      GameState().red,
      EffectController(
        duration: 0.2,
        reverseDuration: 0.2,
        infinite: true,
        alternate: true,
      ),
    );

    // dice for player red
    final upperController = world.children.whereType<UpperController>().first;
    final upperControllerComponents = upperController.children.toList();
    final leftDice = upperControllerComponents[0]
        .children
        .whereType<RectangleComponent>()
        .first;

    final rightDiceContainer = leftDice.children.whereType<RectangleComponent>().first;

    // Add the appropriate effect based on shouldBlink
    homePlate.add(shouldBlink ? _redBlinkEffect! : _redStaticEffect!);

    if (shouldBlink) {
      final ludoDice = rightDiceContainer.children.whereType<LudoDice>().firstOrNull;
      if (ludoDice == null) {
        if (GameState().players.isNotEmpty) {
          final player = GameState().players[GameState().currentPlayerIndex];
          rightDiceContainer.add(LudoDice(
            player: GameState().players[GameState().currentPlayerIndex],
            faceSize: leftDice.size.x * 0.70,
          ));
          upperController.showPointer(player.playerId);
        }
      }
    } else {
      final ludoDice = rightDiceContainer.children.whereType<LudoDice>().firstOrNull;
      if (ludoDice != null) {
        rightDiceContainer.remove(ludoDice);
      }
    }
  }

  void blinkYellowBase(bool shouldBlink) {
    final childrenOfLudoBoard = GameState().ludoBoard?.children.toList();
    final child = childrenOfLudoBoard![8];
    final home = child.children.toList();
    final homePlate = home[0] as Home;

    // Initialize effects if they haven't been created yet
    _yellowBlinkEffect ??= ColorEffect(
      Colors.yellowAccent,
      EffectController(
        duration: 0.2,
        reverseDuration: 0.2,
        infinite: true,
        alternate: true,
      ),
    );

    _yellowStaticEffect ??= ColorEffect(
      GameState().yellow,
      EffectController(
        duration: 0.2,
        reverseDuration: 0.2,
        infinite: true,
        alternate: true,
      ),
    );

    final lowerController = world.children.whereType<LowerController>().first;
    final lowerControllerComponents = lowerController.children.toList();
    final rightDice = lowerControllerComponents[2]
        .children
        .whereType<RectangleComponent>()
        .first;

    final rightDiceContainer =
        rightDice.children.whereType<RectangleComponent>().first;

    // Add the appropriate effect based on shouldBlink
    homePlate.add(shouldBlink ? _yellowBlinkEffect! : _yellowStaticEffect!);

    if (shouldBlink) {
      final player = GameState().players[GameState().currentPlayerIndex];
      rightDiceContainer.add(LudoDice(
        player: player,
        faceSize: rightDice.size.x * 0.70,
      ));
      lowerController.showPointer(player.playerId);
    } else {
      final ludoDice =
          rightDiceContainer.children.whereType<LudoDice>().firstOrNull;
      if (ludoDice != null) {
        rightDiceContainer.remove(ludoDice);
      }
    }
  }

  void blinkBlueBase(bool shouldBlink) {
    final childrenOfLudoBoard = GameState().ludoBoard?.children.toList();
    final child = childrenOfLudoBoard![6];
    final home = child.children.toList();
    final homePlate = home[0] as Home;

    // Initialize effects if they haven't been created yet
    _blueBlinkEffect ??= ColorEffect(
      Colors.lightBlueAccent,
      EffectController(
        duration: 0.2,
        reverseDuration: 0.2,
        infinite: true,
        alternate: true,
      ),
    );

    _blueStaticEffect ??= ColorEffect(
      GameState().blue,
      EffectController(
        duration: 0.2,
        reverseDuration: 0.2,
        infinite: true,
        alternate: true,
      ),
    );

    // dice for player blue
    final lowerController = world.children.whereType<LowerController>().first;
    final lowerControllerComponents = lowerController.children.toList();
    final leftDice = lowerControllerComponents[0]
        .children
        .whereType<RectangleComponent>()
        .first;

    final leftDiceContainer =
        leftDice.children.whereType<RectangleComponent>().first;

    // Add the appropriate effect based on shouldBlink
    homePlate.add(shouldBlink ? _blueBlinkEffect! : _blueStaticEffect!);

    if (shouldBlink) {
      final ludoDice =
          leftDiceContainer.children.whereType<LudoDice>().firstOrNull;
      if (ludoDice == null) {
        if (GameState().players.isNotEmpty) {
          final player = GameState().players[GameState().currentPlayerIndex];
          leftDiceContainer.add(LudoDice(
            player: player,
            faceSize: leftDice.size.x * 0.70,
          ));
          lowerController.showPointer(player.playerId);
        }
      }
    } else {
      final ludoDice =
          leftDiceContainer.children.whereType<LudoDice>().firstOrNull;
      if (ludoDice != null) {
        leftDiceContainer.remove(ludoDice);
      }
    }
  }

  void blinkGreenBase(bool shouldBlink) {
    final childrenOfLudoBoard = GameState().ludoBoard?.children.toList();
    final child = childrenOfLudoBoard![2];
    final home = child.children.toList();
    final homePlate = home[0] as Home;

    // Initialize effects if they haven't been created yet
    _greenBlinkEffect ??= ColorEffect(
      Colors.lightGreenAccent,
      EffectController(
        duration: 0.2,
        reverseDuration: 0.2,
        infinite: true,
        alternate: true,
      ),
    );

    _greenStaticEffect ??= ColorEffect(
      GameState().green,
      EffectController(
        duration: 0.2,
        reverseDuration: 0.2,
        infinite: true,
        alternate: true,
      ),
    );

    // dice for player green
    final upperController = world.children.whereType<UpperController>().first;
    final upperControllerComponents = upperController.children.toList();
    final rightDice = upperControllerComponents[2]
        .children
        .whereType<RectangleComponent>()
        .first;

    final rightDiceContainer =
        rightDice.children.whereType<RectangleComponent>().first;

    // Add the appropriate effect based on shouldBlink
    homePlate.add(shouldBlink ? _greenBlinkEffect! : _greenStaticEffect!);

    if (shouldBlink) {
      final player = GameState().players[GameState().currentPlayerIndex];
      rightDiceContainer.add(LudoDice(
        player: GameState().players[GameState().currentPlayerIndex],
        faceSize: rightDice.size.x * 0.70,
      ));
      upperController.showPointer(player.playerId);
    } else {
      final ludoDice =
          rightDiceContainer.children.whereType<LudoDice>().firstOrNull;
      if (ludoDice != null) {
        rightDiceContainer.remove(ludoDice);
      }
    }
  }

  Future<void> startGame() async {
    await TokenManager().clearTokens();
    await GameState().clearPlayers();
    await AudioManager.dispose();

    AudioManager.initialize();

    for (var team in teams) {
      if (team == 'BP') {
        if (TokenManager().getBlueTokens().isEmpty) {
          TokenManager().initializeTokens(TokenManager().blueTokensBase);

          const homeSpotSizeFactorX = 0.10;
          const homeSpotSizeFactorY = 0.05;
          const tokenSizeFactorX = 0.80;
          const tokenSizeFactorY = 1.05;

          for (var token in TokenManager().getBlueTokens()) {
            final homeSpot = getHomeSpot(world, 6)
                .whereType<HomeSpot>()
                .firstWhere((spot) => spot.uniqueId == token.positionId);
            final spot = SpotManager().findSpotById(token.positionId);
            // update spot position
            spot.position = Vector2(
              homeSpot.absolutePosition.x +
                  (homeSpot.size.x * homeSpotSizeFactorX) -
                  GameState().ludoBoardAbsolutePosition.x,
              homeSpot.absolutePosition.y -
                  (homeSpot.size.x * homeSpotSizeFactorY) -
                  GameState().ludoBoardAbsolutePosition.y,
            );
            // update token position
            token.sideColor = const Color(0xFF0D92F4);
            token.topColor = const Color(0xFF77CDFF);

            token.position = spot.position;
            token.size = Vector2(
              homeSpot.size.x * tokenSizeFactorX,
              homeSpot.size.x * tokenSizeFactorY,
            );
            GameState().ludoBoard?.add(token);
          }

          const playerId = 'BP';
          // final tokens = TokenManager().getBlueTokens();

          if (GameState().players.isEmpty) {
            blinkBlueBase(true);
            Player bluePlayer = Player(
              playerId: playerId,
              tokens: TokenManager().getBlueTokens(),
              isCurrentTurn: true,
              enableDice: true,
            );
            GameState().players.add(bluePlayer);
            for (var token in TokenManager().getBlueTokens()) {
              token.playerId = bluePlayer.playerId;
              token.enableToken = true;
            }

            addDice() {
              // dice for player blue
              final lowerController =
                  world.children.whereType<LowerController>().first;
              final lowerControllerComponents =
                  lowerController.children.toList();
              final leftDice = lowerControllerComponents[0]
                  .children
                  .whereType<RectangleComponent>()
                  .first;

              final leftDiceContainer =
                  leftDice.children.whereType<RectangleComponent>().first;

              leftDiceContainer.add(LudoDice(
                player: bluePlayer,
                faceSize: leftDice.size.x * 0.70,
              ));
              lowerController.showPointer(bluePlayer.playerId);
            }

            addDice();
          } else {
            Player bluePlayer = Player(
              playerId: playerId,
              tokens: TokenManager().getBlueTokens(),
            );
            GameState().players.add(bluePlayer);
            for (var token in TokenManager().getBlueTokens()) {
              token.playerId = bluePlayer.playerId;
            }
          }
        }
      } else if (team == 'GP') {
        if (TokenManager().getGreenTokens().isEmpty) {
          TokenManager().initializeTokens(TokenManager().greenTokensBase);

          final ludoBoardPosition = GameState().ludoBoardAbsolutePosition;
          const homeSpotSizeFactorX = 0.10;
          const homeSpotSizeFactorY = 0.05;
          const tokenSizeFactorX = 0.80;
          const tokenSizeFactorY = 1.05;

          for (var token in TokenManager().getGreenTokens()) {
            final homeSpot = getHomeSpot(world, 2)
                .whereType<HomeSpot>()
                .firstWhere((spot) => spot.uniqueId == token.positionId);
            final spot = SpotManager().findSpotById(token.positionId);
            // update spot position
            spot.position = Vector2(
              homeSpot.absolutePosition.x +
                  (homeSpot.size.x * homeSpotSizeFactorX) -
                  ludoBoardPosition.x,
              homeSpot.absolutePosition.y -
                  (homeSpot.size.x * homeSpotSizeFactorY) -
                  ludoBoardPosition.y,
            );
            // update token position
            token.sideColor = const Color(0xFF54C392);
            token.topColor = const Color(0xFF73EC8B);
            token.position = spot.position;
            token.size = Vector2(
              homeSpot.size.x * tokenSizeFactorX,
              homeSpot.size.x * tokenSizeFactorY,
            );
            GameState().ludoBoard?.add(token);
          }

          const playerId = 'GP';
          // final tokens = TokenManager().getGreenTokens();

          if (GameState().players.isEmpty) {
            blinkGreenBase(true);
            Player greenPlayer = Player(
              playerId: playerId,
              tokens: TokenManager().getGreenTokens(),
              isCurrentTurn: true,
              enableDice: true,
            );
            GameState().players.add(greenPlayer);
            for (var token in TokenManager().getGreenTokens()) {
              token.playerId = greenPlayer.playerId;
              token.enableToken = true;
            }
          } else {
            Player greenPlayer = Player(
              playerId: playerId,
              tokens: TokenManager().getGreenTokens(),
            );
            GameState().players.add(greenPlayer);
            for (var token in TokenManager().getGreenTokens()) {
              token.playerId = greenPlayer.playerId;
              token.enableToken = false;
            }
          }
        }
      } else if (team == 'YP') {
        if (TokenManager().getYellowTokens().isEmpty) {
          TokenManager().initializeTokens(TokenManager().yellowTokensBase);

          final ludoBoardPosition = GameState().ludoBoardAbsolutePosition;
          const homeSpotSizeFactorX = 0.10;
          const homeSpotSizeFactorY = 0.05;
          const tokenSizeFactorX = 0.80;
          const tokenSizeFactorY = 1.05;

          for (var token in TokenManager().getYellowTokens()) {
            final homeSpot = getHomeSpot(world, 8)
                .whereType<HomeSpot>()
                .firstWhere((spot) => spot.uniqueId == token.positionId);
            final spot = SpotManager().findSpotById(token.positionId);
            // update spot position
            spot.position = Vector2(
              homeSpot.absolutePosition.x +
                  (homeSpot.size.x * homeSpotSizeFactorX) -
                  ludoBoardPosition.x,
              homeSpot.absolutePosition.y -
                  (homeSpot.size.x * homeSpotSizeFactorY) -
                  ludoBoardPosition.y,
            );
            // update token position
            token.sideColor = const Color(0xffc9a227);
            token.topColor = const Color(0xffFFDF5B);
            token.position = spot.position;
            token.size = Vector2(
              homeSpot.size.x * tokenSizeFactorX,
              homeSpot.size.x * tokenSizeFactorY,
            );
            GameState().ludoBoard?.add(token);
          }

          const playerId = 'YP';
          // final tokens = TokenManager().getYellowTokens();

          if (GameState().players.isEmpty) {
            blinkYellowBase(true);
            Player yellowPlayer = Player(
              playerId: playerId,
              tokens: TokenManager().getYellowTokens(),
              isCurrentTurn: true,
              enableDice: true,
            );
            GameState().players.add(yellowPlayer);
            for (var token in TokenManager().getYellowTokens()) {
              token.playerId = yellowPlayer.playerId;
              token.enableToken = true;
            }
            addDice() {
              // dice for player yellow
              final lowerController =
                  world.children.whereType<LowerController>().first;
              final lowerControllerComponents =
                  lowerController.children.toList();
              final rightDice = lowerControllerComponents[2]
                  .children
                  .whereType<RectangleComponent>()
                  .first;

              final rightDiceContainer =
                  rightDice.children.whereType<RectangleComponent>().first;

              rightDiceContainer.add(LudoDice(
                player: yellowPlayer,
                faceSize: rightDice.size.x * 0.70,
              ));
            }

            addDice();
          } else {
            Player yellowPlayer = Player(
              playerId: playerId,
              tokens: TokenManager().getYellowTokens(),
            );
            GameState().players.add(yellowPlayer);
            for (var token in TokenManager().getYellowTokens()) {
              token.playerId = yellowPlayer.playerId;
              token.enableToken = false;
            }
          }
        }
      } else if (team == 'RP') {
        if (TokenManager().getRedTokens().isEmpty) {
          TokenManager().initializeTokens(TokenManager().redTokensBase);

          final ludoBoardPosition = GameState().ludoBoardAbsolutePosition;
          const homeSpotSizeFactorX = 0.10;
          const homeSpotSizeFactorY = 0.05;
          const tokenSizeFactorX = 0.80;
          const tokenSizeFactorY = 1.05;

          for (var token in TokenManager().getRedTokens()) {
            final homeSpot = getHomeSpot(world, 0)
                .whereType<HomeSpot>()
                .firstWhere((spot) => spot.uniqueId == token.positionId);
            final spot = SpotManager().findSpotById(token.positionId);
            // update spot position
            spot.position = Vector2(
              homeSpot.absolutePosition.x +
                  (homeSpot.size.x * homeSpotSizeFactorX) -
                  ludoBoardPosition.x,
              homeSpot.absolutePosition.y -
                  (homeSpot.size.x * homeSpotSizeFactorY) -
                  ludoBoardPosition.y,
            );
            // update token position
            token.sideColor = const Color(0xff780000);
            token.topColor = const Color(0xffFF5B5B);
            token.position = spot.position;
            token.size = Vector2(
              homeSpot.size.x * tokenSizeFactorX,
              homeSpot.size.x * tokenSizeFactorY,
            );
            GameState().ludoBoard?.add(token);
          }

          const playerId = 'RP';
          // final tokens = TokenManager().getRedTokens();

          if (GameState().players.isEmpty) {
            blinkRedBase(true);
            Player redPlayer = Player(
              playerId: playerId,
              tokens: TokenManager().getRedTokens(),
              isCurrentTurn: true,
              enableDice: true,
            );
            GameState().players.add(redPlayer);
            for (var token in TokenManager().getRedTokens()) {
              token.playerId = redPlayer.playerId;
              token.enableToken = true;
            }

            addDice() {
              // dice for player red
              final upperController =
                  world.children.whereType<UpperController>().first;
              final upperControllerComponents =
                  upperController.children.toList();
              final leftDice = upperControllerComponents[0]
                  .children
                  .whereType<RectangleComponent>()
                  .first;

              final rightDiceContainer =
                  leftDice.children.whereType<RectangleComponent>().first;
              rightDiceContainer.add(LudoDice(
                player: redPlayer,
                faceSize: leftDice.size.x * 0.70,
              ));
            }

            addDice();
            
            // Trigger AI turn if it's the first player and AI mode
            if (Mixin.quad?.quadType == 'AI_MODE') {
              Future.delayed(Duration(milliseconds: 1500), () {
                _triggerAITurn();
              });
            }
          } else {
            Player redPlayer = Player(
              playerId: playerId,
              tokens: TokenManager().getRedTokens(),
            );
            GameState().players.add(redPlayer);
            for (var token in TokenManager().getRedTokens()) {
              token.playerId = redPlayer.playerId;
              token.enableToken = false;
            }
          }
        }
      }
    }
    return Future.value();
  }

  @override
  Color backgroundColor() => const Color.fromARGB(0, 0, 0, 0);

  RankModalComponent? _playerModal;

  void showPlayerModal() {
    _playerModal = RankModalComponent(
      players: GameState().players,
      position: Vector2(size.x * 0.05, size.y * 0.10),
      size: Vector2(size.x * 0.90, size.y * 0.90),
      context: context,
    );
    world.add(_playerModal!);
  }

  void hidePlayerModal() {
    _playerModal?.removeFromParent();
    _playerModal = null;
  }
}

List<Component> getHomeSpot(world, i) {
  final childrenOfLudoBoard = GameState().ludoBoard?.children.toList();
  final child = childrenOfLudoBoard![i];
  final home = child.children.toList();
  final homePlate = home[0].children.toList();
  final homeSpotContainer = homePlate[1].children.toList();
  final homeSpotList = homeSpotContainer[1].children.toList();
  return homeSpotList;
}

void moveOutOfBase({
  required World world,
  required Token token,
  required List<String> tokenPath,
}) async {
  // In multiplayer mode, check if it's the current user's turn
  if (Mixin.quad?.quadType != 'AI_MODE' && !_isCurrentUserTurn()) {
    print('Not your turn! Current turn: ${GameState().currentPlayer.playerId}');
    return;
  }

  // Update token position to the first position in the path
  token.positionId = tokenPath.first;
  token.state = TokenState.onBoard;

  // Play piece movement sound when moving out of base
  FlameAudio.play('piece_moved.mp3');

  await _applyEffect(
      token,
      MoveToEffect(SpotManager().findSpotById(tokenPath.first).tokenPosition,
          EffectController(duration: 0.1, curve: Curves.easeInOut)));

  tokenCollision(world, token);

  // Emit token move to other player (only in multiplayer mode, not AI mode)
  _emitTokenMove(token, 'moveOutOfBase', 0);
  
  // In multiplayer mode, switch turns after move (unless player gets another turn)
  if (Mixin.quad?.quadType != 'AI_MODE') {
    handleTurnSwitchGlobal();
  }
}

void tokenCollision(World world, Token attackerToken) async {
  final tokensOnSpot = TokenManager()
      .allTokens
      .where((token) => token.positionId == attackerToken.positionId)
      .toList();

  // Initialize the flag to track if any token was attacked
  bool wasTokenAttacked = false;

  // only attacker token on spot, return
  if (tokensOnSpot.length > 1 &&
      !['B04', 'B23', 'R22', 'R10', 'G02', 'G21', 'Y30', 'Y42']
          .contains(attackerToken.positionId)) {
    // Batch token movements
    final tokensToMove = tokensOnSpot
        .where((token) => token.playerId != attackerToken.playerId)
        .toList();

    if (tokensToMove.isNotEmpty) {
      wasTokenAttacked = true;
    }

    // Wait for all movements to complete
    await Future.wait(tokensToMove.map((token) => moveBackward(
          world: world,
          token: token,
          tokenPath: GameState().getTokenPath(token.playerId),
          ludoBoard: GameState().ludoBoard as PositionComponent,
        )));
  }

  // Grant another turn or switch to next player
  final player = GameState()
      .players
      .firstWhere((player) => player.playerId == attackerToken.playerId);

  if (wasTokenAttacked) {
    if (player.hasRolledThreeConsecutiveSixes()) {
      player.resetExtraTurns();
    }
    player.grantAnotherTurn();
  } else {
    if (GameState().diceNumber != 6) {
      GameState().switchToNextPlayer();
    }
  }

  player.enableDice = true;

  if (GameState().diceNumber == 6 || wasTokenAttacked == true) {
    final lowerController = world.children.whereType<LowerController>().first;
    final upperController = world.children.whereType<UpperController>().first;
    lowerController.showPointer(player.playerId);
    upperController.showPointer(player.playerId);
    
    // Trigger AI turn if it's AI mode and red player's turn
    if (Mixin.quad?.quadType == 'AI_MODE' && player.playerId == 'RP') {
      Future.delayed(Duration(milliseconds: 800), () {
        Ludo._instance?._triggerAITurn();
      });
    }
  }

  for (var token in player.tokens) {
    token.enableToken = false;
  }

  // Call the function to resize tokens after moveBackward is complete
  resizeTokensOnSpot(world);
}

void resizeTokensOnSpot(World world) {
  final positionIncrements = {
    1: 0,
    2: 10,
    3: 5,
  };

  // Group tokens by position ID
  final Map<String, List<Token>> tokensByPositionId = {};
  for (var token in TokenManager().allTokens) {
    if (!tokensByPositionId.containsKey(token.positionId)) {
      tokensByPositionId[token.positionId] = [];
    }
    tokensByPositionId[token.positionId]!.add(token);
  }

  tokensByPositionId.forEach((positionId, tokenList) {
    // Precompute spot global position and adjusted position
    final spot = SpotManager().findSpotById(positionId);

    // Compute size factor and position increment
    final positionIncrement = positionIncrements[tokenList.length] ?? 5;

    // Resize and reposition tokens
    for (var i = 0; i < tokenList.length; i++) {
      final token = tokenList[i];
      if (token.state == TokenState.inBase) {
        token.position = spot.position;
      } else if (token.state == TokenState.onBoard ||
          token.state == TokenState.inHome) {
        token.position = Vector2(
            spot.tokenPosition.x + i * positionIncrement, spot.tokenPosition.y);
      }
    }
  });
}

void addTokenTrail(List<Token> tokensInBase, List<Token> tokensOnBoard) {
  var trailingTokens = [];

  for (var token in tokensOnBoard) {
    if (!token.spaceToMove()) {
      continue;
    }
    trailingTokens.add(token);
  }

  if (GameState().diceNumber == 6) {
    for (var token in tokensInBase) {
      trailingTokens.add(token);
    }
  }

  for (var token in trailingTokens) {
    token.enableCircleAnimation();
  }
}

Future<void> moveBackward({
  required World world,
  required Token token,
  required List<String> tokenPath,
  required PositionComponent ludoBoard,
}) async {
  final currentIndex = tokenPath.indexOf(token.positionId);
  const finalIndex = 0;

  // Preload audio to avoid delays during playback
  bool audioPlayed = false;

  for (int i = currentIndex; i >= finalIndex; i--) {
    token.positionId = tokenPath[i];

    if (!audioPlayed) {
      FlameAudio.play('move.mp3');
      audioPlayed = true;
    }

    await _applyEffect(
      token,
      MoveToEffect(
        SpotManager()
            .getSpots()
            .firstWhere((spot) => spot.uniqueId == token.positionId)
            .tokenPosition,
        EffectController(duration: 0.1, curve: Curves.easeInOut),
      ),
    );
  }

  if (token.playerId == 'BP') {
    await moveTokenToBase(
      world: world,
      token: token,
      tokenBase: TokenManager().blueTokensBase,
      homeSpotIndex: 6,
      ludoBoard: ludoBoard,
    );
  } else if (token.playerId == 'GP') {
    await moveTokenToBase(
      world: world,
      token: token,
      tokenBase: TokenManager().greenTokensBase,
      homeSpotIndex: 2,
      ludoBoard: ludoBoard,
    );
  } else if (token.playerId == 'RP') {
    await moveTokenToBase(
      world: world,
      token: token,
      tokenBase: TokenManager().redTokensBase,
      homeSpotIndex: 0,
      ludoBoard: ludoBoard,
    );
  } else if (token.playerId == 'YP') {
    await moveTokenToBase(
      world: world,
      token: token,
      tokenBase: TokenManager().yellowTokensBase,
      homeSpotIndex: 8,
      ludoBoard: ludoBoard,
    );
  }
}

Future<void> moveForward({
  required World world,
  required Token token,
  required List<String> tokenPath,
  required int diceNumber,
}) async {
  // In multiplayer mode, check if it's the current user's turn
  if (Mixin.quad?.quadType != 'AI_MODE' && !_isCurrentUserTurn()) {
    print('Not your turn! Current turn: ${GameState().currentPlayer.playerId}');
    return;
  }

  // get all spots
  final currentIndex = tokenPath.indexOf(token.positionId);
  final finalIndex = currentIndex + diceNumber;

  for (int i = currentIndex + 1; i <= finalIndex && i < tokenPath.length; i++) {
    token.positionId = tokenPath[i];
    
    // Play piece movement sound for each box
    FlameAudio.play('piece_moved.mp3');
    
    await _applyEffect(
      token,
      MoveToEffect(
        SpotManager()
            .getSpots()
            .firstWhere((spot) => spot.uniqueId == token.positionId)
            .tokenPosition,
        EffectController(duration: 0.12, curve: Curves.easeInOut),
      ),
    );

    // Add a small delay to reduce CPU strain and smooth the animation
    Future.delayed(const Duration(milliseconds: 120));
  }

  // if token is in home
  bool isTokenInHome = await checkTokenInHomeAndHandle(token, world);

  if (isTokenInHome) {
    resizeTokensOnSpot(world);
  } else {
    tokenCollision(world, token);
  }
  clearTokenTrail();
  
  // Emit token move to other player (only in multiplayer mode, not AI mode)
  _emitTokenMove(token, 'moveForward', diceNumber);
  
  // In multiplayer mode, switch turns after move (unless player gets another turn)
  if (Mixin.quad?.quadType != 'AI_MODE') {
    handleTurnSwitchGlobal();
  }
}

void clearTokenTrail() {
  final tokens = TokenManager().allTokens;
  for (var token in tokens) {
    token.disableCircleAnimation();
  }
}

// Helper function to get the current user's player ID (BP or RP)
String? _getCurrentUserPlayerId() {
  if (Mixin.quad?.quadType == 'AI_MODE') {
    return 'BP'; // Player is always Blue in AI mode
  }
  
  // In multiplayer mode, determine which team this user controls
  if (Mixin.user?.usrId?.toString() == Mixin.quad?.quadUsrId?.toString()) {
    // This user created the game, they are BP (Blue Player)
    return 'BP';
  } else if (Mixin.user?.usrId?.toString() == Mixin.quad?.quadAgainstId?.toString()) {
    // This user joined the game, they are RP (Red Player)  
    return 'RP';
  }
  
  return null; // User is not part of this game
}

// Helper function to check if it's the current user's turn
bool _isCurrentUserTurn() {
  final userPlayerId = _getCurrentUserPlayerId();
  if (userPlayerId == null) return false;
  
  // Safety check for empty players list
  if (GameState().players.isEmpty) return false;
  
  // Safety check for valid current player index
  if (GameState().currentPlayerIndex >= GameState().players.length) {
    return false;
  }
  
  final currentPlayer = GameState().currentPlayer;
  return currentPlayer.playerId == userPlayerId;
}

// Helper function to check if the current user owns a specific player
bool _doesCurrentUserOwnPlayer(String playerId) {
  if (Mixin.quad?.quadType == 'AI_MODE') {
    // In AI mode, user only owns BP (Blue Player)
    return playerId == 'BP';
  }
  
  // In multiplayer mode, check which player this user controls
  final userControlledPlayer = _getCurrentUserPlayerId();
  return userControlledPlayer == playerId;
}

// Helper function to emit token moves to other players
void _emitTokenMove(Token token, String moveType, int diceValue) {
  // Only emit in multiplayer mode, not AI mode
  if (Mixin.quad?.quadType != 'AI_MODE' && Mixin.quadrixSocket != null) {
    final moveData = {
      'quadId': Mixin.quad?.quadId?.toString(),
      'quadTokenId': token.tokenId,
      'quadPlayerId': Mixin.user?.usrId?.toString(), // Use actual user ID
      'quadNewPositionId': token.positionId,
      'quadMoveType': moveType,
      'quadDiceValue': diceValue,
      'quadTimestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    print('Emitting token move: $moveData');
    Mixin.quadrixSocket?.emit('token_move', moveData);
  }

  // Helper function to emit turn switch to other players
  void _emitTurnSwitch() {
    if (Mixin.quad?.quadType != 'AI_MODE' && Mixin.quadrixSocket != null) {
      // Safety check for empty players list
      if (GameState().players.isEmpty) {
        print('Players list is empty, cannot emit turn switch');
        return;
      }
      
      // Safety check for valid current player index
      if (GameState().currentPlayerIndex >= GameState().players.length) {
        print('Invalid current player index, cannot emit turn switch');
        return;
      }
      
      final turnData = {
        'quadId': Mixin.quad?.quadId?.toString(),
        'quadUsrId': Mixin.user?.usrId?.toString(), // Add sender's user ID for validation
        'currentPlayerId': GameState().currentPlayer.playerId,
        'nextPlayerIndex': (GameState().currentPlayerIndex + 1) % GameState().players.length,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      print('Emitting turn switch: $turnData');
      Mixin.quadrixSocket?.emit('turn_switch', turnData);
    }
  }

  // Helper function to handle turn switching after a move
  void handleTurnAfterMove() {
    // Safety check for empty players list
    if (GameState().players.isEmpty) {
      print('Players list is empty, cannot handle turn switch');
      return;
    }
    
    // Safety check for valid current player index
    if (GameState().currentPlayerIndex >= GameState().players.length) {
      print('Invalid current player index, resetting to 0');
      GameState().currentPlayerIndex = 0;
    }
    
    final currentPlayer = GameState().currentPlayer;
    
    // Check if player gets another turn (rolled 6, captured token, or reached home)
    bool getAnotherTurn = false;
    
    // Check if dice was 6
    if (GameState().diceNumber == 6) {
      getAnotherTurn = true;
    }
    
    // If player doesn't get another turn, switch to next player
    if (!getAnotherTurn) {
      if (Mixin.quad?.quadType == 'AI_MODE') {
        // In AI mode, just switch locally
        GameState().switchToNextPlayer();
      } else {
        // In multiplayer mode, emit turn switch to other players
        // The turn switch will be handled by the socket event handler for both players
        _emitTurnSwitch();
      }
    }
  }
}

// Global function to handle turn switching that can be called from anywhere
void handleTurnSwitchGlobal() {
  // Safety check for empty players list
  if (GameState().players.isEmpty) {
    print('Players list is empty, cannot handle turn switch');
    return;
  }
  
  // Safety check for valid current player index
  if (GameState().currentPlayerIndex >= GameState().players.length) {
    print('Invalid current player index, resetting to 0');
    GameState().currentPlayerIndex = 0;
  }
  
  // Check if player gets another turn (rolled 6, captured token, or reached home)
  bool getAnotherTurn = false;
  
  // Check if dice was 6
  if (GameState().diceNumber == 6) {
    getAnotherTurn = true;
  }
  
  // If player doesn't get another turn, switch to next player
  if (!getAnotherTurn) {
    if (Mixin.quad?.quadType == 'AI_MODE') {
      // In AI mode, just switch locally
      GameState().switchToNextPlayer();
    } else {
      // In multiplayer mode, emit turn switch to other players
      emitTurnSwitchGlobal();
    }
  }
}

// Global function to emit turn switch
void emitTurnSwitchGlobal() {
  if (Mixin.quad?.quadType != 'AI_MODE' && Mixin.quadrixSocket != null) {
    // Safety check for empty players list
    if (GameState().players.isEmpty) {
      print('Players list is empty, cannot emit turn switch');
      return;
    }
    
    // Safety check for valid current player index
    if (GameState().currentPlayerIndex >= GameState().players.length) {
      print('Invalid current player index, cannot emit turn switch');
      return;
    }
    
    final turnData = {
      'quadId': Mixin.quad?.quadId?.toString(),
      'quadUsrId': Mixin.user?.usrId?.toString(),
      'currentPlayerId': GameState().currentPlayer.playerId,
      'nextPlayerIndex': (GameState().currentPlayerIndex + 1) % GameState().players.length,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    print('Emitting turn switch: $turnData');
    Mixin.quadrixSocket?.emit('turn_switch', turnData);
  }
}

// Initialize multiplayer turn management
void _initializeMultiplayerTurns() {
  if (Mixin.quad?.quadType == 'AI_MODE') {
    return; // AI mode doesn't need special turn initialization
  }
  
  // Check if players list is populated, if not, delay initialization
  if (GameState().players.isEmpty) {
    print('Players not initialized yet, delaying turn management setup...');
    Future.delayed(Duration(milliseconds: 500), () {
      _initializeMultiplayerTurns(); // Retry after delay
    });
    return;
  }
  
  // In multiplayer mode, ensure only the appropriate player can act on their turn
  final userPlayerId = _getCurrentUserPlayerId();
  if (userPlayerId == null) return;
  
  // Disable all players initially, then enable only the current turn player
  for (var player in GameState().players) {
    player.enableDice = false;
    player.isCurrentTurn = false;
    
    // Disable all tokens for all players initially
    for (var token in player.tokens) {
      token.enableToken = false;
    }
  }
  
  // Safely check if we have valid current player index
  if (GameState().currentPlayerIndex >= GameState().players.length) {
    GameState().currentPlayerIndex = 0; // Reset to first player if invalid
  }
  
  // Enable the current turn player
  final currentPlayer = GameState().currentPlayer;
  if (currentPlayer.playerId == userPlayerId) {
    currentPlayer.enableDice = true;
    currentPlayer.isCurrentTurn = true;
    print('It\'s your turn! You are playing as ${userPlayerId}');
  } else {
    print('Waiting for ${currentPlayer.playerId} to play...');
  }
}

Future<void> _applyEffect(PositionComponent component, Effect effect) {
  final completer = Completer<void>();
  effect.onComplete = completer.complete;
  component.add(effect);
  return completer.future;
}

Future<void> moveTokenToBase({
  required World world,
  required Token token,
  required Map<String, String> tokenBase,
  required int homeSpotIndex,
  required PositionComponent ludoBoard,
}) async {
  for (var entry in tokenBase.entries) {
    var tokenId = entry.key;
    var homePosition = entry.value;
    if (token.tokenId == tokenId) {
      token.positionId = homePosition;
      token.state = TokenState.inBase;
    }
  }

  await _applyEffect(
    token,
    MoveToEffect(
      SpotManager().findSpotById(token.positionId).position,
      EffectController(duration: 0.03, curve: Curves.easeInOut),
    ),
  );
  Future.delayed(const Duration(milliseconds: 30));
}

Future<bool> checkTokenInHomeAndHandle(Token token, World world) async {
  // Define home position IDs
  const homePositions = ['BF', 'GF', 'YF', 'RF'];

  // Check if the token is in home
  if (!homePositions.contains(token.positionId)) return false;

  token.state = TokenState.inHome;

  // Cache players from GameState
  // final players = GameState().players;
  final player =
      GameState().players.firstWhere((p) => p.playerId == token.playerId);
  player.totalTokensInHome++;

  // Handle win condition
  if (player.totalTokensInHome == 4) {
    player.hasWon = true;

    // Get winners and non-winners
    final playersWhoWon = GameState().players.where((p) => p.hasWon).toList();
    final playersWhoNotWon =
        GameState().players.where((p) => !p.hasWon).toList();

    // End game condition
    if (playersWhoWon.length == GameState().players.length - 1) {
      playersWhoNotWon.first.rank =
          GameState().players.length; // Rank last player
      player.rank = playersWhoWon.length; // Set rank for current player
      // Disable dice for all players
      for (var p in GameState().players) {
        p.enableDice = false;
      }
      for (var t in TokenManager().allTokens) {
        t.enableToken = false;
      }
      EventBus().emit(OpenPlayerModalEvent());
    } else {
      // Set rank for current player
      player.rank = playersWhoWon.length;
    }
    return true;
  }

  // Grant another turn if not all tokens are home

  player.enableDice = true;
  final lowerController = world.children.whereType<LowerController>().first;
  lowerController.showPointer(player.playerId);
  final upperController = world.children.whereType<UpperController>().first;
  upperController.showPointer(player.playerId);

  // Trigger AI turn if it's AI mode and red player's turn
  if (Mixin.quad?.quadType == 'AI_MODE' && player.playerId == 'RP') {
    Future.delayed(Duration(milliseconds: 800), () {
      Ludo._instance?._triggerAITurn();
    });
  }

  // Disable tokens for current player
  for (var t in player.tokens) {
    t.enableToken = false;
  }

  // Reset extra turns if applicable
  if (player.hasRolledThreeConsecutiveSixes()) {
    await player.resetExtraTurns();
  }

  player.grantAnotherTurn();
  return true;
}

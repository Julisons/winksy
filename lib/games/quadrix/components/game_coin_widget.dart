import 'package:flutter/material.dart';

import '../../../theme/custom_colors.dart';
import '../../../theme/theme_data_style.dart';
import '../models/coin.dart';
import '../utils/game_logic.dart';

class GameCoinWidget extends StatefulWidget {
  const GameCoinWidget({super.key, required this.coin});

  final Coin coin;

  @override
  State<GameCoinWidget> createState() => _GameCoinWidgetState();
}

class _GameCoinWidgetState extends State<GameCoinWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  bool _isWinningBall = false;

  @override
  void initState() {
    super.initState();

    _breathController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _breathAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breathController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  void _checkAndAnimateWinning() {
    bool isWinning = winningCombinations.any((combination) =>
        combination.positions.any((position) =>
        position.row == widget.coin.row && position.col == widget.coin.column));

    if (isWinning && !_isWinningBall) {
      setState(() {
        _isWinningBall = true;
      });

      // Stagger the animation based on position
      int delay = winningCombinations
          .expand((combo) => combo.positions)
          .toList()
          .indexWhere((pos) => pos.row == widget.coin.row && pos.col == widget.coin.column);

      Future.delayed(Duration(milliseconds: delay * 200), () {
        if (mounted) {
          _breathController.repeat(reverse: true);
        }
      });
    }

    if (!isWinning && _isWinningBall) {
      setState(() {
        _isWinningBall = false;
      });
      _breathController.stop();
      _breathController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
     final color = ThemeDataStyle.darker.extension<CustomColors>()!;
    double size = (MediaQuery.of(context).size.width - 20) / 7;

    // Check if this ball should be animated
    _checkAndAnimateWinning();

    return Container(
      height: size,
      width: size,
      color: Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5),
      alignment: Alignment.center,
      child: _isWinningBall
          ? AnimatedBuilder(
        animation: _breathAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _breathAnimation.value,
            child: _ball(size, widget.coin, color, _isWinningBall),
          );
        },
      )
          : _ball(size, widget.coin, color, _isWinningBall),
    );
  }
}

Widget _ball(double size, Coin coin, CustomColors color, bool isWinningBall) {
  // Calculate the actual ball size to leave space for breathing animation
  // When scaling down to 0.85, we want the background to show
  double ballSize = isWinningBall ? size * 0.9 : size - 4; // Smaller base size for winning balls

  return Container(
    height: size,
    width: size,
    alignment: Alignment.center,
    child: Container(
      height: ballSize,
      width: ballSize,
      decoration: coin.color == color.xSecondaryColor
          ? BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.8,
          colors: [
            coin.color.withOpacity(0.8),
            coin.color.withOpacity(0.9),
            coin.color.withOpacity(0.9),
            coin.color.withOpacity(0.9),
            coin.color.withOpacity(0.9),
          ],
          stops: const [0.1, 0.5, 1.0, 1.0, 1.0],
        ),
        boxShadow: const [
          // Empty shadow for empty slots
        ],
      )
          : BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.8,
          colors: [
            coin.color.withOpacity(0.9),
            coin.color.withOpacity(0.5),
            coin.color.withOpacity(0.2),
          ],
          stops: const [0.1, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.xPrimaryColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
    ),
  );
}

// Function to reset winning animations (call this when restarting the game)
void resetWinningAnimations() {
  winningCombinations.clear();
}

// Enhanced breathing animation function
Widget breathingAnimation({
  required Widget child,
  Duration duration = const Duration(seconds: 20),
  double minScale = 0.95,
  double maxScale = 1.05,
}) {
  return BreathingWidget(
    duration: duration,
    minScale: minScale,
    maxScale: maxScale,
    child: child,
  );
}

// Stateful widget that handles the animation
class BreathingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const BreathingWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  }) : super(key: key);

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the repeating animation
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}
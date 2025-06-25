import 'package:flutter/material.dart';
import 'dart:math' as math;



class Loading extends StatefulWidget {
  final double size;
  final Color dotColor;
  final int dotCount;
  final Duration duration;

  const Loading({
    Key? key,
    this.size = 80.0,
    this.dotColor = Colors.white,
    this.dotCount = 5,
    this.duration = const Duration(milliseconds: 1200),
  }) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rotationController.repeat();
    _scaleController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: Windows8LoadingPainter(
                dotColor: widget.dotColor,
                dotCount: widget.dotCount,
                animationValue: _rotationAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class Windows8LoadingPainter extends CustomPainter {
  final Color dotColor;
  final int dotCount;
  final double animationValue;

  Windows8LoadingPainter({
    required this.dotColor,
    required this.dotCount,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 3;
    final double dotRadius = size.width / 20;

    for (int i = 0; i < dotCount; i++) {
      final double angle = (2 * math.pi / dotCount) * i;
      final double x = centerX + radius * math.cos(angle);
      final double y = centerY + radius * math.sin(angle);

      // Create a fade effect for each dot based on its position
      final double opacity = (math.sin(animationValue + angle) + 1) / 2;
      paint.color = dotColor.withOpacity(opacity * 0.3 + 0.7);

      // Scale dots based on their position in the animation
      final double scale = 0.5 + (opacity * 0.5);
      canvas.drawCircle(
        Offset(x, y),
        dotRadius * scale,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Alternative Windows 8 style with different dot pattern
class Windows8AlternativeAnimation extends StatefulWidget {
  final double size;
  final Color dotColor;

  const Windows8AlternativeAnimation({
    Key? key,
    this.size = 60.0,
    this.dotColor = Colors.white,
  }) : super(key: key);

  @override
  _Windows8AlternativeAnimationState createState() => _Windows8AlternativeAnimationState();
}

class _Windows8AlternativeAnimationState extends State<Windows8AlternativeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _animations = List.generate(6, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: Windows8AlternativePainter(
            dotColor: widget.dotColor,
            animations: _animations,
          ),
        );
      },
    );
  }
}

class Windows8AlternativePainter extends CustomPainter {
  final Color dotColor;
  final List<Animation<double>> animations;

  Windows8AlternativePainter({
    required this.dotColor,
    required this.animations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 3;

    for (int i = 0; i < animations.length; i++) {
      final double angle = (2 * math.pi / animations.length) * i;
      final double animValue = animations[i].value;

      final double x = centerX + radius * math.cos(angle) * animValue;
      final double y = centerY + radius * math.sin(angle) * animValue;

      paint.color = dotColor.withOpacity(animValue);
      canvas.drawCircle(
        Offset(x, y),
        (size.width / 25) * animValue,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

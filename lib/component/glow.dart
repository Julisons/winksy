import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glowing X Symbol',
      theme: ThemeData.dark(),
      home: GlowingXDemo(),
    );
  }
}

class GlowingXDemo extends StatefulWidget {
  @override
  _GlowingXDemoState createState() => _GlowingXDemoState();
}

class _GlowingXDemoState extends State<GlowingXDemo>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation
    _rotationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Glowing X Symbols'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Simple Glowing X with Text
            SectionTitle('Text-based Glowing X'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GlowingXText(size: 40, color: Colors.red),
                GlowingXText(size: 50, color: Colors.blue),
                GlowingXText(size: 60, color: Colors.green),
              ],
            ),
            SizedBox(height: 40),
            // Animated Pulsing X
            SectionTitle('Animated Pulsing X'),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: GlowingXText(size: 80, color: Colors.purple),
                );
              },
            ),

            SizedBox(height: 40),

            // Custom Painted Glowing X
            SectionTitle('Custom Painted X'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GlowingXPainted(size: 60, color: Colors.cyan),
                GlowingXPainted(size: 80, color: Colors.orange),
                GlowingXPainted(size: 100, color: Colors.pink),
              ],
            ),

            SizedBox(height: 40),

            // Rotating Glowing X
            SectionTitle('Rotating Glowing X'),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: GlowingXPainted(size: 120, color: Colors.yellow),
                );
              },
            ),

            SizedBox(height: 40),

            // Interactive Glowing X
            SectionTitle('Interactive Glowing X'),
            SizedBox(height: 20),
            InteractiveGlowingX(),

            SizedBox(height: 40),

            // Multi-layer Glow Effect
            SectionTitle('Multi-layer Glow Effect'),
            SizedBox(height: 20),
            MultiLayerGlowingX(),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    );
  }
}

// Simple text-based glowing X
class GlowingXText extends StatelessWidget {
  final double size;
  final Color color;
  final double glowRadius;

  const GlowingXText({
    Key? key,
    required this.size,
    required this.color,
    this.glowRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '✕',
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: color.withOpacity(0.8),
              blurRadius: glowRadius,
            ),
            Shadow(
              color: color.withOpacity(0.6),
              blurRadius: glowRadius * 2,
            ),
            Shadow(
              color: color.withOpacity(0.4),
              blurRadius: glowRadius * 3,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painted glowing X
class GlowingXPainted extends StatelessWidget {
  final double size;
  final Color color;

  const GlowingXPainted({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GlowingXPainter(color: color),
      ),
    );
  }
}

class GlowingXPainter extends CustomPainter {
  final Color color;

  GlowingXPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Create glow effect with multiple layers
    final glowPaints = [
      Paint()
        ..color = color.withOpacity(0.1)
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15),
      Paint()
        ..color = color.withOpacity(0.3)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8),
      Paint()
        ..color = color.withOpacity(0.6)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    ];

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Draw glow layers
    for (final glowPaint in glowPaints) {
      // First diagonal line
      canvas.drawLine(
        Offset(center.dx - radius, center.dy - radius),
        Offset(center.dx + radius, center.dy + radius),
        glowPaint,
      );

      // Second diagonal line
      canvas.drawLine(
        Offset(center.dx + radius, center.dy - radius),
        Offset(center.dx - radius, center.dy + radius),
        glowPaint,
      );
    }

    // Draw main X
    // First diagonal line
    canvas.drawLine(
      Offset(center.dx - radius, center.dy - radius),
      Offset(center.dx + radius, center.dy + radius),
      paint,
    );

    // Second diagonal line
    canvas.drawLine(
      Offset(center.dx + radius, center.dy - radius),
      Offset(center.dx - radius, center.dy + radius),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Interactive glowing X that responds to tap
class InteractiveGlowingX extends StatefulWidget {
  @override
  _InteractiveGlowingXState createState() => _InteractiveGlowingXState();
}

class _InteractiveGlowingXState extends State<InteractiveGlowingX>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.red,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GlowingXText(
              size: 80,
              color: _colorAnimation.value ?? Colors.white,
            ),
          );
        },
      ),
    );
  }
}

// Multi-layer glow effect
class MultiLayerGlowingX extends StatefulWidget {
  @override
  _MultiLayerGlowingXState createState() => _MultiLayerGlowingXState();
}

class _MultiLayerGlowingXState extends State<MultiLayerGlowingX>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _controller2 = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _controller3 = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _controller1.repeat();
    _controller2.repeat();
    _controller3.repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow layer
        AnimatedBuilder(
          animation: _controller3,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + 0.3 * math.sin(_controller3.value * 2 * math.pi),
              child: GlowingXText(
                size: 120,
                color: Colors.blue.withOpacity(0.3),
                glowRadius: 20,
              ),
            );
          },
        ),

        // Middle glow layer
        AnimatedBuilder(
          animation: _controller2,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + 0.2 * math.sin(_controller2.value * 2 * math.pi),
              child: GlowingXText(
                size: 100,
                color: Colors.purple.withOpacity(0.5),
                glowRadius: 15,
              ),
            );
          },
        ),

        // Inner core layer
        AnimatedBuilder(
          animation: _controller1,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + 0.1 * math.sin(_controller1.value * 2 * math.pi),
              child: GlowingXText(
                size: 80,
                color: Colors.white,
                glowRadius: 10,
              ),
            );
          },
        ),
      ],
    );
  }
}
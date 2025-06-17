import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glowing Letter Widget',
      theme: ThemeData.dark(),
      home: GlowingLetterDemo(),
    );
  }
}

class GlowingLetterDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Glowing Letter Examples'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Simple Glowing Letters
            SectionTitle('Simple Glowing Letters'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GlowingLetter(letter: 'A', size: 60, color: Colors.red),
                GlowingLetter(letter: 'B', size: 60, color: Colors.blue),
                GlowingLetter(letter: 'C', size: 60, color: Colors.green),
                GlowingLetter(letter: 'X', size: 60, color: Colors.green),
                GlowingLetter(letter: 'O', size: 60, color: Colors.green),
              ],
            ),

            SizedBox(height: 40),

            // Different Glow Types
            SectionTitle('Different Glow Effects'),
            SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                GlowingLetter(
                  letter: 'X',
                  size: 80,
                  color: Colors.purple,
                  glowType: GlowType.soft,
                ),
                GlowingLetter(
                  letter: 'Y',
                  size: 80,
                  color: Colors.orange,
                  glowType: GlowType.intense,
                ),
                GlowingLetter(
                  letter: 'Z',
                  size: 80,
                  color: Colors.cyan,
                  glowType: GlowType.neon,
                ),
              ],
            ),

            SizedBox(height: 40),

            // Animated Letters
            SectionTitle('Animated Glowing Letters'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedGlowingLetter(
                  letter: 'P',
                  size: 70,
                  color: Colors.pink,
                  animationType: AnimationType.pulse,
                ),
                AnimatedGlowingLetter(
                  letter: 'Q',
                  size: 70,
                  color: Colors.teal,
                  animationType: AnimationType.rotate,
                ),
                AnimatedGlowingLetter(
                  letter: 'R',
                  size: 70,
                  color: Colors.yellow,
                  animationType: AnimationType.breathe,
                ),
              ],
            ),

            SizedBox(height: 40),

            // Interactive Letters
            SectionTitle('Interactive Letters (Tap Them!)'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InteractiveGlowingLetter(letter: 'S', size: 80),
                InteractiveGlowingLetter(letter: 'T', size: 80),
                InteractiveGlowingLetter(letter: 'U', size: 80),
              ],
            ),

            SizedBox(height: 40),

            // Custom Painted Letters
            SectionTitle('Custom Painted Letters'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomPaintedGlowingLetter(letter: 'V', size: 100, color: Colors.deepPurple),
                CustomPaintedGlowingLetter(letter: 'W', size: 100, color: Colors.indigo),
              ],
            ),

            SizedBox(height: 40),

            // Word Example
            SectionTitle('Glowing Word Example'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 'GLOW'.split('').map((letter) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: AnimatedGlowingLetter(
                    letter: letter,
                    size: 50,
                    color: Colors.amber,
                    animationType: AnimationType.pulse,
                  ),
                );
              }).toList(),
            ),
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

enum GlowType { soft, intense, neon }
enum AnimationType { pulse, rotate, breathe }

// Main Glowing Letter Widget
class GlowingLetter extends StatelessWidget {
  final String letter;
  final double size;
  final Color color;
  final GlowType glowType;
  final FontWeight fontWeight;
  final String? fontFamily;

  const GlowingLetter({
    Key? key,
    required this.letter,
    this.size = 50,
    this.color = Colors.white,
    this.glowType = GlowType.soft,
    this.fontWeight = FontWeight.bold,
    this.fontFamily,
  }) : super(key: key);

  List<Shadow> _getGlowShadows() {
    switch (glowType) {
      case GlowType.soft:
        return [
          Shadow(
            color: color.withOpacity(0.6),
            blurRadius: size * 0.15,
          ),
          Shadow(
            color: color.withOpacity(0.4),
            blurRadius: size * 0.3,
          ),
          Shadow(
            color: color.withOpacity(0.2),
            blurRadius: size * 0.45,
          ),
        ];
      case GlowType.intense:
        return [
          Shadow(
            color: color.withOpacity(0.9),
            blurRadius: size * 0.1,
          ),
          Shadow(
            color: color.withOpacity(0.7),
            blurRadius: size * 0.2,
          ),
          Shadow(
            color: color.withOpacity(0.5),
            blurRadius: size * 0.4,
          ),
          Shadow(
            color: color.withOpacity(0.3),
            blurRadius: size * 0.6,
          ),
        ];
      case GlowType.neon:
        return [
          Shadow(
            color: color.withOpacity(1.0),
            blurRadius: size * 0.05,
          ),
          Shadow(
            color: color.withOpacity(0.8),
            blurRadius: size * 0.15,
          ),
          Shadow(
            color: color.withOpacity(0.6),
            blurRadius: size * 0.3,
          ),
          Shadow(
            color: color.withOpacity(0.4),
            blurRadius: size * 0.5,
          ),
          Shadow(
            color: color.withOpacity(0.2),
            blurRadius: size * 0.7,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      letter.toUpperCase(),
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        shadows: _getGlowShadows(),
      ),
    );
  }
}

// Animated Glowing Letter
class AnimatedGlowingLetter extends StatefulWidget {
  final String letter;
  final double size;
  final Color color;
  final AnimationType animationType;
  final GlowType glowType;
  final Duration duration;

  const AnimatedGlowingLetter({
    Key? key,
    required this.letter,
    this.size = 50,
    this.color = Colors.white,
    this.animationType = AnimationType.pulse,
    this.glowType = GlowType.soft,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _AnimatedGlowingLetterState createState() => _AnimatedGlowingLetterState();
}

class _AnimatedGlowingLetterState extends State<AnimatedGlowingLetter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    switch (widget.animationType) {
      case AnimationType.pulse:
        _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        break;
      case AnimationType.rotate:
        _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
          CurvedAnimation(parent: _controller, curve: Curves.linear),
        );
        break;
      case AnimationType.breathe:
        _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        break;
    }

    _controller.repeat(reverse: widget.animationType != AnimationType.rotate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        Widget letter = GlowingLetter(
          letter: widget.letter,
          size: widget.size,
          color: widget.color,
          glowType: widget.glowType,
        );

        switch (widget.animationType) {
          case AnimationType.pulse:
          case AnimationType.breathe:
            return Transform.scale(
              scale: _animation.value,
              child: letter,
            );
          case AnimationType.rotate:
            return Transform.rotate(
              angle: _animation.value,
              child: letter,
            );
        }
      },
    );
  }
}

// Interactive Glowing Letter
class InteractiveGlowingLetter extends StatefulWidget {
  final String letter;
  final double size;
  final Color? baseColor;
  final Color? tapColor;

  const InteractiveGlowingLetter({
    Key? key,
    required this.letter,
    this.size = 50,
    this.baseColor,
    this.tapColor,
  }) : super(key: key);

  @override
  _InteractiveGlowingLetterState createState() => _InteractiveGlowingLetterState();
}

class _InteractiveGlowingLetterState extends State<InteractiveGlowingLetter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  late Color baseColor;
  late Color tapColor;

  @override
  void initState() {
    super.initState();

    baseColor = widget.baseColor ?? Colors.white;
    tapColor = widget.tapColor ?? Colors.red;

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
      begin: baseColor,
      end: tapColor,
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
            child: GlowingLetter(
              letter: widget.letter,
              size: widget.size,
              color: _colorAnimation.value ?? baseColor,
              glowType: GlowType.intense,
            ),
          );
        },
      ),
    );
  }
}

// Custom Painted Glowing Letter
class CustomPaintedGlowingLetter extends StatelessWidget {
  final String letter;
  final double size;
  final Color color;

  const CustomPaintedGlowingLetter({
    Key? key,
    required this.letter,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GlowingLetterPainter(letter: letter, color: color),
      ),
    );
  }
}

class GlowingLetterPainter extends CustomPainter {
  final String letter;
  final Color color;

  GlowingLetterPainter({required this.letter, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter.toUpperCase(),
        style: TextStyle(
          fontSize: size.width * 0.8,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final center = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Create glow layers
    final glowLayers = [
      (color.withOpacity(0.1), 20.0),
      (color.withOpacity(0.3), 12.0),
      (color.withOpacity(0.6), 6.0),
    ];

    // Draw glow layers
    for (final (glowColor, blurRadius) in glowLayers) {
      final glowPaint = Paint()
        ..color = glowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

      canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);
      textPainter.paint(canvas, center);
      canvas.restore();
    }

    // Draw main letter
    textPainter.paint(canvas, center);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
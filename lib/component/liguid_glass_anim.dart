import 'dart:ui';
import 'package:flutter/material.dart';

class Glass extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double sigma;
  final double opacity;
  final List<Color>? colors;
  final Border? border;
  final double elevation;
  final Color shadowColor;
  final Clip clipBehavior;

  const Glass({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 16.0,
    this.sigma = 10.0,
    this.opacity = 0.2,
    this.colors,
    this.border,
    this.elevation = 8.0,
    this.shadowColor = Colors.black26,
    this.clipBehavior = Clip.antiAlias,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultColors = [
      Colors.white.withOpacity(opacity),
      Colors.white.withOpacity(opacity * 0.5),
    ];

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0
            ? [
          BoxShadow(
            color: shadowColor,
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
          ),
        ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors ?? defaultColors,
              ),
              border: border ??
                  Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.0,
                  ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Example Usage and Demo
class GlassDemo extends StatefulWidget {
  const GlassDemo({Key? key}) : super(key: key);

  @override
  State<GlassDemo> createState() => _GlassDemoState();
}

class _GlassDemoState extends State<GlassDemo>
    with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late AnimationController _pulseController;
  late AnimationController _cardController;
  late Animation<double> _buttonScale;
  late Animation<double> _pulseAnimation;
  late Animation<double> _cardSlide;
  late Animation<double> _cardFade;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    // Button tap animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Pulse effect animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Card entrance animation
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cardSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeIn),
    );

    // Start entrance animation
    _cardController.forward();
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _pulseController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _onButtonPressed() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    // Button press animation
    await _buttonController.forward();
    await _buttonController.reverse();

    // Pulse animation
    _pulseController.repeat(reverse: true);

    // Stop pulse after 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    _pulseController.stop();
    _pulseController.reset();

    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AnimatedBuilder(
              animation: Listenable.merge([_cardController, _pulseController]),
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card with entrance animation
                    Transform.translate(
                      offset: Offset(0, _cardSlide.value),
                      child: Opacity(
                        opacity: _cardFade.value,
                        child: AnimatedScale(
                          scale: _pulseAnimation.value,
                          duration: const Duration(milliseconds: 100),
                          child: Glass(
                            padding: const EdgeInsets.all(20),
                            borderRadius: 20,
                            child: Column(
                              children: [
                                TweenAnimationBuilder(
                                  duration: const Duration(milliseconds: 1000),
                                  tween: Tween<double>(begin: 0, end: 1),
                                  builder: (context, value, child) {
                                    return Transform.rotate(
                                      angle: value * 2 * 3.14159,
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Glassmorphism Design',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Modern frosted glass effect',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Stats Row with staggered animation
                    Row(
                      children: [
                        _buildAnimatedStatCard('1.2K', 'Downloads', 0),
                        const SizedBox(width: 12),
                        _buildAnimatedStatCard('4.8', 'Rating', 200),
                        const SizedBox(width: 12),
                        _buildAnimatedStatCard('24', 'Reviews', 400),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Feature List with slide-in animation
                    Transform.translate(
                      offset: Offset(0, _cardSlide.value * 0.5),
                      child: Opacity(
                        opacity: _cardFade.value,
                        child: Glass(
                          padding: const EdgeInsets.all(20),
                          borderRadius: 18,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Features',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildFeatureItem('Customizable blur intensity'),
                              _buildFeatureItem('Flexible sizing and padding'),
                              _buildFeatureItem('Custom gradient colors'),
                              _buildFeatureItem('Elegant border effects'),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Animated Action Button
                    AnimatedBuilder(
                      animation: _buttonController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _buttonScale.value,
                          child: GestureDetector(
                            onTap: _onButtonPressed,
                            child: Glass(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              borderRadius: 25,
                              colors: [
                                Colors.white.withOpacity(_isAnimating ? 0.4 : 0.3),
                                Colors.white.withOpacity(_isAnimating ? 0.2 : 0.1),
                              ],
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: _isAnimating
                                      ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Processing...',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                      : const Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedStatCard(String value, String label, int delay) {
    return Expanded(
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 800 + delay),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, animationValue, child) {
          return Transform.translate(
            offset: Offset(0, (1 - animationValue) * 30),
            child: Opacity(
              opacity: animationValue,
              child: Glass(
                padding: const EdgeInsets.all(16),
                borderRadius: 16,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder(
                      duration: Duration(milliseconds: 1000 + delay),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, countValue, child) {
                        String displayValue = value;
                        if (value.contains('K')) {
                          double numValue = double.parse(value.replaceAll('K', ''));
                          displayValue = '${(numValue * countValue).toStringAsFixed(1)}K';
                        } else if (value.contains('.')) {
                          double numValue = double.parse(value);
                          displayValue = (numValue * countValue).toStringAsFixed(1);
                        } else {
                          int numValue = int.parse(value);
                          displayValue = (numValue * countValue).round().toString();
                        }

                        return Text(
                          displayValue,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 20,
            color: Colors.white70,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// Main method to run the app
void main() {
  runApp(const GlassApp());
}

class GlassApp extends StatelessWidget {
  const GlassApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const GlassDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Alternative Glass variants for different use cases
class GlassCard extends Glass {
  const GlassCard({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding = const EdgeInsets.all(16),
    double borderRadius = 16,
  }) : super(
    key: key,
    child: child,
    width: width,
    height: height,
    padding: padding,
    borderRadius: borderRadius,
  );
}

class GlassButton extends Glass {
  final VoidCallback? onTap;

  const GlassButton({
    Key? key,
    required Widget child,
    this.onTap,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
    double borderRadius = 12,
  }) : super(
    key: key,
    child: child,
    width: width,
    height: height,
    padding: padding,
    borderRadius: borderRadius,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: super.build(context),
    );
  }
}
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
class GlassDemo extends StatelessWidget {
  const GlassDemo({Key? key}) : super(key: key);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Glass(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 20,
                  child: Column(
                    children: const [
                      Icon(
                        Icons.auto_awesome,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Glassmorphism Design',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Modern frosted glass effect',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: Glass(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 16,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '1.2K',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Downloads',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Glass(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 16,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Rating',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Glass(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 16,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '24',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Feature List
                Glass(
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

                const Spacer(),

                // Action Button
                Glass(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: 25,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                  child: const Center(
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
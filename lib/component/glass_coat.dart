import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCoat extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color color;

  const GlassCoat({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    this.borderRadius = 25,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          height: height,
          constraints: const BoxConstraints(minHeight: 50, minWidth: 50),
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

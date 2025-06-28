import 'package:flutter/material.dart';
import 'package:winksy/mixin/constants.dart';

/// A reusable chat typing bubble widget with animated dots
class ChatTypingBubble extends StatefulWidget {
  /// Background color of the bubble
  final Color bubbleColor;

  /// Color of the typing dots
  final Color dotColor;

  /// Size of each typing dot
  final double dotSize;

  /// Padding inside the bubble
  final EdgeInsets padding;

  /// Border radius of the bubble
  final double borderRadius;

  /// Whether to show "typing" text
  final bool showTypingText;

  /// Custom typing text (default: "typing")
  final String typingText;

  /// Animation duration for each dot cycle
  final Duration animationDuration;

  /// Whether to show shadow
  final bool showShadow;

  /// Shadow color
  final Color shadowColor;

  /// Animation style for dots
  final TypingAnimationStyle animationStyle;

  const ChatTypingBubble({
    Key? key,
    this.bubbleColor = Colors.white,
    this.dotColor = const Color(0xFF9E9E9E),
    this.dotSize = 6.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 20.0,
    this.showTypingText = true,
    this.typingText = 'typing',
    this.animationDuration = const Duration(milliseconds: 600),
    this.showShadow = true,
    this.shadowColor = const Color(0x1A000000),
    this.animationStyle = TypingAnimationStyle.wave,
  }) : super(key: key);

  @override
  State<ChatTypingBubble> createState() => _ChatTypingBubbleState();
}

enum TypingAnimationStyle {
  wave,     // Sequential scaling wave effect
  pulse,    // All dots pulse together
  bounce,   // Dots bounce up and down
  fade,     // Dots fade in and out
}

class _ChatTypingBubbleState extends State<ChatTypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.bubbleColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.showShadow
            ? [
          BoxShadow(
            color: widget.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showTypingText) ...[
            Text(
              widget.typingText,
              style: TextStyle(
                color: widget.dotColor,
                fontSize: FONT_TITLE,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 8),
          ],
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.only(
                      right: index < 2 ? 4 : 0,
                    ),
                    child: _buildAnimatedDot(index),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    switch (widget.animationStyle) {
      case TypingAnimationStyle.wave:
        return _buildWaveDot(index);
      case TypingAnimationStyle.pulse:
        return _buildPulseDot(index);
      case TypingAnimationStyle.bounce:
        return _buildBounceDot(index);
      case TypingAnimationStyle.fade:
        return _buildFadeDot(index);
    }
  }

  Widget _buildWaveDot(int index) {
    double delay = index * 0.2;
    double animationValue = _animation.value;

    double dotScale = 1.0;
    if (animationValue > delay && animationValue < delay + 0.3) {
      double progress = (animationValue - delay) / 0.3;
      dotScale = 1.0 + (progress * 0.8);
    }

    return Transform.scale(
      scale: dotScale,
      child: _buildDot(),
    );
  }

  Widget _buildPulseDot(int index) {
    double scale = 1.0 + (_animation.value * 0.5);
    return Transform.scale(
      scale: scale,
      child: _buildDot(),
    );
  }

  Widget _buildBounceDot(int index) {
    double delay = index * 0.2;
    double animationValue = (_animation.value + delay) % 1.0;
    double bounceValue = 0.0;

    if (animationValue < 0.5) {
      bounceValue = animationValue * 2;
    } else {
      bounceValue = 2 - (animationValue * 2);
    }

    return Transform.translate(
      offset: Offset(0, -bounceValue * 8),
      child: _buildDot(),
    );
  }

  Widget _buildFadeDot(int index) {
    double delay = index * 0.3;
    double animationValue = (_animation.value + delay) % 1.0;
    double opacity = 0.3 + (animationValue * 0.7);

    return Opacity(
      opacity: opacity,
      child: _buildDot(),
    );
  }

  Widget _buildDot() {
    return Container(
      width: widget.dotSize,
      height: widget.dotSize,
      decoration: BoxDecoration(
        color: widget.dotColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

// Demo usage
void main() {
  runApp(const ChatTypingDemo());
}

class ChatTypingDemo extends StatelessWidget {
  const ChatTypingDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Typing Bubble Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DemoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  bool _showTyping = true;
  TypingAnimationStyle _currentStyle = TypingAnimationStyle.wave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Chat Typing Bubble'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Show Typing: '),
                        Switch(
                          value: _showTyping,
                          onChanged: (value) {
                            setState(() {
                              _showTyping = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Animation Style:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: TypingAnimationStyle.values.map((style) {
                        return ChoiceChip(
                          label: Text(_getStyleName(style)),
                          selected: _currentStyle == style,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _currentStyle = style;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Demo bubbles
            const Text(
              'Different Styles:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            if (_showTyping) ...[
              // Current selected style
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  ChatTypingBubble(
                    animationStyle: _currentStyle,
                    bubbleColor: Colors.white,
                    dotColor: Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Different color variations
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const ChatTypingBubble(
                    bubbleColor: Color(0xFFE3F2FD),
                    dotColor: Colors.blue,
                    showTypingText: false,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const ChatTypingBubble(
                    bubbleColor: Color(0xFFE8F5E8),
                    dotColor: Colors.green,
                    typingText: 'Alice is typing',
                    animationStyle: TypingAnimationStyle.bounce,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const ChatTypingBubble(
                    bubbleColor: Color(0xFFF3E5F5),
                    dotColor: Colors.purple,
                    dotSize: 8,
                    animationStyle: TypingAnimationStyle.fade,
                    animationDuration: Duration(milliseconds: 800),
                  ),
                ],
              ),
            ] else
              const Center(
                child: Text(
                  'Toggle "Show Typing" to see the animations',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            const Spacer(),

            // Usage example code
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usage Example:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ChatTypingBubble(\n'
                          '  bubbleColor: Colors.white,\n'
                          '  dotColor: Colors.grey,\n'
                          '  animationStyle: TypingAnimationStyle.wave,\n'
                          ')',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStyleName(TypingAnimationStyle style) {
    switch (style) {
      case TypingAnimationStyle.wave:
        return 'Wave';
      case TypingAnimationStyle.pulse:
        return 'Pulse';
      case TypingAnimationStyle.bounce:
        return 'Bounce';
      case TypingAnimationStyle.fade:
        return 'Fade';
    }
  }
}
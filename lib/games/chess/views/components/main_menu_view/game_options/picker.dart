import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Assuming TextSmall is a custom widget - you may need to adjust this import
// import 'package:your_app/widgets/text_small.dart'; // Replace with actual path

// If TextSmall doesn't exist, here's a simple implementation:
class TextSmall extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;

  const TextSmall(
      this.text, {
        Key? key,
        this.color,
        this.fontWeight,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontFamily: 'Jura',
      ),
    );
  }
}

class Picker<T extends Object> extends StatelessWidget {
  final String? label;
  final Map<T, Text>? options;
  final T? selection;
  final Function(T?)? setFunc;

  const Picker({
    Key? key,
    this.label,
    this.options,
    this.selection,
    this.setFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSmall(label ?? ""),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          child: CupertinoTheme(
            data: const CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(fontFamily: 'Jura', fontSize: 8),
              ),
            ),
            child: CupertinoSlidingSegmentedControl<T>(
              children: options ?? <T, Text>{},
              groupValue: selection,
              onValueChanged: (T? val) {
                if (setFunc != null) {
                  setFunc!(val);
                }
              },
              thumbColor: const Color(0x88FFFFFF),
              backgroundColor: const Color(0x20000000),
            ),
          ),
        )
      ],
    );
  }
}
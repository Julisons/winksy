import 'package:flutter/material.dart';

class IZeroResult extends StatelessWidget {
  final Function() onRefresh;
  final String message;
  const IZeroResult({Key? key, required this.onRefresh, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.error_outline, color: Colors.redAccent),
        label: Text(
          message,
          style: const TextStyle(wordSpacing: 2),
        ),
        onPressed: () {
          onRefresh();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }
}

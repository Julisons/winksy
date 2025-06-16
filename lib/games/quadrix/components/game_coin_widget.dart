import 'package:flutter/material.dart';

import '../models/coin.dart';


// ignore: must_be_immutable
class GameCoinWidget extends StatelessWidget {
  GameCoinWidget({super.key, required this.coin});

  Coin coin;

  @override
  Widget build(BuildContext context) {
    double size = (MediaQuery.of(context).size.width - 20) / 7;
   // print('Coin color: ${coin.color}');

    return Container(
      height: size,
      width: size,
      color: Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5),
      alignment: Alignment.center,
      child: Container(
        height: size,
        width: size,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            radius: 0.8,
            colors: [
              coin.color.withOpacity(0.9),
              coin.color.withOpacity(0.6),
              coin.color.withOpacity(0.3),
            ],
            stops: const [0.1, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}

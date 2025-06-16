import 'package:flutter/material.dart';

import '../../../theme/custom_colors.dart';
import '../models/coin.dart';


// ignore: must_be_immutable
class GameCoinWidget extends StatelessWidget {
  GameCoinWidget({super.key, required this.coin});

  Coin coin;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    double size = (MediaQuery.of(context).size.width - 20) / 7;
    return Container(
      height: size,
      width: size,
      color: Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5),
      alignment: Alignment.center,
      child: Container(
        height: size,
        width: size,
        margin: const EdgeInsets.all(2),
        decoration: coin.color == color.xSecondaryColor ?
        BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            radius: 0.8,
            colors: [
              coin.color.withOpacity(0.8),
              coin.color.withOpacity(0.9),
              coin.color.withOpacity(0.9),
              coin.color.withOpacity(0.9),
              coin.color.withOpacity(0.9),
            ],
            stops: const [0.1, 0.5, 1.0, 1.0, 1.0],
          ),
          boxShadow: [

          ],
        ):
        BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            radius: 0.8,
            colors: [
              coin.color.withOpacity(0.9),
              coin.color.withOpacity(0.5),
              coin.color.withOpacity(0.2),
            ],
            stops: const [0.1, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: color.xPrimaryColor.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}

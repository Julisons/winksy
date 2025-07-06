import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/mixin/constants.dart';

import '../../../theme/custom_colors.dart';
import '../utils/game_logic.dart';

class PlayerTurnWidget extends StatefulWidget {
  const PlayerTurnWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerTurnWidget> createState() => PlayerTurnWidgetState();
}

class PlayerTurnWidgetState extends State<PlayerTurnWidget> {
  
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          buildColorBox(selectedPlayer: player, selected: player == 1, color: color.xPrimaryColor),
          const SizedBox(width: 10),
          const Spacer(),
          buildText(text: quadPlayer, color: color.xTrailing),
          const Spacer(),
          buildColorBox(selectedPlayer: player, selected: player == 2, color: color.xPrimaryColor),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Container buildColorBox(
      {required bool selected, required int selectedPlayer, required Color color}) {
    return Container(
      height: 0,
      width: 0,
      decoration: BoxDecoration(
        color: !selected
            ? color
            : (selectedPlayer == 1)
            ? playerOneColor
            : playerTwoColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Text buildText({required String text, required Color color}) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: FONT_APP_BAR,
      ),
      textAlign: TextAlign.center,
    );
  }
}

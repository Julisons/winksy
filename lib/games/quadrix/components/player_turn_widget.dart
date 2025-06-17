import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      color: color.xPrimaryColor,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          buildColorBox(selectedPlayer: player, selected: player == 1, color: color.xTextColor),
          const SizedBox(width: 10),
          buildText(text: 'Player 1 ', color: color.xTextColor),
          const Spacer(),
          buildColorBox(selectedPlayer: player, selected: player == 2, color: color.xTextColor),
          const SizedBox(width: 10),
          buildText(text: 'Player 2', color: color.xTextColor),
        ],
      ),
    );
  }

  Container buildColorBox(
      {required bool selected, required int selectedPlayer, required Color color}) {
    return Container(
      height: 20,
      width: 20,
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
      style: GoogleFonts.aBeeZee(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),

      textAlign: TextAlign.center,
    );
  }
}

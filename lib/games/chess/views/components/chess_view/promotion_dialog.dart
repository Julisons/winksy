
import 'package:flutter/cupertino.dart';
import 'package:winksy/games/chess/logic/chess_piece.dart' show ChessPieceType;
import 'package:winksy/games/chess/model/app_model.dart' show AppModel;
import 'package:winksy/games/chess/views/components/chess_view/promotion_option.dart';

const PROMOTIONS = [
  ChessPieceType.queen,
  ChessPieceType.rook,
  ChessPieceType.bishop,
  ChessPieceType.knight
];

class PromotionDialog extends StatelessWidget {
  final AppModel appModel;

  PromotionDialog(this.appModel);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      actions: [
        Container(
          height: 66,
          child: Row(
            children: PROMOTIONS
                .map(
                  (promotionType) => PromotionOption(
                    appModel,
                    promotionType,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

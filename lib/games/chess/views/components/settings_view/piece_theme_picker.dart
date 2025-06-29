
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:winksy/games/chess/model/app_model.dart' show AppModel;
import 'package:winksy/games/chess/views/components/settings_view/piece_preview.dart' show PiecePreview;
import 'package:winksy/games/chess/views/components/shared/text_variable.dart' show TextRegular, TextSmall;

class PieceThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            child: TextSmall('Piece Theme'),
            padding: EdgeInsets.all(10),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Container(
              height: 120,
              decoration: BoxDecoration(color: Color(0x20000000)),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: appModel.pieceThemeIndex,
                      ),
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                        background: Color(0x20000000),
                      ),
                      itemExtent: 50,
                      onSelectedItemChanged: appModel.setPieceTheme,
                      children: appModel.pieceThemes
                          .map(
                            (theme) => Container(
                              padding: EdgeInsets.all(10),
                              child: TextRegular(theme),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Container(
                    height: 120,
                    width: 80,
                    child: GameWidget(
                      game: PiecePreview(appModel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

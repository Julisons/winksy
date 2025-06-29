
import 'package:flutter/cupertino.dart';
import 'package:winksy/games/chess/model/app_model.dart' show AppModel;
import 'package:winksy/games/chess/views/components/chess_view/game_info_and_controls/rounded_alert_button.dart';

class RestartExitButtons extends StatelessWidget {
  final AppModel appModel;

  RestartExitButtons(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RoundedAlertButton(
            'Restart',
            onConfirm: () {
              appModel.newGame(context);
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: RoundedAlertButton(
            'Exit',
            onConfirm: () {
              appModel.exitChessView();
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

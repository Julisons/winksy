
import 'package:flutter/material.dart';
import 'package:winksy/games/chess/model/app_model.dart' show AppModel;
import 'package:winksy/games/chess/views/components/chess_view/game_info_and_controls/timer_widget.dart';

class Timers extends StatelessWidget {
  final AppModel appModel;

  Timers(this.appModel);

  @override
  Widget build(BuildContext context) {
    return appModel.timeLimit != 0
        ? Column(
            children: [
              Container(
                child: Row(
                  children: [
                    TimerWidget(
                      timeLeft: appModel.player1TimeLeft,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    TimerWidget(
                      timeLeft: appModel.player2TimeLeft,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
            ],
          )
        : Container();
  }
}

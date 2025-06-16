import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../component/app_bar.dart';
import '../components/game_board.dart';
import '../components/player_turn_widget.dart';
import '../utils/game_logic.dart';

// ignore: must_be_immutable
class Quadrix extends StatefulWidget {
  Quadrix({super.key});

  @override
  State<Quadrix> createState() => _QuadrixState();
}

class _QuadrixState extends State<Quadrix> {
  GlobalKey<GameBoardState> gameBoardKey = GlobalKey<GameBoardState>();

  GlobalKey<PlayerTurnWidgetState> playerTurnKey =
      GlobalKey<PlayerTurnWidgetState>();

  @override
  Widget build(BuildContext context) {
    var appBar = IAppBar(title: 'Quadrix',);
    return Scaffold(
      appBar:appBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).appBarTheme.backgroundColor as Color,
            ],
            stops: const [0.45, 1],
          ),
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
            ),
            GameBoard(
              key: gameBoardKey,
              playerTurnKey: playerTurnKey,
              gameBoardKey: gameBoardKey,
            ),
            Positioned(
              top: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          appBar.preferredSize.height) /
                      2 -
                  (MediaQuery.of(context).size.width - 20) / 2 -
                  50,
              child: PlayerTurnWidget(key: playerTurnKey),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Restart game',
        child: InkWell(
          onTap: () {
            setState(() {});
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Text("Do You Really Want To Restart ?"),
                    actions: [
                      TextButton(
                          onPressed: (() {
                            Navigator.pop(context);
                            return onRestart(
                              gameBoardKey: gameBoardKey,
                              playerTurnKey: playerTurnKey,
                              context: context,
                            );
                          }),
                          child: Text("Yes"))
                    ],
                  );
                });
          },
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white10,
            ),
            alignment: Alignment.center,
            child: const Text(
              'Give Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

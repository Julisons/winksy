library;

import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/screen/home/home.dart';
// user files

import '../../component/button.dart';
import '../../component/glow2.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';
import 'ludo.dart';


class ILudoDashboard extends StatefulWidget {
  const ILudoDashboard({super.key, this.selectedPlayerCount});
  final int? selectedPlayerCount;

  @override
  ILudoDashboardState createState() => ILudoDashboardState();
}

class ILudoDashboardState extends State<ILudoDashboard> {
  int? selectedPlayerCount;

  @override
  void initState() {
    super.initState();
    selectedPlayerCount = widget.selectedPlayerCount;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.xPrimaryColor,
              color.xSecondaryColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedGlowingLetter(
                        letter: 'LUDO',
                        size: GAME_TITLE,
                        color: color.xTrailingAlt,
                        animationType: AnimationType.breathe,
                      ),
                      SizedBox(
                          width: 30.w,
                          child: Text('', style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary))),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Flexible(
                    child: Padding(
                      padding:  EdgeInsets.only(left: 16.w,right: 16.w),
                      child: Text(
                        'Welcome to Chess! '
                            'Enter the battlefield of kings and queens in this ultimate strategy game. '
                            'Outsmart your opponent with clever tactics and masterful moves. '
                            'Play casually with friends or challenge yourself in competitive mode. '
                            'Think ahead, plan wisely — every move counts in the game of champions.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: FONT_13,
                          color: color.xTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
             Expanded(
               flex: 1,
               child: Column(
                 children: [
                   Text(
                    'Select Number of Players',
                    style: TextStyle(
                        fontSize: FONT_TITLE,
                        fontWeight: FontWeight.bold,
                        color: color.xTextColorSecondary),
                               ),
                   SizedBox(height: 50.h),
                               IButton(
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const SecondScreen(selectedPlayerCount: 2),
                        ),
                      );
                    },
                    isBlack: false,
                    text: "2  player game",
                    color: color.xTrailing,
                    textColor: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.8,
                               ),
                               const SizedBox(height: 20),
                               IButton(
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameApp(
                              selectedTeams: ['BP', 'RP', 'GP', 'YP']),
                        ),
                      );
                    },
                    isBlack: false,
                    text: "4  player game",
                    color: color.xTrailing,
                    textColor: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.8,
                               ),
                 ],
               ),
             ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final int? selectedPlayerCount;

  const SecondScreen({super.key, this.selectedPlayerCount});

  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  List<String> selectedTeams = [];
  int? selectedOption; // New state variable to track selected radio option

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.xSecondaryColor,
              color.xPrimaryColor,
            ],
          ),
        ),
        child: Center(
          child: Builder(
            builder: (context) {
              switch (widget.selectedPlayerCount) {
                case 2:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedGlowingLetter(
                            letter: 'LUDO',
                            size: GAME_TITLE,
                            color: color.xTrailingAlt,
                            animationType: AnimationType.breathe,
                          ),
                          SizedBox(
                              width: 30.w,
                              child: Text('', style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary))),
                        ],
                      ),
                      SizedBox(height: 16.h,),
                      Flexible(
                        child: Padding(
                          padding:  EdgeInsets.only(left: 16.w,right: 16.w),
                          child: Text(
                            'Welcome to Chess! '
                                'Enter the battlefield of kings and queens in this ultimate strategy game. '
                                'Outsmart your opponent with clever tactics and masterful moves. '
                                'Play casually with friends or challenge yourself in competitive mode. '
                                'Think ahead, plan wisely — every move counts in the game of champions.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: FONT_13,
                              color: color.xTextColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100.h),
                      Text(
                        'Select Number of Players',
                        style: TextStyle(
                            fontSize: FONT_TITLE,
                            fontWeight: FontWeight.bold,
                            color: color.xTextColorSecondary),
                      ),
                      SizedBox(height: 70.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width/1.5,
                            height: 60.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:color.xSecondaryColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GameApp(
                                        selectedTeams: ['BP', 'GP']),
                                  ),
                                );
                              }, // Empty onPressed action
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TokenDisplay(color: Colors.blue),
                                      SizedBox(width: 6.h),
                                      Text(
                                        'Player 1',
                                        style: TextStyle(
                                          fontSize: FONT_13,
                                          color: color.xTextColorSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TokenDisplay(color: Colors.green),
                                      SizedBox(width: 6.h),
                                      Text(
                                        'Player 2',
                                        style: TextStyle(
                                          fontSize: FONT_13,
                                          color: color.xTextColorSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width/1.5,
                            height: 60.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:color.xSecondaryColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GameApp(
                                        selectedTeams: ['RP', 'YP']),
                                  ),
                                );
                              }, // Empty onPressed action
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TokenDisplay(color: Colors.red),
                                      SizedBox(width: 6.h),
                                      Text(
                                        'Player 1',
                                        style: TextStyle(
                                          fontSize: FONT_13,
                                          color: color.xTextColorSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TokenDisplay(color: Colors.yellow),
                                      SizedBox(width: 6.h),
                                      Text(
                                        'Player 2',
                                        style: TextStyle(
                                          fontSize: FONT_13,
                                          color: color.xTextColorSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                case 4:
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GameApp(selectedTeams: selectedTeams),
                        ),
                      );
                    },
                    child: const Text('4 Players Selected'),
                  );
                default:
                  return const Text('Invalid Player Count');
              }
            },
          ),
        ),
      ),
    );
  }
}

class GameApp extends StatefulWidget {
  final List<String> selectedTeams;

  const GameApp({super.key, required this.selectedTeams});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  Ludo? game;

  @override
  void initState() {
    super.initState();
    game = Ludo(widget.selectedTeams, context); // Initialize game instance
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic) {
        _showExitConfirmationDialog();
      },
      child: Scaffold(
          body: Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.xPrimaryColor,
                  color.xPrimaryColor,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: FittedBox(
                    child: SizedBox(
                        width: screenWidth,
                        height: screenWidth + screenWidth * 0.70,
                        child: GameWidget(game: game!)),
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }

  void _showExitConfirmationDialog() {
    final color = Theme.of(context).extension<CustomColors>()!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          backgroundColor: color.xSecondaryColor,
          title: Text(
            'QUIT GAME',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color.xTextColorSecondary,
              fontSize: FONT_TITLE,
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width/1.5,
            padding: EdgeInsets.all(16.h),
            child: Text('Are you sure you want to quit the game?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FONT_13,
                color: color.xTextColorSecondary,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          actions: <Widget>[
            IButton(
              text: "Resume",
              color: color.xPrimaryColor,
              textColor: Colors.white,
              height: 40.h,
              width: MediaQuery.of(context).size.width/3.5,
              onPress:(){
                Navigator.of(context).pop();
              },
            ),
            IButton(
              text: "Quit game",
              color: color.xTrailingAlt,
              height: 40.h,
              width: MediaQuery.of(context).size.width/3.5,
              textColor: Colors.white,
              fontWeight: FontWeight.bold,
              onPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => IHome()),
                );
              },
            )
          ],
        );
      },
    );
  }
}

class TokenDisplay extends StatelessWidget {
  final Color color;

  const TokenDisplay({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CustomColors>()!;
    return CustomPaint(
      size: Size(36.h, 36.h), // Adjust size as needed
      painter: TokenPainter(
        fillPaint: Paint()..color = color
                          ..strokeWidth = 50
                          ..blendMode = BlendMode.darken,
        borderPaint: Paint()
          ..color = colors.xPrimaryColor
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke,
      ),
    );
  }
}

class TokenPainter extends CustomPainter {
  final Paint fillPaint;
  final Paint borderPaint;

  TokenPainter({
    required this.fillPaint,
    required this.borderPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final outerRadius = size.width / 2;
    final smallerCircleRadius = outerRadius / 1.1;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, outerRadius, Paint()..color = Colors.white);
    canvas.drawCircle(center, outerRadius, borderPaint);
    canvas.drawCircle(center, smallerCircleRadius, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlayArea extends RectangleComponent with HasGameReference<Ludo> {
  PlayArea() : super(children: [RectangleHitbox()]);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}

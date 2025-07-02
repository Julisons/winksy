import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/tic_tac_toe/tic_tac_toe_game.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../model/user.dart';
import '../../theme/custom_colors.dart';

class ITicTacToeAISetup extends StatefulWidget {
  ITicTacToeAISetup({super.key});

  @override
  State<ITicTacToeAISetup> createState() => _ITicTacToeAISetupState();
}

class _ITicTacToeAISetupState extends State<ITicTacToeAISetup> {
  String selectedDifficulty = 'Medium';
  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: IAppBar(title: 'AI Challenge', leading: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.xSecondaryColor,
              color.xPrimaryColor,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Icon(
                Icons.smart_toy,
                size: 80.r,
                color: Colors.green,
              ),
              SizedBox(height: 20.h),
              Text(
                'Choose AI Difficulty',
                style: GoogleFonts.poppins(
                  fontSize: FONT_TITLE,
                  fontWeight: FontWeight.bold,
                  color: color.xTextColorSecondary,
                ),
              ),
              SizedBox(height: 30.h),
              ...difficulties.map((difficulty) => Container(
                margin: EdgeInsets.only(bottom: 12.r),
                child: Card(
                  color: selectedDifficulty == difficulty 
                      ? Colors.green 
                      : color.xSecondaryColor,
                  elevation: ELEVATION,
                  child: ListTile(
                    title: Text(
                      difficulty,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FONT_TITLE,
                        color: selectedDifficulty == difficulty 
                            ? Colors.white 
                            : color.xTextColorSecondary,
                      ),
                    ),
                    subtitle: Text(
                      _getDifficultyDescription(difficulty),
                      style: TextStyle(
                        fontSize: FONT_13,
                        color: selectedDifficulty == difficulty 
                            ? Colors.white70 
                            : color.xTextColor,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedDifficulty = difficulty;
                      });
                    },
                  ),
                ),
              )).toList(),
              Spacer(),
              IButton(
                text: 'Start AI Game',
                color: Colors.green,
                textColor: Colors.white,
                height: 50.h,
                width: double.infinity,
                onPress: () {
                  _startAIGame();
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  String _getDifficultyDescription(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 'Perfect for beginners - AI makes random moves 70% of the time';
      case 'Medium':
        return 'Good challenge - AI blocks obvious wins and takes opportunities';
      case 'Hard':
        return 'Expert level - Advanced minimax algorithm with perfect play';
      default:
        return '';
    }
  }

  void _startAIGame() {
    Mixin.quad = Quad()
      ..quadType = 'AI_MODE'
      ..quadUser = Mixin.user?.usrFirstName
      ..quadUsrId = Mixin.user?.usrId
      ..quadAgainst = 'AI ($selectedDifficulty)'
      ..quadAgainstId = 'AI_OPPONENT'
      ..quadFirstPlayerId = Mixin.user?.usrId
      ..quadStatus = 'PAIRED'
      ..quadDesc = selectedDifficulty;

    Mixin.winkser = User()
      ..usrId = 'AI_OPPONENT'
      ..usrFullNames = 'AI ($selectedDifficulty)';

    Mixin.navigate(context, ITicTacToeGame());
  }
}
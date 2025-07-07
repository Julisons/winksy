import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../model/user.dart';
import '../../theme/custom_colors.dart';
import 'chess_game.dart';

class IChessAISetup extends StatefulWidget {
  const IChessAISetup({Key? key}) : super(key: key);

  @override
  State<IChessAISetup> createState() => _IChessAISetupState();
}

class _IChessAISetupState extends State<IChessAISetup> {
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
              color.xPrimaryColor,
              color.xPrimaryColor,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0.r),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              
              // Title
              Text(
                'Chess AI Challenge',
                style: GoogleFonts.quicksand(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: color.xTextColorSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 20.h),
              
              // Description
              Text(
                'Choose your difficulty level and challenge our chess AI. Test your skills against different levels of artificial intelligence.',
                style: GoogleFonts.poppins(
                  fontSize: FONT_13,
                  color: color.xTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 50.h),
              
              // Difficulty selection
              Text(
                'Select Difficulty',
                style: GoogleFonts.quicksand(
                  fontSize: FONT_TITLE,
                  fontWeight: FontWeight.bold,
                  color: color.xTextColorSecondary,
                ),
              ),
              
              SizedBox(height: 30.h),
              
              ...difficulties.map((difficulty) => Container(
                margin: EdgeInsets.only(bottom: 15.h),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedDifficulty = difficulty;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: selectedDifficulty == difficulty 
                          ? color.xTrailingAlt.withOpacity(0.1)
                          : color.xSecondaryColor,
                      border: Border.all(
                        color: selectedDifficulty == difficulty 
                            ? color.xTrailingAlt 
                            : color.xSecondaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedDifficulty == difficulty 
                              ? Icons.radio_button_checked 
                              : Icons.radio_button_unchecked,
                          color: selectedDifficulty == difficulty 
                              ? color.xTrailingAlt 
                              : color.xTextColor,
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                difficulty,
                                style: GoogleFonts.quicksand(
                                  fontSize: FONT_TITLE,
                                  fontWeight: FontWeight.bold,
                                  color: color.xTextColorSecondary,
                                ),
                              ),
                              Text(
                                _getDifficultyDescription(difficulty),
                                style: GoogleFonts.poppins(
                                  fontSize: FONT_13,
                                  color: color.xTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )).toList(),
              
              Spacer(),
              
              // Start game button
              IButton(
                onPress: () {
                  _startAIGame();
                },
                text: 'Start AI Challenge',
                color: color.xTrailingAlt,
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50.h,
              ),
              
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getDifficultyDescription(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 'Perfect for beginners. AI makes occasional mistakes.';
      case 'Medium':
        return 'Balanced gameplay. Good for intermediate players.';
      case 'Hard':
        return 'Challenging AI. Recommended for experienced players.';
      default:
        return '';
    }
  }
  
  void _startAIGame() {
    // Create Guest user (AI opponent)
    Mixin.winkser = User()
      ..usrId = 'CHESS_AI_OPPONENT'
      ..usrFullNames = 'Chess AI ($selectedDifficulty)';
    
    // Set up quad for AI mode
    Mixin.quad = Quad()
      ..quadId = DateTime.now().millisecondsSinceEpoch.toString()
      ..quadType = 'AI_MODE'
      ..quadAgainst = 'Chess AI'
      ..quadUsrId = Mixin.user?.usrId
      ..quadAgainstId = 'CHESS_AI_OPPONENT'
      ..quadFirstPlayerId = Mixin.user?.usrId
      ..quadStatus = 'PAIRED'
      ..quadDesc = selectedDifficulty;

    // Navigate to chess game
    Mixin.navigate(context, IChessGame());
  }
}
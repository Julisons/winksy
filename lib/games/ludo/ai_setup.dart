import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/ludo/ludo_dashboard.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../model/user.dart';
import '../../theme/custom_colors.dart';

class ILudoAISetup extends StatefulWidget {
  ILudoAISetup({super.key});

  @override
  State<ILudoAISetup> createState() => _ILudoAISetupState();
}

class _ILudoAISetupState extends State<ILudoAISetup> {
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
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              FaIcon(FontAwesomeIcons.robot, size: 60.w),
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
                      ? color.xTrailingAlt 
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
                color: color.xTrailing,
                textColor: Colors.white,
                height: 50.h,
                width: double.infinity,
                onPress: () {
                  _startAIGame();
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  String _getDifficultyDescription(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 'Perfect for beginners - AI makes simple moves and focuses on basic strategy';
      case 'Medium':
        return 'Good challenge - AI uses smart tactics and blocks opponents when possible';
      case 'Hard':
        return 'Expert level - Advanced AI with strategic planning and aggressive gameplay';
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

    // Navigate to AI game with player vs AI setup
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GameApp(selectedTeams: ['BP', 'RP']), // Player is blue, AI is red
      ),
    );
  }
}
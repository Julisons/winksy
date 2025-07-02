import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/quadrix/core/game_screen.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../model/user.dart';
import '../../theme/custom_colors.dart';

class IAISetup extends StatefulWidget {
  IAISetup({super.key});

  @override
  State<IAISetup> createState() => _IAISetupState();
}

class _IAISetupState extends State<IAISetup> {
  
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
              FaIcon(FontAwesomeIcons.robot,size: 60.w,),
              SizedBox(height: 20.h),
              Text(
                'AI Challenge',
                style: GoogleFonts.poppins(
                  fontSize: FONT_TITLE,
                  fontWeight: FontWeight.bold,
                  color: color.xTextColorSecondary,
                ),
              ),
              SizedBox(height: 30.h),
              Card(
                color: color.xTrailingAlt,
                elevation: ELEVATION,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Text(
                        'Expert AI',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FONT_TITLE,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Advanced negamax algorithm with deep tactical analysis and comprehensive threat detection',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: FONT_13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
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

  void _startAIGame() {
    Mixin.quad = Quad()
      ..quadType = 'AI_MODE'
      ..quadUser = Mixin.user?.usrFirstName
      ..quadUsrId = Mixin.user?.usrId
      ..quadAgainst = 'Expert AI'
      ..quadAgainstId = 'AI_OPPONENT'
      ..quadFirstPlayerId = Mixin.user?.usrId
      ..quadStatus = 'PAIRED'
      ..quadDesc = 'Hard';

    Mixin.winkser = User()
      ..usrId = 'AI_OPPONENT'
      ..usrFullNames = 'Expert AI';

    Mixin.navigate(context, IQuadrixScreen());
  }
}
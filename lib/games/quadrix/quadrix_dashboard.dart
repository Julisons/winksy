import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flame_audio/flame_audio.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/quadrix/quadrix.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/screen/zoo/zoo.dart';

import '../../component/app_bar.dart';
import '../../component/glow2.dart';
import '../../mixin/mixins.dart';
import '../../model/quad.dart';
import '../../model/user.dart';
import '../../request/urls.dart';
import '../../theme/custom_colors.dart';
import '../fame_hall/fame_hall.dart';

class ListItem {
  final String title;
  final String desc;
  final IconData icon;
  ListItem({required this.title, required this.desc, required this.icon});
}

class IQuadrixDashboard extends StatefulWidget {
  IQuadrixDashboard({super.key});

  @override
  State<IQuadrixDashboard> createState() => _IQuadrixDashboardState();
}

class _IQuadrixDashboardState extends State<IQuadrixDashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<ListItem> items = [
    ListItem(title: 'Start Game', desc: 'Connect and play with others instantly', icon: Icons.wifi_tethering,),
    ListItem(title: 'Invite a Friend', desc: 'Challenge someone you know to a fun game', icon: Icons.person_outline,),
    ListItem(title: 'Hall of Fame', desc: 'Manage your account settings', icon: Icons.account_circle_outlined),
    ListItem(title: 'How to play', desc: 'Players you recently competed against',  icon: Icons.group),
    ListItem(title: 'Game Settings', desc: 'Customize your gameplay preferences', icon: Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
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
              SizedBox(height: 100.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedGlowingLetter(
                    letter: 'QUADRIX',
                    size: GAME_TITLE,
                    color: color.xTrailingAlt,
                    animationType: AnimationType.breathe,
                  ),
                  SizedBox(width: 30.w),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Text(
                  'Welcome to Quadrix! This is a game where you can challenge your friends and family in a fun and strategic way. Choose from various game modes and customize your experience to suit your preferences.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: FONT_13,
                    color: color.xTextColor,
                  ),
                ),
              ),
              Spacer(), // This pushes the ListView to the bottom
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    color: color.xSecondaryColor,
                    elevation: ELEVATION,
                    margin: EdgeInsets.only(bottom: 8.r), // Added margin back for spacing
                    child: SizedBox(
                      height: 100.h,
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.r, // Balanced left and right padding
                          vertical: 12.r,   // Equal top and bottom padding
                        ),
                        leading: Icon(
                          Icons.arrow_forward_ios,
                          color: color.xTextColorSecondary,
                        ),
                        title: Text(
                          items[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_TITLE,
                            color: color.xTextColorSecondary,
                          ),
                        ),
                        subtitle: Text(
                          items[index].desc,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_13,
                            color: color.xTextColor,
                          ),
                        ),
                        onTap: () async {
                          switch (items[index].title.toUpperCase()) {
                            case 'START GAME':
                              Mixin.navigate(context, IQuadrix());
                              break;
                            case 'HOW TO PLAY':
                              Mixin.navigate(context, IQuadrix());
                              break;
                            case 'HALL OF FAME':
                              Mixin.navigate(context, IFameHall(quadType: 'QUADRIX'));
                              break;
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
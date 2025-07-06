import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/quadrix/core/game_screen.dart';
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
import 'chess.dart';
import 'chess_promotion.dart';

class ListItem {
  final String title;
  final String desc;
  final IconData icon;
  ListItem({required this.title, required this.desc, required this.icon});
}

class IChessDashboard extends StatefulWidget {

  IChessDashboard({super.key});

  @override
  State<IChessDashboard> createState() => _IChessDashboardState();
}

class _IChessDashboardState extends State<IChessDashboard> {

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
        child: Padding(
          padding:  EdgeInsets.all(16.0.r),
          child: Column(
            children: [
              // Top section with title and description
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 100.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedGlowingLetter(
                          letter: 'CHESS',
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

              SizedBox(height: 20.h),

              // Bottom section with ListView items - now properly aligned
              Column(
                children: items.map((item) => Card(
                  color: color.xSecondaryColor,
                  elevation: ELEVATION,
                  margin: EdgeInsets.only(bottom: 16.r),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 20.r, right: 12.r,bottom: 12.r,top: 12.r),
                    leading: Icon(Icons.arrow_forward_ios, color: color.xTextColorSecondary,),
                    title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_TITLE,color: color.xTextColorSecondary)),
                    subtitle: Padding(
                      padding:  EdgeInsets.only(top: 6.r),
                      child: Text(item.desc,style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_13,color: color.xTextColor)),
                    ),
                    onTap: () {
                      switch(item.title.toUpperCase()){
                        case 'START GAME':
                          Mixin.navigate(context, IChess());
                          break;
                        case 'HOW TO PLAY':
                          Mixin.navigate(context, IChessPromotion());
                          break;
                        case 'HALL OF FAME':
                          Mixin.navigate(context, IFameHall(quadType: CHESS));
                          break;
                      }
                    },
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
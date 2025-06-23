import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/quadrix/core/game_screen.dart';
import 'package:winksy/games/quadrix/fame_hall/fame_hall.dart';
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



class ListItem {
  final String title;
  final String desc;
  final IconData icon;
  ListItem({required this.title, required this.desc, required this.icon});
}

class ITicTacToeDashboard extends StatefulWidget {

  ITicTacToeDashboard({super.key});

  @override
  State<ITicTacToeDashboard> createState() => _ITicTacToeDashboardState();
}

class _ITicTacToeDashboardState extends State<ITicTacToeDashboard> {

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
      appBar:IAppBar(title: 'Tic Tac Toe', leading: false,),
      body: Padding(
        padding:  EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 100.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedGlowingLetter(
                        letter: 'TIC TAC TOE',
                        size: FONT_APP_BAR,
                        color: color.xTrailingAlt,
                        animationType: AnimationType.breathe,
                      ),
                      SizedBox(
                          width: 30.w,
                          child: Text('', style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary))),
                    ],
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/1.4,
                    child: Text('Welcome to Tic Tac Toe!'
                      'Outsmart your opponent in this timeless game of Xs and Os.'
                      'Play against friends or challenge yourself in single-player mode.'
                      'Customize your board, choose your symbol, and make your move!'
                      'It\'s simple, fast, and fun — every tap could be the winning one.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: FONT_13,
                        color: color.xTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: items.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    color: color.xSecondaryColor,
                    elevation: ELEVATION,
                    margin: EdgeInsets.only(bottom: 16.r),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 20.r, right: 12.r,bottom: 12.r,top: 12.r),
                      leading: Icon(Icons.arrow_forward_ios, color: color.xTextColorSecondary,),
                      title: Text(items[index].title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_TITLE,color: color.xTextColorSecondary)),
                      subtitle: Padding(
                        padding:  EdgeInsets.only(top: 6.r),
                        child: Text(items[index].desc,style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_13,color: color.xTextColor)),
                      ),
                      onTap: () {
                        switch(items[index].title.toUpperCase()){
                          case 'START GAME':
                            Mixin.navigate(context, IQuadrix());
                            break;
                          case 'HOW TO PLAY':
                            Mixin.navigate(context, IQuadrix());
                            break;
                          case 'HALL OF FAME':
                            Mixin.navigate(context, IFameHall());
                            break;
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/quadrix/core/game_screen.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/screen/zoo/zoo.dart';

import '../../component/app_bar.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';



class ListItem {
  final String title;
  final String desc;
  final IconData icon;
  ListItem({required this.title, required this.desc, required this.icon});
}

class IQuadrix extends StatefulWidget {

  IQuadrix({super.key});

  @override
  State<IQuadrix> createState() => _IQuadrixState();
}

class _IQuadrixState extends State<IQuadrix> {
  late Timer _timer;
  late var loading = '...';
  final String loading1 = '.';
  final String loading2 = '..';
  final String loading3 = '...';

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec, (Timer timer) {
          setState(() {
            if (loading.isEmpty) {
              loading = '.';
            } else if (loading.length == 1) {
              loading = loading2;
            } else if (loading.length == 2) {
              loading = loading3;
            } else if (loading.length == 3) {
              loading = '';
            }
          });
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final List<ListItem> items = [
    ListItem(title: 'Hall of Fame', desc: 'Manage your account settings', icon: Icons.account_circle_outlined),
    ListItem(title: 'How to play', desc: 'Players you recently competed against',  icon: Icons.group),
    ListItem(title: 'Game Settings', desc: 'Customize your gameplay preferences', icon: Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar:IAppBar(title: 'Quadrix',),
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
                      Text('Waiting for opponent', style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary)),
                      SizedBox(
                          width: 30.w,
                          child: Text(loading, style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_APP_BAR,color: color.xTextColorSecondary))),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text('Welcome to Quadrix! This is a game where you can challenge your friends and family in a fun and strategic way. Choose from various game modes and customize your experience to suit your preferences.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: FONT_13,
                      color: color.xTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${items[index].title} tapped')),
                        );
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
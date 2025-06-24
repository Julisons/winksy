import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
//import 'package:winksy/games/chess/chess_dashboard.dart';

import 'package:winksy/games/quadrix/core/game_screen.dart';
import 'package:winksy/games/quadrix/quadrix.dart';
import 'package:winksy/games/quadrix/quadrix_dashboard.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/screen/zoo/zoo.dart';

import ' tic_tac_toe/tic_tac_toe.dart';
import ' tic_tac_toe/tic_tac_toe_dashboard.dart';
import '../component/app_bar.dart';
import '../mixin/mixins.dart';
import '../theme/custom_colors.dart';
import 'chess/chess_dashboard.dart';
import 'ludo/ludo_dashboard.dart';

class ListItem {
  final String title;
  final String desc;
  final FaIcon icon;
  ListItem({required this.title, required this.desc, required this.icon});
}

class Item {
  final String title;
  final String desc;
  final String icon;
  Item({required this.title, required this.desc, required this.icon});
}

class IGames extends StatefulWidget {
  IGames({super.key});

  @override
  State<IGames> createState() => _IGamesState();
}

class _IGamesState extends State<IGames> {
  final List<ListItem> items = [
    ListItem(
        title: 'My Account',
        desc: 'Manage your account settings',
        icon: FaIcon(FontAwesomeIcons.userLarge)),
    ListItem(
        title: 'My Recent Opponents',
        desc: 'Players you recently competed against',
        icon: FaIcon(FontAwesomeIcons.peopleGroup)),
    ListItem(
        title: 'Game Settings',
        desc: 'Customize your gameplay preferences',
        icon: FaIcon(FontAwesomeIcons.screwdriverWrench)),
  ];

  final List<Item> games = [
    Item(title: 'Friend Zoo', desc: '', icon: '🐯'),
    Item(title: 'Quadrix', desc: '', icon: '🏐'),
    Item(title: 'Ludo', desc: '', icon: '🎲'),
    Item(title: 'Tic Tac Toe', desc: '', icon: '✖'),
    Item(title: 'Daily Spin', desc: '', icon: '🎡'),
    Item(title: 'Chess', desc: '', icon: '♟️'),
  ];

  @override
  void initState() {
    ///Initialize images and precache it
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.wait([
        precacheImage(const AssetImage("assets/images/thankyou.gif"), context),
        precacheImage(const AssetImage("assets/images/board.png"), context),
        precacheImage(const AssetImage("assets/images/dice/1.png"), context),
        precacheImage(const AssetImage("assets/images/dice/2.png"), context),
        precacheImage(const AssetImage("assets/images/dice/3.png"), context),
        precacheImage(const AssetImage("assets/images/dice/4.png"), context),
        precacheImage(const AssetImage("assets/images/dice/5.png"), context),
        precacheImage(const AssetImage("assets/images/dice/6.png"), context),
        precacheImage(const AssetImage("assets/images/dice/draw.gif"), context),
        precacheImage(const AssetImage("assets/images/crown/1st.png"), context),
        precacheImage(const AssetImage("assets/images/crown/2nd.png"), context),
        precacheImage(const AssetImage("assets/images/crown/3rd.png"), context),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: IAppBar(title: 'Games', leading: false,),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: GridView.builder(
                itemCount: games.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: .8,
                ),
                itemBuilder: (context, index) {
                  final item = games[index];
                  return GestureDetector(
                    onTap: () {
                      switch (item.title) {
                        case 'Friend Zoo':
                          Mixin.navigate(context, IZoo());
                          break;
                        case 'Quadrix':
                          Mixin.navigate(context, IQuadrixDashboard());
                          break;
                        case 'Tic Tac Toe':
                          Mixin.navigate(context, ITicTacToeDashboard());
                          break;
                        case 'Chess':
                          Mixin.navigate(context, IChessDashboard());
                          break;
                        case 'Ludo':
                          Mixin.navigate(context, ILudoDashboard());
                          break;
                      }
                    },
                    child: Card(
                      color: color.xSecondaryColor,
                      elevation: ELEVATION,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text( item.icon,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FONT_ICON,
                                color: color.xTextColorSecondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FONT_TITLE,
                                color: color.xTextColorSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.r), // spacing between sections
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(items.length, (index) {
                  return Card(
                    color: color.xSecondaryColor,
                    elevation: ELEVATION,
                    margin: EdgeInsets.only(bottom: 16.r),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.r,
                        right: 12.r,
                        bottom: 12.r,
                        top: 12.r,
                      ),
                      leading: IconButton(
                        color: color.xTextColor,
                        onPressed: () {},
                        icon: items[index].icon,
                        iconSize: 30.r,
                      ),
                      title: Text(
                        items[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FONT_TITLE,
                          color: color.xTextColorSecondary,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 6.r),
                        child: Text(
                          items[index].desc,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_13,
                            color: color.xTextColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${items[index].title} tapped')),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
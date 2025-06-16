import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winksy/games/quadrix/core/game_screen.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/screen/zoo/zoo.dart';

import '../component/app_bar.dart';
import '../mixin/mixins.dart';
import '../theme/custom_colors.dart';


class ListItem {
  final String title;
  final String desc;
  final IconData icon;
  ListItem({required this.title, required this.desc, required this.icon});
}

class IGames extends StatefulWidget {

  IGames({super.key});

  @override
  State<IGames> createState() => _IGamesState();
}

class _IGamesState extends State<IGames> {
  final List<ListItem> items = [
    ListItem(title: 'My Account', desc: 'Manage your account settings', icon: Icons.account_circle_outlined),
    ListItem(title: 'My Recent Opponents', desc: 'Players you recently competed against',  icon: Icons.group),
    ListItem(title: 'Game Settings', desc: 'Customize your gameplay preferences', icon: Icons.settings),
  ];

  final List<ListItem> games = [
    ListItem(title: 'Friend Zoo', desc: '', icon: Icons.pets),
    ListItem(title: 'Quadrix', desc: '',  icon: Icons.sports_baseball),
    ListItem(title: 'Crazy8', desc: '',  icon: Icons.credit_card)
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;


    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar:IAppBar(title: 'Games',),
      body: Padding(
        padding:  EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: games.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 items per row
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: .7, // Adjust to your UI preference
                ),
                itemBuilder: (context, index) {
                  final item = games[index];
                  return GestureDetector(
                    onTap: () {
                      switch(item.title)
                      {
                        case 'Friend Zoo':
                          Mixin.navigate(context,IZoo());
                          break;
                        case 'Quadrix':
                          Mixin.navigate(context,MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: ThemeData(
                              scaffoldBackgroundColor: const Color(0xff6E8894),
                              appBarTheme: const AppBarTheme(
                                backgroundColor: Color(0xff1a090d),
                                centerTitle: true,
                              ),
                            ),
                            title: 'Quadrix',
                            home: Quadrix()));
                          break;
                        case 'Crazy8':
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Coming soon!')));
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
                            Icon(item.icon,size: 60,color: color.xTextColor,),
                            SizedBox(height: 8),
                            Text(item.title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: FONT_TITLE,color: color.xTextColorSecondary)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
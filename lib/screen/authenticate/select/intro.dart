import 'package:winksy/component/button.dart';
import 'package:winksy/screen/authenticate/select/social_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../theme/custom_colors.dart';

class Intro extends StatelessWidget {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark 
            ? Brightness.light 
            : Brightness.dark,
        statusBarColor: Theme.of(context).colorScheme.surface));

    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      body: Padding(
        padding: EdgeInsets.only(left: 30.h, right: 30.h, bottom: 30.h, top: 43.h),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  Center(child:
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center, // Align widgets within the Stack
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/intro.jpg',
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.7,
                              fit: BoxFit.cover, // Adjust the image's scaling
                            ),
                          ),
                          Positioned(
                            bottom: 20, // Position the text near the bottom
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.4,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Love is Just a Wink Away.💞",
                                style: TextStyle(
                                  fontSize: FONT_START,
                                  fontWeight: FontWeight.bold,
                                  color: color.xTrailing,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1.5, 1.5),
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    Shadow(
                                      offset: Offset(-1, -1),
                                      blurRadius: 1,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/1.2,
                          child: Text("Your forever might be closer than you think. Winksy brings hearts together with just one meaningful glance.",
                              textAlign: TextAlign.center,
                              style: TextStyle( fontWeight: FontWeight.normal, color: color.xTextColor, fontSize: FONT_13)),
                        ),
                      ),
                    ],
                  )),
                  Center(child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center, // Align widgets within the Stack
                        children: [
                          SizedBox(height: 10,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/intro.jpg',
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.7,
                              fit: BoxFit.cover, // Adjust the image's scaling
                            ),
                          ),
                          Positioned(
                            bottom: 20, // Position the text near the bottom
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.4,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Where Hearts Find Home.💘",
                                style: TextStyle(
                                  fontSize: FONT_START,
                                  fontWeight: FontWeight.bold,
                                  color: color.xTrailing,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/1.2,
                          child: Text("Not just another match — it’s someone who feels like home from the very first hello.",
                              textAlign: TextAlign.center,
                              style: TextStyle( fontWeight: FontWeight.normal, color: color.xTextColor, fontSize: FONT_13)),
                        ),
                      ),
                    ],
                  )),
                  Center(child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center, // Align widgets within the Stack
                        children: [
                          SizedBox(height: 10,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/intro.jpg',
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.7,
                              fit: BoxFit.cover, // Adjust the image's scaling
                            ),
                          ),
                          Positioned(
                            bottom: 20, // Position the text near the bottom
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.4,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Chat. Connect. Challenge.🎲",
                                style: TextStyle(
                                  fontSize: FONT_START,
                                  fontWeight: FontWeight.bold,
                                  color: color.xTrailing,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/1.2,
                          child: Text(" Discover real people through quick 2D games and meaningful conversations.",
                              textAlign: TextAlign.center,
                              style: TextStyle( fontWeight: FontWeight.normal, color: color.xTextColor, fontSize: FONT_13)),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: _controller, // PageController
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: color.xTrailing,
                dotColor: color.xTextColor,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
            SizedBox(height: 20.h,),
            IButton(onPress: (){
              Mixin.prefString(pref: INTRO.toString(), key: INTRO);
              Mixin.navigate(context,  SocialIntro());

            }, text: 'Get Started', width: MediaQuery.of(context).size.width,
              color: color.xTrailing, textColor: Colors.white,isBlack: false,),
            SizedBox(height: 20.h,),
            SizedBox(
              width: 200,
              child: Text(" Closed Beta V1.0",
                  textAlign: TextAlign.center,
                  style: TextStyle( fontWeight: FontWeight.normal, color: Colors.white, fontSize: FONT_13)),
            ),
            SizedBox(height: 2.h,),
          ],
        ),
      ),
    );
  }
}

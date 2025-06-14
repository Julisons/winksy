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

    SystemChrome.setSystemUIOverlayStyle(  SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Theme.of(context).colorScheme.surface));

    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.only(left: 30.h, right: 30.h, bottom: 30.h, top: 43.h),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  Center(child: Column(
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
                              width: 208.w,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Organise your content",
                                style: TextStyle(
                                  fontSize: FONT_START,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      SizedBox(
                        width: 160.w,
                        child: Text("Store and watch your favourite links from YouTube, Vimeo, Twitch and much more.",
                            textAlign: TextAlign.center,
                            style: TextStyle( fontWeight: FontWeight.normal, color: Colors.white, fontSize: FONT_13)),
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
                              width: 208.w,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Discover other curators",
                                style: TextStyle(
                                  fontSize: FONT_START,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      SizedBox(
                        width: 160.w,
                        child: Text("Discover, follow and collaborate with other like minded curators on Breadcram™",
                            textAlign: TextAlign.center,
                            style: TextStyle( fontWeight: FontWeight.normal, color: Colors.white, fontSize: FONT_13)),
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
                              width: 208.w,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Build custom playlist",
                                style: TextStyle(
                                  fontSize: FONT_START,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      SizedBox(
                        width: 160.w,
                        child: Text(" Use folders to organise your stored links into custom playlist.",
                            textAlign: TextAlign.center,
                            style: TextStyle( fontWeight: FontWeight.normal, color: Colors.white, fontSize: FONT_13)),
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
                activeDotColor: Theme.of(context).colorScheme.tertiary,
                dotColor: Colors.white,
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

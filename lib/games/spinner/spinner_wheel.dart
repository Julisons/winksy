import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:winksy/provider/gift/treat_provider.dart';

import '../../model/treat.dart';
import '../../request/urls.dart';
import '../../theme/custom_colors.dart';

class ISpinner extends StatefulWidget {
  const ISpinner({super.key});

  @override
  State<ISpinner> createState() => _ISpinnerState();
}

class _ISpinnerState extends State<ISpinner> {
  StreamController<int> controller = StreamController<int>();
  int? outcome;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 20), () {
      Provider.of<ITreatProvider>(context, listen: false).refresh('', false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }

  void handleRoll() {

  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      body: Container(
        padding: EdgeInsets.all(23),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                elevation: 6,
                child: Consumer<ITreatProvider>(builder: (context, provider, child) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height/2,
                    child: Column(
                      children: [
                        Flexible(
                          child: FortuneWheel(
                            selected: controller.stream,
                            animateFirst: false,
                            hapticImpact: HapticImpact.light,
                            physics: CircularPanPhysics(
                              duration: Duration(seconds: 1),
                              curve: Curves.bounceInOut,
                            ),
                            indicators:  [
                              FortuneIndicator(
                                alignment: Alignment.topCenter,
                                child: TriangleIndicator(
                                  color: color.xTrailingAlt,
                                  width: 55.0.w,
                                  height: 130.0.h,
                                  elevation: 10,
                                ),
                              ),
                            ],
                            items: [
                              ..._losing90(
                                imagePath: "assets/images/icon.png",
                                color: color.xSecondaryColor.withAlpha(150),
                              ),
                            ],
                            onFling: () {
                              List<int> outcomes = [0, 1, 2];

                              setState(() {
                                outcome = outcomes[Random().nextInt(outcomes.length)];
                              });

                              controller.add(outcome ?? 1);
                            },
                            onAnimationEnd: () {
                              if (outcome == 0) {

                              } else {
                                // redirect to lose screen
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
               })
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FortuneItem> _losing90({required String imagePath, required Color color}) {
    final colors = Theme.of(context).extension<CustomColors>()!;
    List<Treat> list = Provider.of<ITreatProvider>(context, listen: false).list;
    List<FortuneItem> output = [];
    for (var item = 0; item < 9; item++) {
      imagePath = list[item].giftPath.startsWith('http')
          ? list[item].giftPath : '${IUrls.IMAGE_URL}/file/secured/${list[item].giftPath}';
      output.add(
        FortuneItem(
          child: RotatedBox(
            quarterTurns: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Column(
                children: [
                  Text('$item', style: TextStyle(color: colors.xTextColor),),
                  Image.network(
                    imagePath,
                    width: 55,
                  ),
                ],
              ),
            ),
          ),
          style: FortuneItemStyle(color: color, borderWidth: 0),
        ),
      );
    }
    return output;
  }
}
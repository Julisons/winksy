import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:winksy/component/extras.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/model/pet.dart';
import 'package:winksy/model/spinner.dart';
import 'package:winksy/provider/gift/spinner_provider.dart';
import 'package:winksy/provider/gift/treat_provider.dart';

import '../../component/button.dart';
import '../../component/loader.dart';
import '../../mixin/mixins.dart';
import '../../model/treat.dart';
import '../../request/posts.dart';
import '../../request/urls.dart';
import '../../theme/custom_colors.dart';

class ISpinner extends StatefulWidget {
  const ISpinner({super.key});

  @override
  State<ISpinner> createState() => _ISpinnerState();
}

class _ISpinnerState extends State<ISpinner> {
  StreamController<int> _controller = StreamController<int>();
  int? outcome;
  bool _isSpinning = false;
  late ConfettiController _controllerCenter;
  var price = '';
  late Pet _pet;
  late bool _shouldSpin = false;

  @override
   initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10),);

    _checkIfTOSpin();
  }

  Future<void> _checkIfTOSpin() async {
    String? stored = await Mixin.getPrefString(key: SPIN_DATE);
    if (stored != null) {
      DateTime? savedDate = DateTime.tryParse(stored);
      DateTime now = DateTime.now();

      bool isToday = savedDate != null &&
          savedDate.year == now.year &&
          savedDate.month == now.month &&
          savedDate.day == now.day;

      if (isToday) {
        print('✔️ The date is today');
      } else {
        print('❌ The date is not today');
        setState(() {
          _shouldSpin = true;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controllerCenter.dispose();
    _controller.close();
  }

  void _noSpin() {
    setState(() {
      price = "🎉 You've already spun today!\n\nPlease check again tomorrow for your next daily spin chance.";
      Mixin.showToast(context,  price, INFO);
    });
  }


  void handleRoll() {

    if (_isSpinning) return; // Prevent multiple spins

    setState(() {
      _isSpinning = true;
    });

    List<int> outcomes = [0, 1, 2];

    setState(() {
      outcome = outcomes[Random().nextInt(outcomes.length)];
    });

    _controller.add(outcome ?? 1);

    Mixin.prefString(pref: DateTime.now().toIso8601String(), key: SPIN_DATE);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      body: Container(
        padding: EdgeInsets.all(23),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path.
              child: SizedBox(
                width: MediaQuery.of(context).size.width/1.5,
                height: 100,
                child: Text(price,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color.xTextColorSecondary,
                ),),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              width: MediaQuery.of(context).size.width ,
              child: Consumer<ISpinnerProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading() && provider.list.isEmpty) {
                    return Center(child: Loading(dotColor: color.xTrailing));
                  } else {
                    return Column(
                      children: [
                        Flexible(
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            elevation: 6,
                            child: FortuneWheel(
                              selected: _controller.stream,
                              animateFirst: false,
                              hapticImpact: HapticImpact.light,
                              physics: CircularPanPhysics(
                                duration: Duration(seconds: 1),
                                curve: Curves.bounceInOut,
                              ),
                              indicators: [
                                FortuneIndicator(
                                  alignment: Alignment.topCenter,
                                  child: TriangleIndicator(
                                    color: color.xTrailingAlt,
                                    width: 40.0.w,
                                    height: 60.0.h,
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
                                if (_isSpinning) {
                                  return; // Prevent fling while spinning
                                }
                              //  handleRoll();
                              },
                              onAnimationEnd: () {
                                // Always reset spinning state when animation ends
                                setState(() {
                                  _isSpinning = false;
                                });

                                if (outcome == 0) {
                                  // Handle win
                                } else {
                                  // redirect to lose screen
                                }

                                _controllerCenter.play();

                                price = 'Congratulations you have won ${provider.list[outcome??0].spinAmount} winks';
                                Mixin.showToast(context, price, INFO);
                                _updateWinnings(provider.list[outcome??0].spinAmount);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        IButton(
                          onPress: _shouldSpin ? (_isSpinning ? null : handleRoll) : _noSpin,
                          text: _isSpinning ? 'Spinning...' : 'SPIN',
                          color: _isSpinning ? color.xSecondaryColor : color.xTrailing,
                          textColor: Colors.white,
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        SizedBox(height: 130.h),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FortuneItem> _losing90({
    required String imagePath,
    required Color color,
  }) {
    final colors = Theme.of(context).extension<CustomColors>()!;
    List<Spinner> list = Provider.of<ISpinnerProvider>(
      context,
      listen: false,
    ).list;

    // Add safety check for empty list
    if (list.isEmpty) {
      return [];
    }

    List<FortuneItem> output = [];

    for (var item = 0; item < list.length; item++) {
      imagePath = list[item].spinPath.startsWith('http')
          ? list[item].spinPath
          : '${IUrls.IMAGE_URL}/file/secured/${list[item].spinPath}';
      output.add(
        FortuneItem(
          child: RotatedBox(
            quarterTurns: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${NumberFormat('#,##0').format(list[item].spinAmount)} wnks',
                      style: TextStyle(
                        color: colors.xTextColor,
                        fontSize: FONT_13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Image.network(
                    imagePath,
                    width: 55,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error,
                        size: 55,
                        color: colors.xTextColor,
                      );
                    },
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

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }

  void _updateWinnings(int value){
    Pet pet = Pet()
     ..petUsrId = Mixin.user?.usrId
     ..petCash = value
     ..petAssets = value;

    IPost.postData(pet, (state, res, value) {
      setState(() {
        if (state) {
          debugPrint(jsonEncode(value));
          _pet = Pet.fromJson(jsonDecode(jsonEncode(value)));
          price +='.\nYou have a total of ${_pet.petCash} wnks';

        } else {
          Mixin.errorDialog(context, 'ERROR', res);
        }
      });
    }, IUrls.PET());
  }
}


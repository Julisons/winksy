import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/custom_colors.dart';

class IQuadrixPromoScreen extends StatelessWidget {
  const IQuadrixPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(

      backgroundColor: color.xPrimaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'QUADRIX',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: color.xTrailing,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black45,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: color.xSecondaryColor, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    PromoBullet(text: 'Get 4 in a row to win'),
                    SizedBox(height: 15.h,),
                    PromoBullet(text: 'Connect with players instantly'),
                    SizedBox(height: 15.h,),
                    PromoBullet(text: 'Lots of fun'),
                    SizedBox(height: 15.h,),
                    PromoBullet(text: 'FREE of charge!'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration:
                      BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: const Alignment(-0.3, -0.3),
                          radius: 0.8,
                          colors: [
                            color.xTrailing.withOpacity(0.9),
                            color.xTrailing.withOpacity(0.5),
                            color.xTrailing.withOpacity(0.2),
                          ],
                          stops: const [0.1, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.xPrimaryColor.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      )
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'QUADRIX is a FUN & FREE live game. You can play against friends, alone or for cash prizes.',
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 23.r,),
              Row(
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      decoration:
                      BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: const Alignment(-0.3, -0.3),
                          radius: 0.8,
                          colors: [
                            color.xTrailingAlt.withOpacity(0.9),
                            color.xTrailingAlt.withOpacity(0.5),
                            color.xTrailingAlt.withOpacity(0.2),
                          ],
                          stops: const [0.1, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.xPrimaryColor.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      )
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Compete as see your rank at hall of fame',
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PromoBullet extends StatelessWidget {
  final String text;
  const PromoBullet({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
           Icon(Icons.add, size: 20, color: color.xTextColorSecondary,),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style:  TextStyle(
                fontSize: 16,
                color: color.xTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

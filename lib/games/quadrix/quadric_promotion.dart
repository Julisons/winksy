import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/component/app_bar.dart';
import 'package:winksy/games/quadrix/quadrix.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/button.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';

class IQuadricPromotion extends StatelessWidget {
  const IQuadricPromotion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xPrimaryColor, // Deep blue background
      appBar: IAppBar(leading: true, title: 'Quadrix',),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Overview Card
            _buildCard(
              title: '🎯 Game Overview',
              content: 'Quadrix is a strategy game where two players take turns dropping colored discs into a vertical grid. The first player to connect four of their discs in a row wins!',
              context: context,
            ),

            const SizedBox(height: 16),

            // Visual Grid Example
            _buildCard(
              title: '📋 The Game Board',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'The game is played on a 7×7 grid (7 columns, 7 rows):',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                  const SizedBox(height: 12),
                  _buildMiniGrid(context),
                ],
              ), context: context,
            ),

             SizedBox(height: 16.h),

            // How to Play Steps
            _buildCard(
              title: '🎮 How to Play',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep(1, 'Players take turns dropping discs', '🔴 Red player goes first', context),
                  SizedBox(height: 16.h),
                  _buildStep(2, 'Choose a column to drop your disc', '⬇️ Disc falls to the lowest available spot', context),
                  SizedBox(height: 16.h),
                  _buildStep(3, 'Try to connect 4 discs in a row', '↔️ Horizontal, ↕️ Vertical, or ↗️ Diagonal', context),
                  SizedBox(height: 16.h),
                  _buildStep(4, 'Block your opponent', '🛡️ Prevent them from getting 4 in a row', context),
                  SizedBox(height: 16.h),
                  _buildStep(5, 'First to connect 4 wins!', '🏆 Game ends immediately when someone wins', context),
                ],
              ), context: context,
            ),

             SizedBox(height: 16.h),

            // Winning Conditions
            _buildCard(
              title: '🏆 Ways to Win',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWinCondition(
                      'Horizontal',
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(4, (index) => Container(
                          width: 16.w,
                          height: 16.w,
                          margin: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF33232),
                            shape: BoxShape.circle,
                          ),
                        )),
                      ),
                      'Four in a row horizontally',
                      context
                  ),
                  _buildWinCondition(
                      'Vertical',
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(4, (index) => Container(
                          width: 16.w,
                          height: 16.w,
                          margin: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF33232),
                            shape: BoxShape.circle,
                          ),
                        )),
                      ),
                      'Four in a column vertically',
                      context
                  ),
                  _buildWinCondition(
                      'Diagonal',
                      SizedBox(
                        width: 70.w,
                        height: 70.w,
                        child: Stack(
                          children: [
                            Positioned(left: 0, top: 48, child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFFF33232), shape: BoxShape.circle))),
                            Positioned(left: 16, top: 32, child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFFF33232), shape: BoxShape.circle))),
                            Positioned(left: 32, top: 16, child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFFF33232), shape: BoxShape.circle))),
                            Positioned(left: 48, top: 0, child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFFF33232), shape: BoxShape.circle))),
                          ],
                        ),
                      ),
                      'Four in a diagonal line',
                      context
                  ),
                ],
              ), context: context,
            ),

            const SizedBox(height: 16),

            // Strategy Tips
            _buildCard(
              title: '💡 Strategy Tips',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTip('Control the center columns - they offer more winning opportunities',context),
                  _buildTip('Think ahead - consider what your opponent might do next',context),
                  _buildTip('Create multiple threats - force your opponent into difficult choices',context),
                  _buildTip('Watch for traps - don\'t give your opponent an easy win',context),
                  _buildTip('Build from the bottom up - discs stack on top of each other',context),
                ],
              ), context: context,
            ),

             SizedBox(height: 24.h),

            // Start Playing Button
            Center(
              child: IButton(
                onPress: () {
                  Mixin.navigate(context, IQuadrix());
                },
                text:'🎮 Start Playing!',
                color: color.xTrailing,
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width/1.4,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({String? title, String? content, Widget? child, required BuildContext context}) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.xSecondaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.xSecondaryColor.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style:  TextStyle(
                fontSize: FONT_TITLE,
                fontWeight: FontWeight.bold,
                color: color.xTextColorSecondary,
              ),
            ),
          if (title != null) const SizedBox(height: 12),
          if (content != null)
            Text(
              content,
              style:  TextStyle(
                fontSize: FONT_13,
                color: color.xTextColor,
                height: 1.5,
              ),
            ),
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildMiniGrid(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.xTrailing,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: List.generate(7, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(7, (col) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildStep(int number, String title, String description, BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration:  BoxDecoration(
              color: color.xTrailingAlt,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style:  TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: FONT_13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.bold,
                    color: color.xTextColorSecondary,
                  ),
                ),
                Text(
                  description,
                  style:  TextStyle(
                    fontSize: FONT_13,
                    color: color.xTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinCondition(String type, Widget visual, String description, BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:  EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.xPrimaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: visual,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style:  TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.bold,
                    color: color.xTextColorSecondary,
                  ),
                ),
                Text(
                  description,
                  style:  TextStyle(
                    fontSize: FONT_13,
                    color: color.xTextColor
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip, BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            '💡',
            style: TextStyle(fontSize: FONT_TITLE),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style:  TextStyle(
                fontSize: FONT_13,
                color: color.xTextColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
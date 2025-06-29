import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/component/app_bar.dart';
import 'package:winksy/games/tic_tac_toe/tic_tac_toe.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/button.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';

class ITicTacToePromotion extends StatelessWidget {
  const ITicTacToePromotion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: IAppBar(leading: true, title: 'Tic-Tac-Toe'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Overview Card
            _buildCard(
              title: '🎯 Game Overview',
              content: 'Tic-Tac-Toe is a classic strategy game for two players. Take turns placing your mark (X or O) on a 3×3 grid. The first player to get three of their marks in a row wins!',
              context: context,
            ),

            const SizedBox(height: 16),

            // Game Board Layout
            _buildCard(
              title: '🎲 The Game Board',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The game is played on a simple 3×3 grid:',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                  const SizedBox(height: 12),
                  _buildMiniGrid(context),
                  const SizedBox(height: 8),
                  Text(
                    'Nine empty squares where players can place their marks.',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // How to Play Steps
            _buildCard(
              title: '🎮 How to Play',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep(1, 'X always goes first', '❌ Player X makes the opening move', context),
                  SizedBox(height: 16.h),
                  _buildStep(2, 'Take turns placing marks', '⭕ Player O goes next, then alternate', context),
                  SizedBox(height: 16.h),
                  _buildStep(3, 'Choose an empty square', '📍 Tap any available space on the grid', context),
                  SizedBox(height: 16.h),
                  _buildStep(4, 'Try to get three in a row', '🎯 Line up your marks horizontally, vertically, or diagonally', context),
                  SizedBox(height: 16.h),
                  _buildStep(5, 'Block your opponent', '🛡️ Prevent them from getting three in a row', context),
                ],
              ),
              context: context,
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
                    _buildWinningLine(true, false, context),
                    'Three marks in the same row',
                    context,
                  ),
                  _buildWinCondition(
                    'Vertical',
                    _buildWinningLine(false, false, context),
                    'Three marks in the same column',
                    context,
                  ),
                  _buildWinCondition(
                    'Diagonal',
                    _buildWinningLine(false, true, context),
                    'Three marks in a diagonal line',
                    context,
                  ),
                ],
              ),
              context: context,
            ),

            const SizedBox(height: 16),

            // Game Examples
            _buildCard(
              title: '📖 Game Examples',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Here are some common game scenarios:',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                  const SizedBox(height: 12),
                  _buildGameExample('X Wins Horizontally', [
                    ['X', 'X', 'X'],
                    ['O', 'O', ''],
                    ['', '', '']
                  ], context),
                  SizedBox(height: 12.h),
                  _buildGameExample('O Wins Diagonally', [
                    ['O', 'X', 'X'],
                    ['X', 'O', ''],
                    ['', '', 'O']
                  ], context),
                  SizedBox(height: 12.h),
                  _buildGameExample('Draw Game', [
                    ['X', 'O', 'X'],
                    ['O', 'X', 'O'],
                    ['O', 'X', 'O']
                  ], context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Strategy Tips
            _buildCard(
              title: '💡 Strategy Tips',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTip('Start in the center - it gives you the most winning opportunities', context),
                  _buildTip('Take corners next - they\'re the second-best strategic positions', context),
                  _buildTip('Always block your opponent if they have two in a row', context),
                  _buildTip('Look for forks - create two ways to win at once', context),
                  _buildTip('Play defensively - sometimes preventing a loss is better than going for a win', context),
                  _buildTip('With perfect play from both sides, every game should end in a draw', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 24.h),

            // Start Playing Button
            Center(
              child: IButton(
                onPress: () {
                  Mixin.navigate(context, ITicTacToe());
                },
                text: '🎮 Start Playing!',
                color: color.xTrailing,
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width / 1.4,
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
              style: TextStyle(
                fontSize: FONT_TITLE,
                fontWeight: FontWeight.bold,
                color: color.xTextColorSecondary,
              ),
            ),
          if (title != null) const SizedBox(height: 12),
          if (content != null)
            Text(
              content,
              style: TextStyle(
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
        children: List.generate(3, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (col) {
              return Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                  borderRadius: BorderRadius.circular(4),
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
            decoration: BoxDecoration(
              color: color.xTrailingAlt,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
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
                  style: TextStyle(
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
            padding: EdgeInsets.all(8),
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
                  style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.bold,
                    color: color.xTextColorSecondary,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
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

  Widget _buildWinningLine(bool horizontal, bool diagonal, BuildContext context) {
    if (horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) => Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text('X', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        )),
      );
    } else if (diagonal) {
      return SizedBox(
        width: 66,
        height: 66,
        child: Stack(
          children: [
            Positioned(left: 0, top: 0, child: _buildWinSquare('X')),
            Positioned(left: 22, top: 22, child: _buildWinSquare('X')),
            Positioned(left: 44, top: 44, child: _buildWinSquare('X')),
          ],
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) => Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text('X', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        )),
      );
    }
  }

  Widget _buildWinSquare(String mark) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Text(mark, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildGameExample(String title, List<List<String>> board, BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Column(
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
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.xPrimaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: List.generate(3, (row) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (col) {
                  final mark = board[row][col];
                  return Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[400]!, width: 1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        mark,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: mark == 'X' ? Colors.red : (mark == 'O' ? Colors.blue : Colors.transparent),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ],
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
              style: TextStyle(
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
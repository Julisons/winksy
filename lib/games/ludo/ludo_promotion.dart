import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/component/app_bar.dart';
import 'package:winksy/games/ludo/ludo.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/button.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';

class ILudoPromotion extends StatelessWidget {
  const ILudoPromotion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: IAppBar(leading: true, title: 'Ludo'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Overview Card
            _buildCard(
              title: '🎲 Game Overview',
              content: 'Ludo is a classic board game for 2-4 players where you race to get all your tokens from start to finish! Roll the dice, move strategically, and capture opponents to become the Ludo champion!',
              context: context,
            ),

            const SizedBox(height: 16),

            // Game Board Layout
            _buildCard(
              title: '🏁 The Ludo Board',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The board has four colored zones and a central path:',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                  const SizedBox(height: 12),
                  _buildMiniBoard(context),
                  const SizedBox(height: 8),
                  Text(
                    'Each player has 4 tokens and a home area in their color.',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Players and Setup
            _buildCard(
              title: '👥 Players & Setup',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlayerInfo('🔴 Red Player', 'Top-right corner', 'Moves clockwise from start', context),
                  SizedBox(height: 12.h),
                  _buildPlayerInfo('🔵 Blue Player', 'Top-left corner', 'Moves clockwise from start', context),
                  SizedBox(height: 12.h),
                  _buildPlayerInfo('🟡 Yellow Player', 'Bottom-left corner', 'Moves clockwise from start', context),
                  SizedBox(height: 12.h),
                  _buildPlayerInfo('🟢 Green Player', 'Bottom-right corner', 'Moves clockwise from start', context),
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
                  _buildStep(1, 'Roll a 6 to start', '🎯 Only a 6 lets you move a token out of home', context),
                  SizedBox(height: 16.h),
                  _buildStep(2, 'Move your tokens clockwise', '↩️ Follow the path around the board', context),
                  SizedBox(height: 16.h),
                  _buildStep(3, 'Capture opponents', '💥 Land on their token to send it home', context),
                  SizedBox(height: 16.h),
                  _buildStep(4, 'Enter the home column', '🏠 Reach your colored home stretch', context),
                  SizedBox(height: 16.h),
                  _buildStep(5, 'Get all tokens to the center', '🏆 First player with all 4 tokens wins!', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Special Rules
            _buildCard(
              title: '✨ Special Rules',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSpecialRule('Rolling a 6', 'Get an extra turn', '🎲 Roll again after moving', context),
                  SizedBox(height: 12.h),
                  _buildSpecialRule('Three 6s in a row', 'Miss your turn', '⏭️ Pass the dice to next player', context),
                  SizedBox(height: 12.h),
                  _buildSpecialRule('Safe Squares', 'Cannot be captured', '🛡️ Colored squares and star squares', context),
                  SizedBox(height: 12.h),
                  _buildSpecialRule('Capturing', 'Send opponent home', '💥 Opponent must roll 6 to restart', context),
                  SizedBox(height: 12.h),
                  _buildSpecialRule('Exact Count', 'Must land exactly in center', '🎯 Can\'t overshoot the finish', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Winning Conditions
            _buildCard(
              title: '🏆 How to Win',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWinCondition(
                    'First Place',
                    Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 32),
                    'Get all 4 tokens to the center first',
                    context,
                  ),
                  _buildWinCondition(
                    'Second Place',
                    Icon(Icons.workspace_premium, color: Color(0xFFC0C0C0), size: 32),
                    'Second player to finish all tokens',
                    context,
                  ),
                  _buildWinCondition(
                    'Third Place',
                    Icon(Icons.military_tech, color: Color(0xFFCD7F32), size: 32),
                    'Third player to complete the journey',
                    context,
                  ),
                ],
              ),
              context: context,
            ),

            const SizedBox(height: 16),

            // Strategy Tips
            _buildCard(
              title: '💡 Strategy Tips',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTip('Spread your tokens - don\'t keep them all together', context),
                  _buildTip('Use safe squares strategically to avoid being captured', context),
                  _buildTip('Block opponents by occupying key squares in their path', context),
                  _buildTip('Capture opponents when possible to slow them down', context),
                  _buildTip('Plan your moves - think about where opponents might land', context),
                  _buildTip('Keep tokens in home until you have a clear path', context),
                  _buildTip('Use your 6s wisely - balance between starting new tokens and advancing existing ones', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Game Variations
            _buildCard(
              title: '🎭 Game Modes',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGameMode('Classic Ludo', '2-4 players, traditional rules', '🎲 The original experience', context),
                  SizedBox(height: 12.h),
                  _buildGameMode('Quick Ludo', 'Faster gameplay with modified rules', '⚡ Perfect for short sessions', context),
                  SizedBox(height: 12.h),
                  _buildGameMode('Team Ludo', 'Players form teams and help each other', '👥 Cooperative gameplay', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 24.h),

            // Start Playing Button
            Center(
              child: IButton(
                onPress: () {
                  Navigator.pop(context);
                },
                text: '🎲 Start Playing Ludo!',
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

  Widget _buildMiniBoard(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.xTrailing,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 125.h,
        height: 125.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          children: [
            // Top row
            Row(
              children: [
                _buildBoardSection(Colors.blue[300]!, 40.h, 40.h),
                _buildBoardSection(Colors.white, 40.h, 40.h),
                _buildBoardSection(Colors.red[300]!, 40.h, 40.h),
              ],
            ),
            // Middle row
            Row(
              children: [
                _buildBoardSection(Colors.white, 40.h, 40.h),
                _buildBoardSection(Colors.grey[300]!, 40.h, 40.h),
                _buildBoardSection(Colors.white, 40.h, 40.h),
              ],
            ),
            // Bottom row
            Row(
              children: [
                _buildBoardSection(Colors.yellow[300]!, 40.h, 40.h),
                _buildBoardSection(Colors.white, 40.h, 40.h),
                _buildBoardSection(Colors.green[300]!, 40.h, 40.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardSection(Color color, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: color != Colors.white && color != Colors.grey[300]
          ? Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      )
          : null,
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

  Widget _buildPlayerInfo(String player, String position, String movement, BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.xPrimaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                player.split(' ')[0], // Just the colored circle emoji
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player,
                  style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.bold,
                    color: color.xTextColorSecondary,
                  ),
                ),
                Text(
                  position,
                  style: TextStyle(
                    fontSize: FONT_13,
                    color: color.xTextColor,
                  ),
                ),
                Text(
                  movement,
                  style: TextStyle(
                    fontSize: FONT_13 - 1,
                    color: color.xTextColor.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialRule(String rule, String effect, String description, BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨',
            style: TextStyle(fontSize: FONT_TITLE),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule,
                  style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.bold,
                    color: color.xTextColorSecondary,
                  ),
                ),
                Text(
                  effect,
                  style: TextStyle(
                    fontSize: FONT_13,
                    color: color.xTextColor,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: FONT_13 - 1,
                    color: color.xTextColor.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
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

  Widget _buildGameMode(String mode, String description, String note, BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎭',
            style: TextStyle(fontSize: FONT_TITLE),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mode,
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
                Text(
                  note,
                  style: TextStyle(
                    fontSize: FONT_13 - 1,
                    color: color.xTextColor.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
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
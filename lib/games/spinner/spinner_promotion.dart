import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/component/app_bar.dart';
import 'package:winksy/games/spinner/spinner_wheel.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/button.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';

class IDailySpinPromotion extends StatelessWidget {
  const IDailySpinPromotion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: IAppBar(leading: true, title: 'Daily Spin'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Overview Card
            _buildCard(
              title: '🎡 Game Overview',
              content: 'Daily Spin is your chance to win amazing rewards every single day! Spin the wheel of fortune to collect coins, gems, power-ups, and exclusive prizes. The more consecutive days you play, the better your rewards become!',
              context: context,
            ),

            const SizedBox(height: 16),

            // Spin Wheel Visual
            _buildCard(
              title: '🎯 The Spin Wheel',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The wheel contains 8 exciting reward segments:',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                  const SizedBox(height: 12),
                  _buildSpinWheel(context),
                  const SizedBox(height: 8),
                  Text(
                    'Each segment offers different rewards with varying rarities.',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Available Rewards
            _buildCard(
              title: '🎁 Available Rewards',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReward('💰 Coins', '50 - 1000 coins', 'Common reward for purchases and upgrades', context),
                  SizedBox(height: 12.h),
                  _buildReward('💎 Gems', '5 - 100 gems', 'Premium currency for special items', context),
                  SizedBox(height: 12.h),
                  _buildReward('⚡ Power-ups', 'Various boosts', 'Game enhancers and special abilities', context),
                  SizedBox(height: 12.h),
                  _buildReward('🎫 Bonus Spins', '1 - 3 extra spins', 'Additional chances to win today', context),
                  SizedBox(height: 12.h),
                  _buildReward('🏆 Exclusive Items', 'Rare collectibles', 'Limited edition rewards and avatars', context),
                  SizedBox(height: 12.h),
                  _buildReward('🎊 Jackpot', 'Mega rewards', 'The ultimate prize with maximum value', context),
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
                  _buildStep(1, 'Visit daily', '📅 Come back every day for your free spin', context),
                  SizedBox(height: 16.h),
                  _buildStep(2, 'Tap to spin', '👆 Press the spin button to start the wheel', context),
                  SizedBox(height: 16.h),
                  _buildStep(3, 'Watch the wheel', '👀 See where the pointer lands', context),
                  SizedBox(height: 16.h),
                  _buildStep(4, 'Collect your reward', '🎁 Automatically added to your account', context),
                  SizedBox(height: 16.h),
                  _buildStep(5, 'Come back tomorrow', '🔄 Reset at midnight for next spin', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Streak Bonuses
            _buildCard(
              title: '🔥 Daily Streak Bonuses',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spin consecutive days to unlock better rewards:',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                  const SizedBox(height: 12),
                  _buildStreakBonus('Day 1', '1x rewards', '🌟 Standard spin rewards', context),
                  SizedBox(height: 8.h),
                  _buildStreakBonus('Day 3', '1.2x rewards', '⭐ 20% bonus multiplier', context),
                  SizedBox(height: 8.h),
                  _buildStreakBonus('Day 7', '1.5x rewards', '🌟 50% bonus multiplier', context),
                  SizedBox(height: 8.h),
                  _buildStreakBonus('Day 14', '2x rewards', '✨ Double all rewards!', context),
                  SizedBox(height: 8.h),
                  _buildStreakBonus('Day 30', '3x rewards', '🎆 Triple rewards + special prize!', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Special Features
            _buildCard(
              title: '✨ Special Features',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSpecialFeature('Lucky Hours', 'Double rewards during peak times', '🍀 Check daily for lucky hour notifications', context),
                  SizedBox(height: 12.h),
                  _buildSpecialFeature('Weekend Bonus', 'Extra reward segments on weekends', '🎉 Saturday and Sunday special wheels', context),
                  SizedBox(height: 12.h),
                  _buildSpecialFeature('VIP Wheels', 'Exclusive wheels for premium members', '👑 Access to rare and legendary prizes', context),
                  SizedBox(height: 12.h),
                  _buildSpecialFeature('Social Sharing', 'Bonus spins for sharing', '📱 Share your wins for extra chances', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Reward Tiers
            _buildCard(
              title: '🏅 Reward Tiers',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRewardTier(
                    'Common',
                    Colors.grey,
                    '60% chance',
                    'Basic coins and small power-ups',
                    context,
                  ),
                  _buildRewardTier(
                    'Rare',
                    Colors.blue,
                    '25% chance',
                    'Decent gems and useful items',
                    context,
                  ),
                  _buildRewardTier(
                    'Epic',
                    Colors.purple,
                    '10% chance',
                    'High-value rewards and bonus spins',
                    context,
                  ),
                  _buildRewardTier(
                    'Legendary',
                    Colors.orange,
                    '4% chance',
                    'Exclusive items and massive rewards',
                    context,
                  ),
                  _buildRewardTier(
                    'Jackpot',
                    Colors.red,
                    '1% chance',
                    'Ultimate prizes and mega bonuses',
                    context,
                  ),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Tips and Strategies
            _buildCard(
              title: '💡 Tips & Strategies',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTip('Set a daily reminder - consistency is key for streak bonuses', context),
                  _buildTip('Spin during lucky hours for doubled rewards when available', context),
                  _buildTip('Don\'t miss weekends - they often have special wheel configurations', context),
                  _buildTip('Save bonus spins for special events or when you need specific items', context),
                  _buildTip('Share your big wins on social media for potential bonus spins', context),
                  _buildTip('Check for seasonal events that might feature limited-time wheels', context),
                  _buildTip('Watch ads when offered - they might grant additional spins', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 24.h),

            // Spin Schedule Info
            _buildCard(
              title: '⏰ Spin Schedule',
              content: 'Your daily spin resets at midnight in your local timezone. Miss a day and your streak resets, but you can always start building it up again! Premium members get an additional spin every 12 hours.',
              context: context,
            ),

            SizedBox(height: 16.h),

            // Start Playing Button
            Center(
              child: IButton(
                onPress: () {
                  Mixin.navigate(context, ISpinner());
                },
                text: '🎡 Spin the Wheel!',
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

  Widget _buildSpinWheel(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.xTrailing,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Stack(
            children: [
              // Wheel segments
              ...List.generate(8, (index) {
                final colors = [
                  Colors.red[300]!,
                  Colors.blue[300]!,
                  color.xTrailingAlt[300]!,
                  Colors.yellow[300]!,
                  Colors.purple[300]!,
                  Colors.orange[300]!,
                  Colors.pink[300]!,
                  Colors.teal[300]!,
                ];
                return Transform.rotate(
                  angle: (index * 45) * 3.14159 / 180,
                  child: Container(
                    width: 120,
                    height: 120,
                    child: CustomPaint(
                      painter: WheelSegmentPainter(colors[index]),
                    ),
                  ),
                );
              }),
              // Center dot
              Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Pointer
              Positioned(
                top: 0,
                left: 54,
                child: Container(
                  width: 12,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildReward(String reward, String amount, String description, BuildContext context) {
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
                reward.split(' ')[0], // Just the emoji
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      reward,
                      style: TextStyle(
                        fontSize: FONT_TITLE,
                        fontWeight: FontWeight.bold,
                        color: color.xTextColorSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: FONT_13,
                        color: color.xTextColor.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: FONT_13 - 1,
                    color: color.xTextColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBonus(String day, String multiplier, String description, BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.xPrimaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FONT_13 - 1,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.xTrailingAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              multiplier,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FONT_13 - 1,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: FONT_13 - 1,
                color: color.xTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialFeature(String feature, String description, String note, BuildContext context) {
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
                  feature,
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

  Widget _buildRewardTier(String tier, Color tierColor, String chance, String description, BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: tierColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 80,
            child: Text(
              tier,
              style: TextStyle(
                fontSize: FONT_13,
                fontWeight: FontWeight.bold,
                color: color.xTextColorSecondary,
              ),
            ),
          ),
          Container(
            width: 70,
            child: Text(
              chance,
              style: TextStyle(
                fontSize: FONT_13 - 1,
                color: color.xTextColor.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: FONT_13 - 1,
                color: color.xTextColor,
              ),
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

class WheelSegmentPainter extends CustomPainter {
  final Color color;

  WheelSegmentPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      45 * 3.14159 / 180, // 45 degrees in radians
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
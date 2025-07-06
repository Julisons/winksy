import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/component/app_bar.dart';
import 'package:winksy/games/chess/chess.dart';
import 'package:winksy/mixin/constants.dart';

import '../../component/button.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';

class IChessPromotion extends StatelessWidget {
  const IChessPromotion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: IAppBar(leading: true, title: 'Chess'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Overview Card
            _buildCard(
              title: '♔ Game Overview',
              content: 'Chess is the ultimate strategy game where two players command armies of pieces. The goal is to capture your opponent\'s king while protecting your own. Master the art of tactics, strategy, and calculation!',
              context: context,
            ),

            const SizedBox(height: 16),

            // Chess Board Setup
            _buildCard(
              title: '♗ The Chess Board',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The game is played on an 8×8 board with 64 squares:',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                  const SizedBox(height: 12),
                  _buildMiniBoard(context),
                  const SizedBox(height: 8),
                  Text(
                    'Each player starts with 16 pieces: 8 pawns, 2 rooks, 2 knights, 2 bishops, 1 queen, and 1 king.',
                    style: TextStyle(fontSize: FONT_13, color: color.xTextColor),
                  ),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // Pieces and Their Moves
            _buildCard(
              title: '♞ The Chess Pieces',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPiece('♔ King', 'Moves one square in any direction', 'The most important piece - protect at all costs!', context),
                  SizedBox(height: 12.h),
                  _buildPiece('♕ Queen', 'Combines rook and bishop moves', 'The most powerful piece on the board', context),
                  SizedBox(height: 12.h),
                  _buildPiece('♖ Rook', 'Moves horizontally and vertically', 'Strong in open files and ranks', context),
                  SizedBox(height: 12.h),
                  _buildPiece('♗ Bishop', 'Moves diagonally any distance', 'Controls long diagonal lines', context),
                  SizedBox(height: 12.h),
                  _buildPiece('♘ Knight', 'Moves in an L-shape (2+1 squares)', 'Can jump over other pieces', context),
                  SizedBox(height: 12.h),
                  _buildPiece('♙ Pawn', 'Moves forward, captures diagonally', 'Can promote to any piece when reaching the end', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 16.h),

            // How to Play
            _buildCard(
              title: '🎯 How to Play',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep(1, 'White moves first', '♔ White pieces always start the game', context),
                  SizedBox(height: 16.h),
                  _buildStep(2, 'Move one piece per turn', '🎯 Choose your moves carefully', context),
                  SizedBox(height: 16.h),
                  _buildStep(3, 'Capture opponent pieces', '⚔️ Land on their square to capture', context),
                  SizedBox(height: 16.h),
                  _buildStep(4, 'Protect your king', '🛡️ Your king cannot be captured', context),
                  SizedBox(height: 16.h),
                  _buildStep(5, 'Checkmate to win!', '🏆 Trap the enemy king with no escape', context),
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
                    'Checkmate',
                    Icon(Icons.military_tech, color: Color(0xFFFFD700), size: 32),
                    'Enemy king is attacked and cannot escape',
                    context,
                  ),
                  _buildWinCondition(
                    'Resignation',
                    Icon(Icons.flag, color: Color(0xFFFF6B6B), size: 32),
                    'Opponent gives up the game',
                    context,
                  ),
                  _buildWinCondition(
                    'Timeout',
                    Icon(Icons.timer, color: Color(0xFF4ECDC4), size: 32),
                    'Opponent runs out of time (in timed games)',
                    context,
                  ),
                ],
              ),
              context: context,
            ),

            const SizedBox(height: 16),

            // Special Moves
            _buildCard(
              title: '✨ Special Moves',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSpecialMove('Castling', 'King and rook move together for safety', '🏰 Only if both pieces haven\'t moved', context),
                  SizedBox(height: 12.h),
                  _buildSpecialMove('En Passant', 'Special pawn capture move', '👻 Capture a pawn that just moved two squares', context),
                  SizedBox(height: 12.h),
                  _buildSpecialMove('Pawn Promotion', 'Pawn becomes any piece when reaching the end', '🎭 Usually promoted to a queen', context),
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
                  _buildTip('Control the center - place pawns and pieces in the middle', context),
                  _buildTip('Develop your pieces early - knights and bishops before queen', context),
                  _buildTip('Castle early to keep your king safe', context),
                  _buildTip('Think before you move - consider your opponent\'s threats', context),
                  _buildTip('Look for tactical opportunities - forks, pins, and skewers', context),
                  _buildTip('Value your pieces: Queen=9, Rook=5, Bishop/Knight=3, Pawn=1', context),
                ],
              ),
              context: context,
            ),

            SizedBox(height: 24.h),

            // Start Playing Button
            Center(
              child: IButton(
                onPress: () {
                  Mixin.navigate(context, IChess());
                },
                text: '♔ Start Playing Chess!',
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
      child: Column(
        children: List.generate(8, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(8, (col) {
              final isLight = (row + col) % 2 == 0;
              return Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  color: isLight ? Colors.white : Colors.brown[300],
                  borderRadius: BorderRadius.circular(2),
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

  Widget _buildPiece(String piece, String movement, String description, BuildContext context) {
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
                piece.split(' ')[0], // Just the chess symbol
                style: TextStyle(fontSize: FONT_TITLE, color: color.xTextColorSecondary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  piece,
                  style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.bold,
                    color: color.xTextColorSecondary,
                  ),
                ),
                Text(
                  movement,
                  style: TextStyle(
                    fontSize: FONT_13,
                    color: color.xTextColor,
                  ),
                ),
                Text(
                  description,
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

  Widget _buildSpecialMove(String move, String description, String condition, BuildContext context) {
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
                  move,
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
                  condition,
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
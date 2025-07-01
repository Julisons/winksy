import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../mixin/constants.dart';
import '../model/user_status.dart';
import '../provider/user/online_status_provider.dart';
import '../theme/custom_colors.dart';

class OnlineStatusIndicator extends StatelessWidget {
  final String? userId;
  final double size;
  final bool showText;
  final bool showLastSeen;

  const OnlineStatusIndicator({
    super.key,
    required this.userId,
    this.size = 12.0,
    this.showText = false,
    this.showLastSeen = false,
  });

  @override
  Widget build(BuildContext context) {
    if (userId == null) return SizedBox.shrink();
    
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return Consumer<OnlineStatusProvider>(
      builder: (context, provider, child) {
        final userStatus = provider.getUserStatus(userId!);
        final isOnline = userStatus?.isOnline ?? false;
        
        if (showText || showLastSeen) {
          return _buildTextIndicator(context, userStatus, color);
        } else {
          return _buildDotIndicator(isOnline, color);
        }
      },
    );
  }

  Widget _buildDotIndicator(bool isOnline, CustomColors color) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            spreadRadius: 0.5,
          ),
        ],
      ),
    );
  }

  Widget _buildTextIndicator(BuildContext context, UserStatus? userStatus, CustomColors color) {
    String statusText = userStatus?.displayStatus ?? 'Offline';
    Color statusColor = userStatus?.isOnline == true ? Colors.green : color.xTextColor;
    IconData statusIcon = userStatus?.isOnline == true ? Icons.circle : Icons.circle_outlined;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          statusIcon,
          color: statusColor,
          size: (size * 0.8).r,
        ),
        SizedBox(width: 4.w),
        if (showText)
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: FONT_SMALL,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (showLastSeen && userStatus?.lastSeen != null && !userStatus!.isOnline)
          Text(
            'Last seen ${userStatus.displayStatus.toLowerCase()}',
            style: TextStyle(
              color: color.xTextColor,
              fontSize: FONT_SMALL - 1,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}

class OnlineStatusBadge extends StatelessWidget {
  final String? userId;
  final Widget child;
  final double badgeSize;
  final Alignment alignment;

  const OnlineStatusBadge({
    super.key,
    required this.userId,
    required this.child,
    this.badgeSize = 12.0,
    this.alignment = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    if (userId == null) return child;
    
    return Consumer<OnlineStatusProvider>(
      builder: (context, provider, _) {
        final isOnline = provider.isUserOnline(userId);
        
        return Stack(
          children: [
            child,
            if (isOnline)
              Positioned.fill(
                child: Align(
                  alignment: alignment,
                  child: Container(
                    width: badgeSize.r,
                    height: badgeSize.r,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class OnlineUsersCounter extends StatelessWidget {
  final TextStyle? textStyle;

  const OnlineUsersCounter({
    super.key,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return Consumer<OnlineStatusProvider>(
      builder: (context, provider, child) {
        final count = provider.onlineUsersCount;
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              color: Colors.green,
              size: 8.r,
            ),
            SizedBox(width: 4.w),
            Text(
              '$count online',
              style: textStyle ?? TextStyle(
                color: color.xTextColor,
                fontSize: FONT_SMALL,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}
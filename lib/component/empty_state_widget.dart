import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/mixin/constants.dart';

import '../theme/custom_colors.dart';

enum EmptyStateType {
  games,
  sms,
  users,
  notification,
  photos,
}

class EmptyStateConfig {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;
  final Color iconColor;

  const EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientColors,
    required this.iconColor,
  });
}

class EmptyStateWidget extends StatefulWidget {
  final EmptyStateType type;
  final String? title;
  final String? tagline;
  final String? description;
  final Future<void> Function()? onReload;
  final VoidCallback? onCreate;
  final String createButtonText;
  final String reloadButtonText;
  final bool showReload;
  final bool showCreate;
  final IconData? customIcon;

  const EmptyStateWidget({
    Key? key,
    this.type = EmptyStateType.users,
    this.title,
    this.description,
    this.onReload,
    this.onCreate,
    this.createButtonText = 'Create New',
    this.reloadButtonText = 'Refresh',
    this.showReload = true,
    this.showCreate = true,
    this.customIcon, this.tagline = '',
  }) : super(key: key);

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  EmptyStateConfig _getConfig() {
    switch (widget.type) {
      case EmptyStateType.notification:
        return EmptyStateConfig(
          icon: Icons.notifications_outlined,
          title: 'No Tasks Found',
          description: 'You\'re all caught up! No tasks to display right now.',
          gradientColors: [Theme.of(context).extension<CustomColors>()!.xPrimaryColor, Theme.of(context).extension<CustomColors>()!.xSecondaryColor],
          iconColor: Theme.of(context).extension<CustomColors>()!.xTrailingAlt,
        );
      case EmptyStateType.users:
        return  EmptyStateConfig(
          icon: Icons.people_outline,
          title: 'No Users Found',
          description: 'No users match your current filters or search criteria.',
          gradientColors: [Theme.of(context).extension<CustomColors>()!.xPrimaryColor, Theme.of(context).extension<CustomColors>()!.xSecondaryColor],
          iconColor: Theme.of(context).extension<CustomColors>()!.xTrailingAlt,
        );
      case EmptyStateType.sms:
        return  EmptyStateConfig(
          icon: Icons.question_answer_outlined,
          title: 'No Products Available',
          description: 'No products found. Try adjusting your search or add new products.',
          gradientColors: [Theme.of(context).extension<CustomColors>()!.xPrimaryColor, Theme.of(context).extension<CustomColors>()!.xSecondaryColor],
          iconColor: Theme.of(context).extension<CustomColors>()!.xTrailingAlt,
        );
      case EmptyStateType.photos:
        return  EmptyStateConfig(
          icon: Icons.photo_camera_back_outlined,
          title: 'No Orders Found',
          description: 'No orders match your criteria. New orders will appear here.',
          gradientColors: [Theme.of(context).extension<CustomColors>()!.xPrimaryColor, Theme.of(context).extension<CustomColors>()!.xSecondaryColor],
          iconColor: Theme.of(context).extension<CustomColors>()!.xTrailingAlt,
        );
        case EmptyStateType.games:
        return  EmptyStateConfig(
          icon: Icons.videogame_asset_outlined,
          title: 'No Orders Found',
          description: 'No orders match your criteria. New orders will appear here.',
          gradientColors: [Theme.of(context).extension<CustomColors>()!.xPrimaryColor, Theme.of(context).extension<CustomColors>()!.xSecondaryColor],
          iconColor: Theme.of(context).extension<CustomColors>()!.xTrailingAlt,
        );
      default:
        return  EmptyStateConfig(
          icon: Icons.description_outlined,
          title: 'No Data Available',
          description: 'There are no items to display at the moment.',
          gradientColors: [Theme.of(context).extension<CustomColors>()!.xPrimaryColor, Theme.of(context).extension<CustomColors>()!.xSecondaryColor],
          iconColor: Theme.of(context).extension<CustomColors>()!.xTrailingAlt,
        );
    }
  }

  Future<void> _handleReload() async {
    if (widget.onReload == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onReload!();
    } catch (e) {
      // Handle error if needed
      debugPrint('Reload error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    final config = _getConfig();
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        constraints: const BoxConstraints(minHeight: 400),
        child: Stack(
          children: [
            // Background decorations
            Positioned(
              top: -50,
              right: -50,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          config.gradientColors[0].withOpacity(_pulseAnimation.value * 0.5),
                          config.gradientColors[1].withOpacity(_pulseAnimation.value * 0.2),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          config.gradientColors[1].withOpacity(_pulseAnimation.value * 0.3),
                          config.gradientColors[0].withOpacity(_pulseAnimation.value * 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),

            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon container
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: color.xSecondaryColor,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: config.gradientColors,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: config.iconColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.customIcon ?? config.icon,
                        size: 40,
                        color: config.iconColor,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      widget.title ?? config.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        fontSize: FONT_TITLE
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      widget.description ?? config.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: FONT_13,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 32),

                    // Action buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        if (widget.showReload)
                          _buildReloadButton(theme),
                        if (widget.showCreate)
                          _buildCreateButton(theme, config),
                      ],
                    ),

                    const SizedBox(height: 24),
                    // Help text
                    Text('${widget.tagline}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReloadButton(ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : () => _handleReload(),
      icon: _isLoading
          ? SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      )
          : Icon(
        Icons.refresh,
        size: 18,
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      label: Text(
        _isLoading ? 'Loading...' : widget.reloadButtonText,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCreateButton(ThemeData theme, EmptyStateConfig config) {
    return ElevatedButton.icon(
      onPressed: widget.onCreate,
      icon: const Icon(Icons.add, size: 18),
      label: Text(widget.createButtonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: config.iconColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: config.iconColor.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

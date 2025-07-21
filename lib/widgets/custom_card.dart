# Custom Card Widget

```dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final Color? shadowColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isClickable;
  final double? height;
  final double? width;
  final Border? border;
  final Gradient? gradient;
  final bool showShimmer;
  final Duration animationDuration;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.borderRadius,
    this.onTap,
    this.isClickable = false,
    this.height,
    this.width,
    this.border,
    this.gradient,
    this.showShimmer = false,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isClickable && widget.onTap != null) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isClickable && widget.onTap != null) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.isClickable && widget.onTap != null) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget cardWidget = Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin ?? const EdgeInsets.all(AppConstants.paddingSmall),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.cardColor,
        gradient: widget.gradient,
        borderRadius: widget.borderRadius ?? 
            BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: widget.border,
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor ?? Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: widget.elevation ?? 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? 
            BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: widget.showShimmer ? _buildShimmerEffect() : _buildContent(),
      ),
    );

    if (widget.isClickable && widget.onTap != null) {
      cardWidget = GestureDetector(
        onTap: widget.onTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: cardWidget,
            );
          },
        ),
      );
    }

    return cardWidget;
  }

  Widget _buildContent() {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(AppConstants.paddingMedium),
      child: widget.child,
    );
  }

  Widget _buildShimmerEffect() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
            Colors.grey.shade300,
          ],
          stops: const [0.4, 0.5, 0.6],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

// Specialized cards for different content types

class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showBadge;
  final String? badgeText;
  final Color? badgeColor;

  const InfoCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.iconColor,
    this.onTap,
    this.trailing,
    this.showBadge = false,
    this.badgeText,
    this.badgeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      isClickable: onTap != null,
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              decoration: BoxDecoration(
                color: iconColor?.withOpacity(0.1) ?? 
                    AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppConstants.primaryColor,
                size: AppSizes.iconMedium,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showBadge && badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingSmall,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor ?? AppConstants.accentColor,
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                        ),
                        child: Text(
                          badgeText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: AppConstants.fontSizeXSmall,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (description != null) ...[
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    description!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppConstants.paddingSmall),
            trailing!,
          ] else if (onTap != null) ...[
            const SizedBox(width: AppConstants.paddingSmall),
            const Icon(
              Icons.arrow_forward_ios,
              size: AppSizes.iconSmall,
              color: AppConstants.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;
  final Widget? chart;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.onTap,
    this.chart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      isClickable: onTap != null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? AppConstants.primaryColor,
                  size: AppSizes.iconMedium,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppConstants.primaryColor,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
          ],
          if (chart != null) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            chart!,
          ],
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final bool isEnabled;
  final String? badge;

  const ActionCard({
    Key? key,
    required this.title,
    this.description,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    required this.onTap,
    this.isEnabled = true,
    this.badge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      isClickable: isEnabled,
      onTap: isEnabled ? onTap : null,
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppConstants.primaryColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                ),
                child: Icon(
                  icon,
                  size: AppSizes.iconLarge,
                  color: isEnabled 
                      ? (iconColor ?? AppConstants.primaryColor)
                      : AppConstants.textSecondary,
                ),
              ),
              if (badge != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppConstants.errorColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isEnabled ? null : AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (description != null) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isEnabled 
                    ? AppConstants.textSecondary 
                    : AppConstants.textSecondary.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String title;
  final double progress; // 0.0 to 1.0
  final String? progressText;
  final Color? progressColor;
  final IconData? icon;
  final VoidCallback? onTap;

  const ProgressCard({
    Key? key,
    required this.title,
    required this.progress,
    this.progressText,
    this.progressColor,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      isClickable: onTap != null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: progressColor ?? AppConstants.primaryColor,
                  size: AppSizes.iconMedium,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (progressText != null)
                Text(
                  progressText!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: progressColor ?? AppConstants.primaryColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? AppConstants.primaryColor,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
```

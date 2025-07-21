# Loading Widget

```dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoadingWidget extends StatefulWidget {
  final String? message;
  final double size;
  final Color? color;
  final LoadingType type;
  final bool showMessage;
  final EdgeInsetsGeometry padding;

  const LoadingWidget({
    Key? key,
    this.message,
    this.size = 50.0,
    this.color,
    this.type = LoadingType.circular,
    this.showMessage = true,
    this.padding = const EdgeInsets.all(AppConstants.paddingMedium),
  }) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _animation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadingColor = widget.color ?? AppConstants.primaryColor;

    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLoadingIndicator(loadingColor),
          if (widget.showMessage && widget.message != null) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              widget.message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(Color color) {
    switch (widget.type) {
      case LoadingType.circular:
        return _buildCircularLoading(color);
      case LoadingType.dots:
        return _buildDotsLoading(color);
      case LoadingType.pulse:
        return _buildPulseLoading(color);
      case LoadingType.spinner:
        return _buildSpinnerLoading(color);
      case LoadingType.bars:
        return _buildBarsLoading(color);
      case LoadingType.wave:
        return _buildWaveLoading(color);
    }
  }

  Widget _buildCircularLoading(Color color) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: 3.0,
      ),
    );
  }

  Widget _buildDotsLoading(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = (_animation.value - delay).clamp(0.0, 1.0);
            final opacity = (math.sin(animationValue * math.pi)).abs();
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: widget.size * 0.2,
                  height: widget.size * 0.2,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPulseLoading(Color color) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: widget.size * 0.6,
                height: widget.size * 0.6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpinnerLoading(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * math.pi,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.3),
                  color,
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarsLoading(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            final delay = index * 0.15;
            final animationValue = (_animation.value - delay).clamp(0.0, 1.0);
            final height = widget.size * 0.3 + 
                (widget.size * 0.7 * (math.sin(animationValue * math.pi)).abs());
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: widget.size * 0.15,
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildWaveLoading(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final delay = index * 0.1;
            final animationValue = (_animation.value - delay).clamp(0.0, 1.0);
            final scaleY = 0.3 + (0.7 * (math.sin(animationValue * math.pi * 2)).abs());
            
            return Transform.scale(
              scaleY: scaleY,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                width: widget.size * 0.1,
                height: widget.size,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(widget.size * 0.05),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// Enum for different loading types
enum LoadingType {
  circular,
  dots,
  pulse,
  spinner,
  bars,
  wave,
}

// Shimmer loading widget for content placeholders
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const ShimmerLoading({
    Key? key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));

    if (widget.isLoading) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final baseColor = widget.baseColor ?? Colors.grey.shade300;
    final highlightColor = widget.highlightColor ?? Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 1,
                _animation.value,
                _animation.value + 1,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// Loading overlay for full screen loading
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;
  final LoadingType loadingType;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
    this.loadingType = LoadingType.circular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: LoadingWidget(
                  message: message ?? AppStrings.loading,
                  type: loadingType,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Loading button that shows loading state
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingText;
  final ButtonStyle? style;
  final IconData? icon;

  const LoadingButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.style,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Text(loadingText ?? 'Loading...'),
          ] else ...[
            if (icon != null) ...[
              Icon(icon),
              const SizedBox(width: AppConstants.paddingSmall),
            ],
            Text(text),
          ],
        ],
      ),
    );
  }
}

// Skeleton loading for list items
class SkeletonLoader extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    Key? key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius ?? 
              BorderRadius.circular(AppConstants.borderRadiusSmall),
        ),
      ),
    );
  }
}

// List skeleton for loading list items
class ListSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;

  const ListSkeletonLoader({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding = const EdgeInsets.all(AppConstants.paddingMedium),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          height: itemHeight,
          margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
          child: Row(
            children: [
              const SkeletonLoader(
                height: 50,
                width: 50,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonLoader(
                      height: 16,
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    SkeletonLoader(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Add math library import at the top of the file
import 'dart:math' as math;
```

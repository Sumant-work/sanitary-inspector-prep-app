# Common Widgets

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'custom_card.dart';
import 'loading_widget.dart';

// Common App Bar
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool automaticallyImplyLeading;
  final VoidCallback? onBackPressed;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.automaticallyImplyLeading = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppConstants.primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ?? (onBackPressed != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
            )
          : null),
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: backgroundColor ?? AppConstants.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Common Button
class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final String? loadingText;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CommonButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.loadingText,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    ButtonStyle buttonStyle;
    Color textColor;
    
    switch (type) {
      case ButtonType.primary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        );
        textColor = Colors.white;
        break;
      case ButtonType.secondary:
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: const BorderSide(color: AppConstants.primaryColor),
        );
        textColor = AppConstants.primaryColor;
        break;
      case ButtonType.danger:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: AppConstants.errorColor,
          foregroundColor: Colors.white,
        );
        textColor = Colors.white;
        break;
      case ButtonType.success:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: AppConstants.successColor,
          foregroundColor: Colors.white,
        );
        textColor = Colors.white;
        break;
      case ButtonType.text:
        buttonStyle = TextButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
        );
        textColor = AppConstants.primaryColor;
        break;
    }

    double buttonHeight;
    double fontSize;
    EdgeInsetsGeometry buttonPadding;

    switch (size) {
      case ButtonSize.small:
        buttonHeight = 36;
        fontSize = AppConstants.fontSizeSmall;
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        );
        break;
      case ButtonSize.medium:
        buttonHeight = 48;
        fontSize = AppConstants.fontSizeMedium;
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingLarge,
          vertical: AppConstants.paddingMedium,
        );
        break;
      case ButtonSize.large:
        buttonHeight = 56;
        fontSize = AppConstants.fontSizeLarge;
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingXLarge,
          vertical: AppConstants.paddingMedium,
        );
        break;
    }

    final updatedButtonStyle = buttonStyle.copyWith(
      minimumSize: MaterialStateProperty.all(
        Size(width ?? double.minPositive, buttonHeight),
      ),
      padding: MaterialStateProperty.all(padding ?? buttonPadding),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Text(
            loadingText ?? 'Loading...',
            style: TextStyle(fontSize: fontSize),
          ),
        ] else ...[
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2),
            const SizedBox(width: AppConstants.paddingSmall),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    Widget button;
    switch (type) {
      case ButtonType.primary:
      case ButtonType.danger:
      case ButtonType.success:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: updatedButtonStyle,
          child: buttonChild,
        );
        break;
      case ButtonType.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: updatedButtonStyle,
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: updatedButtonStyle,
          child: buttonChild,
        );
        break;
    }

    return SizedBox(
      width: width,
      child: button,
    );
  }
}

// Enums for button types and sizes
enum ButtonType { primary, secondary, danger, success, text }
enum ButtonSize { small, medium, large }

// Common Text Field
class CommonTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const CommonTextField({
    Key? key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.focusNode,
    this.contentPadding,
  }) : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppConstants.textSecondary)
                : null,
            suffixIcon: _buildSuffixIcon(),
            contentPadding: widget.contentPadding ?? 
                const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingMedium,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: const BorderSide(color: AppConstants.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: const BorderSide(color: AppConstants.errorColor),
            ),
            filled: !widget.enabled,
            fillColor: widget.enabled ? null : Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppConstants.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, color: AppConstants.textSecondary),
        onPressed: widget.onSuffixIconPressed,
      );
    }
    return null;
  }
}

// Empty State Widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? illustration;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    this.message,
    required this.icon,
    this.actionText,
    this.onAction,
    this.illustration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            illustration ?? 
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 64,
                    color: AppConstants.primaryColor.withOpacity(0.6),
                  ),
                ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppConstants.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppConstants.paddingLarge),
              CommonButton(
                text: actionText!,
                onPressed: onAction,
                type: ButtonType.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Error State Widget
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final String? actionText;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorStateWidget({
    Key? key,
    this.title = 'Something went wrong',
    this.message,
    this.actionText = 'Retry',
    this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: AppConstants.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppConstants.errorColor,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppConstants.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.paddingLarge),
              CommonButton(
                text: actionText ?? 'Retry',
                onPressed: onRetry,
                type: ButtonType.primary,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Common Dialog
class CommonDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final String? positiveText;
  final String? negativeText;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;
  final bool barrierDismissible;
  final IconData? icon;
  final Color? iconColor;

  const CommonDialog({
    Key? key,
    required this.title,
    this.content,
    this.contentWidget,
    this.positiveText,
    this.negativeText,
    this.onPositivePressed,
    this.onNegativePressed,
    this.barrierDismissible = true,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      title: Row(
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
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: contentWidget ?? 
          (content != null 
              ? Text(
                  content!,
                  style: theme.textTheme.bodyMedium,
                )
              : null),
      actions: [
        if (negativeText != null)
          TextButton(
            onPressed: onNegativePressed ?? () => Navigator.of(context).pop(),
            child: Text(
              negativeText!,
              style: TextStyle(color: AppConstants.textSecondary),
            ),
          ),
        if (positiveText != null)
          ElevatedButton(
            onPressed: onPositivePressed ?? () => Navigator.of(context).pop(),
            child: Text(positiveText!),
          ),
      ],
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? content,
    Widget? contentWidget,
    String? positiveText,
    String? negativeText,
    VoidCallback? onPositivePressed,
    VoidCallback? onNegativePressed,
    bool barrierDismissible = true,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CommonDialog(
        title: title,
        content: content,
        contentWidget: contentWidget,
        positiveText: positiveText,
        negativeText: negativeText,
        onPositivePressed: onPositivePressed,
        onNegativePressed: onNegativePressed,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}

// Snackbar Helper
class SnackBarHelper {
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppConstants.successColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppConstants.errorColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppConstants.primaryColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }
}

// Separator Widget
class SectionSeparator extends StatelessWidget {
  final String? title;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const SectionSeparator({
    Key? key,
    this.title,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppConstants.paddingMedium,
    ),
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color ?? AppConstants.textSecondary,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
          ],
          Expanded(
            child: Divider(
              color: color ?? Colors.grey.shade300,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// Coming Soon Widget
class ComingSoonWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData icon;

  const ComingSoonWidget({
    Key? key,
    this.title,
    this.message,
    this.icon = Icons.schedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: AppConstants.warningColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppConstants.warningColor,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              title ?? AppStrings.comingSoon,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              message ?? AppStrings.featureComingSoon,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Progress Indicator Widget
class ProgressIndicatorWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String? label;
  final String? progressText;
  final Color? color;
  final double height;

  const ProgressIndicatorWidget({
    Key? key,
    required this.progress,
    this.label,
    this.progressText,
    this.color,
    this.height = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? AppConstants.primaryColor;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || progressText != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (progressText != null)
                Text(
                  progressText!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        if (label != null || progressText != null)
          const SizedBox(height: AppConstants.paddingSmall),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: height,
          ),
        ),
      ],
    );
  }
}
```

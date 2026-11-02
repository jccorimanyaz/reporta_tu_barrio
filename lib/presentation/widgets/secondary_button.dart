import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Botón secundario tipo Outlined accesible con altura mínima de 48px.
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = textColor ?? AppColors.primary;
    final effectiveBorder = borderColor ?? AppColors.primary;

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: text,
      child: SizedBox(
        height: AppTheme.minTouchTarget,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveColor,
            side: BorderSide(color: effectiveBorder, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: effectiveColor),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: effectiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


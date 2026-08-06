import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final bool hasGlow;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
    this.borderColor,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.electricBlue : AppColors.electricBlueLight;
    final cardBg = isDark ? AppColors.backgroundCardDark : AppColors.backgroundCardLight;
    final defaultBorder = isDark ? AppColors.borderDark : AppColors.borderLight;

    Widget cardChild = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? (hasGlow ? primaryAccent : defaultBorder),
          width: hasGlow ? 1.5 : 1.0,
        ),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: primaryAccent.withAlpha(isDark ? 40 : 25),
                  blurRadius: 16,
                  spreadRadius: -2,
                )
              ]
            : [
                BoxShadow(
                  color: isDark ? Colors.black.withAlpha(50) : Colors.black.withAlpha(12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: cardChild,
      );
    }

    return cardChild;
  }
}

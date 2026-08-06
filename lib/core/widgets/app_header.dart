import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../theme/theme_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onToggleSidebar;

  const AppHeader({
    super.key,
    this.onToggleSidebar,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final role = authProvider.userRole ?? 'Siswa';
    final user = authProvider.user;
    final userName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? 'Pengguna';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.backgroundCardDark : AppColors.backgroundCardLight;
    final borderCol = isDark ? AppColors.borderDark : AppColors.borderLight;
    final primaryAccent = isDark ? AppColors.electricCyan : AppColors.electricBlueLight;

    final isMobile = MediaQuery.of(context).size.width < 900;
    
    String nowStr = 'Selasa, 27 Juli 2026 • 10:45 WIB';
    try {
      nowStr = DateFormat('EEEE, d MMM yyyy • HH:mm', 'id_ID').format(DateTime.now());
    } catch (_) {
      try {
        nowStr = DateFormat('EEEE, d MMM yyyy • HH:mm').format(DateTime.now());
      } catch (_) {}
    }

    Color roleColor;
    String roleLabel;
    if (role == 'Super Admin') {
      roleColor = AppColors.superAdminGold;
      roleLabel = 'LEVEL 1  SUPER ADMIN';
    } else if (role == 'Admin') {
      roleColor = AppColors.adminGreen;
      roleLabel = 'LEVEL 2  ADMIN';
    } else if (role == 'Guru') {
      roleColor = AppColors.guruOrange;
      roleLabel = 'LEVEL 3  GURU';
    } else {
      roleColor = AppColors.siswaBlue;
      roleLabel = 'LEVEL 4  SISWA';
    }

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(bottom: BorderSide(color: borderCol)),
      ),
      child: Row(
        children: [
          if (onToggleSidebar != null)
            IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: onToggleSidebar,
            ),

          // Role Badge Pill (Match Reference Image)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: roleColor.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: roleColor.withAlpha(150)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium_rounded, color: roleColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  roleLabel,
                  style: TextStyle(
                    color: roleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          if (!isMobile) ...[
            const SizedBox(width: 16),
            // School Name Badge
            Row(
              children: [
                const Icon(Icons.account_balance_rounded, color: AppColors.textSecondaryDark, size: 16),
                const SizedBox(width: 6),
                Text(
                  'SMK NEGERI 2 BALIKPAPAN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],

          const Spacer(),

          if (!isMobile) ...[
            // Live Date & Time
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondaryDark),
                const SizedBox(width: 6),
                Text(
                  nowStr,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
          ],

          // Theme Toggle (☀️ / 🌙)
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: primaryAccent,
              size: 20,
            ),
            tooltip: 'Switch Theme Mode (Light/Dark)',
            onPressed: () => themeProvider.toggleTheme(),
          ),

          // Notification Bell with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 22),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '5',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 6),

          // User Profile Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderCol),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: primaryAccent.withAlpha(30),
                  child: Icon(Icons.person_rounded, size: 14, color: primaryAccent),
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 8),
                  Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

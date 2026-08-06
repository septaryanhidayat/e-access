import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';

class StudentBottomNav extends StatelessWidget {
  final String activeRoute;

  const StudentBottomNav({
    super.key,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF0B1326) : Colors.white;
    final borderCol = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: navBg,
        border: Border(top: BorderSide(color: borderCol, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            'Beranda',
            Icons.home_rounded,
            '/dashboard_siswa',
            activeRoute == '/dashboard_siswa' || activeRoute == '/',
            const Color(0xFFF97316),
          ),
          _buildNavItem(
            context,
            'CBT',
            Icons.assignment_turned_in_rounded,
            '/cbt',
            activeRoute == '/cbt',
            const Color(0xFF38BDF8),
          ),
          _buildNavItem(
            context,
            'Materi',
            Icons.menu_book_rounded,
            '/materials',
            activeRoute == '/materials',
            const Color(0xFF38BDF8),
          ),
          _buildNavItem(
            context,
            'Presensi',
            Icons.calendar_month_rounded,
            '/attendance',
            activeRoute == '/attendance',
            const Color(0xFF38BDF8),
          ),
          _buildNavItem(
            context,
            'Nilai',
            Icons.star_rounded,
            '/grades',
            activeRoute == '/grades',
            const Color(0xFFFFB95F),
          ),
          _buildNavItem(
            context,
            'Profil',
            Icons.account_circle_rounded,
            '/profile',
            activeRoute == '/profile',
            const Color(0xFF38BDF8),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String label,
    IconData icon,
    String route,
    bool isActive,
    Color activeAccentColor,
  ) {
    final activeTextColor = const Color(0xFF38BDF8);
    final inactiveColor = const Color(0xFF8D90A0);

    return InkWell(
      onTap: () {
        if (!isActive) {
          context.go(route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive ? activeTextColor : inactiveColor,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? activeTextColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

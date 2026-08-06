import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppSidebar extends StatelessWidget {
  final String activeRoute;
  final Function(String route)? onSelectRoute;

  const AppSidebar({
    super.key,
    required this.activeRoute,
    this.onSelectRoute,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final role = authProvider.userRole ?? 'Siswa';
    final user = authProvider.user;
    final userName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? role;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
    final borderCol = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF8D90A0) : const Color(0xFF64748B);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(right: BorderSide(color: borderCol)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderCol)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.electricGradientStart, AppColors.electricGradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'E-ACCESS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: isDark ? AppColors.electricCyan : const Color(0xFF0053DB),
                          ),
                        ),
                        Text(
                          'Classroom & CBT System',
                          style: TextStyle(
                            fontSize: 10,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Menu List Container (RBAC Scoped & Highlighted)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('DASHBOARD', textSecondary),
                    if (role == 'Super Admin' || role == 'Admin')
                      _buildMenuItem(context, 'Beranda', Icons.home_rounded, '/dashboard_admin', isDark)
                    else if (role == 'Guru')
                      _buildMenuItem(context, 'Beranda', Icons.home_rounded, '/dashboard_guru', isDark)
                    else
                      _buildMenuItem(context, 'Beranda', Icons.home_rounded, '/dashboard_siswa', isDark),

                    // Level 1 Super Admin & Level 2 Admin Scoped Menus
                    if (role == 'Super Admin' || role == 'Admin') ...[
                      _buildSectionHeader('MANAJEMEN SISTEM', textSecondary),
                      if (role == 'Super Admin')
                        _buildMenuItem(context, 'Manajemen Sistem', Icons.settings_applications_rounded, '/settings', isDark),
                      _buildMenuItem(context, 'Manajemen Pengguna', Icons.manage_accounts_rounded, '/users', isDark),
                      _buildMenuItem(context, 'Data Guru', Icons.person_search_rounded, '/teachers', isDark),
                      _buildMenuItem(context, 'Data Siswa', Icons.groups_rounded, '/students', isDark),
                      _buildMenuItem(context, 'Data Akademik', Icons.account_balance_rounded, '/academic', isDark),

                      _buildSectionHeader('PEMBELAJARAN', textSecondary),
                      _buildMenuItem(context, 'Mata Pelajaran', Icons.auto_stories_rounded, '/academic', isDark),
                      _buildMenuItem(context, 'Materi Pembelajaran', Icons.picture_as_pdf_rounded, '/materials', isDark),
                      _buildMenuItem(context, 'Bank Soal', Icons.quiz_rounded, '/manage_cbt', isDark),

                      _buildSectionHeader('ASSESSMENT (CBT)', textSecondary),
                      _buildMenuItem(context, 'Kelola CBT', Icons.assignment_rounded, '/cbt', isDark),
                      _buildMenuItem(context, 'Monitoring CBT', Icons.monitor_heart_rounded, '/monitor_cbt', isDark),

                      _buildSectionHeader('PRESENSI', textSecondary),
                      _buildMenuItem(context, 'E-Presensi Siswa', Icons.fact_check_rounded, '/attendance', isDark),

                      _buildSectionHeader('LAPORAN & ANALYTICS', textSecondary),
                      _buildMenuItem(context, 'Learning Analytics', Icons.analytics_rounded, '/analytics', isDark),
                      _buildMenuItem(context, 'Penilaian Siswa', Icons.grade_rounded, '/grades', isDark),

                      _buildSectionHeader('PENGATURAN', textSecondary),
                      _buildMenuItem(context, 'Pengaturan Sistem', Icons.settings_rounded, '/settings', isDark),
                      _buildMenuItem(context, 'Backup Database', Icons.storage_rounded, '/settings', isDark),
                    ],

                    // Level 3 Guru Scoped Menus
                    if (role == 'Guru') ...[
                      _buildSectionHeader('MANAJEMEN KELAS & SISWA', textSecondary),
                      _buildMenuItem(context, 'Kelas yang Diampu', Icons.class_rounded, '/academic', isDark),
                      _buildMenuItem(context, 'Data Siswa', Icons.groups_rounded, '/students', isDark),

                      _buildSectionHeader('PEMBELAJARAN', textSecondary),
                      _buildMenuItem(context, 'Mata Pelajaran', Icons.auto_stories_rounded, '/academic', isDark),
                      _buildMenuItem(context, 'Materi Pembelajaran', Icons.picture_as_pdf_rounded, '/materials', isDark),
                      _buildMenuItem(context, 'Bank Soal', Icons.quiz_rounded, '/manage_cbt', isDark),

                      _buildSectionHeader('ASSESSMENT (CBT)', textSecondary),
                      _buildMenuItem(context, 'Kelola CBT', Icons.assignment_rounded, '/manage_cbt', isDark),
                      _buildMenuItem(context, 'Monitoring CBT', Icons.monitor_heart_rounded, '/monitor_cbt', isDark),

                      _buildSectionHeader('PRESENSI', textSecondary),
                      _buildMenuItem(context, 'E-Presensi Siswa', Icons.fact_check_rounded, '/attendance', isDark),

                      _buildSectionHeader('LAPORAN & ANALYTICS', textSecondary),
                      _buildMenuItem(context, 'Learning Analytics', Icons.analytics_rounded, '/analytics', isDark),
                      _buildMenuItem(context, 'Penilaian Siswa', Icons.grade_rounded, '/grades', isDark),
                    ],

                    // Level 4 Siswa Scoped Menus
                    if (role == 'Siswa') ...[
                      _buildSectionHeader('CBT UJIAN', textSecondary),
                      _buildMenuItem(context, 'Daftar CBT', Icons.assignment_rounded, '/cbt', isDark),
                      _buildMenuItem(context, 'Hasil Ujian Saya', Icons.grade_rounded, '/grades', isDark),

                      _buildSectionHeader('PEMBELAJARAN', textSecondary),
                      _buildMenuItem(context, 'Materi Pembelajaran', Icons.picture_as_pdf_rounded, '/materials', isDark),

                      _buildSectionHeader('PRESENSI', textSecondary),
                      _buildMenuItem(context, 'Presensi Saya', Icons.fact_check_rounded, '/attendance', isDark),

                      _buildSectionHeader('NILAI', textSecondary),
                      _buildMenuItem(context, 'Nilai Saya', Icons.bar_chart_rounded, '/grades', isDark),

                      _buildSectionHeader('PROFIL', textSecondary),
                      _buildMenuItem(context, 'Profil Saya 3D', Icons.person_pin_rounded, '/profile', isDark),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Profile Card
            InkWell(
              onTap: () => context.go('/profile'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B1326) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderCol),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF2563EB).withOpacity(0.2),
                      child: Icon(Icons.person_rounded, color: isDark ? AppColors.electricCyan : const Color(0xFF2563EB), size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4EDEAE),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                role,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Color(0xFFFFB4AB), size: 16),
                      onPressed: () => authProvider.logout(),
                      tooltip: 'Logout',
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

  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 12, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route, bool isDark) {
    // Smart active matching logic for routes
    final isHomeMatch = (route == '/' || route == '/dashboard_admin' || route == '/dashboard_guru' || route == '/dashboard_siswa') &&
        (activeRoute == '/' || activeRoute == '/dashboard_admin' || activeRoute == '/dashboard_guru' || activeRoute == '/dashboard_siswa');

    final isSelected = isHomeMatch || activeRoute == route || (activeRoute.isNotEmpty && route.isNotEmpty && route != '/' && activeRoute.startsWith(route));

    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF8D90A0) : const Color(0xFF64748B);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: () {
          if (onSelectRoute != null) {
            onSelectRoute!(route);
          } else {
            context.go(route);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2)),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : textSecondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

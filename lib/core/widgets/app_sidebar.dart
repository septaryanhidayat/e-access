import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final role = authProvider.userRole ?? 'Admin';
    final user = authProvider.user;
    final userName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? 'Pengguna';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.backgroundCardDark : AppColors.backgroundCardLight;
    final borderCol = isDark ? AppColors.borderDark : AppColors.borderLight;

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
                        const Text(
                          'E-ACCESS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: AppColors.electricCyan,
                          ),
                        ),
                        Text(
                          'Classroom & CBT System',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Menu List Container (Overflow safe)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('DASHBOARD'),
                    _buildMenuItem(context, 'Beranda', Icons.home_rounded, '/'),

                    if (role == 'Super Admin' || role == 'Admin') ...[
                      _buildSectionHeader('MANAJEMEN SISTEM'),
                      _buildMenuItem(context, 'Manajemen Pengguna', Icons.people_alt_rounded, '/users'),
                      _buildMenuItem(context, 'Data Guru', Icons.person_search_rounded, '/teachers'),
                      _buildMenuItem(context, 'Data Siswa', Icons.groups_rounded, '/students'),
                      _buildMenuItem(context, 'Data Akademik', Icons.school_rounded, '/academic'),
                    ] else if (role == 'Guru') ...[
                      _buildSectionHeader('MANAJEMEN KELAS & SISWA'),
                      _buildMenuItem(context, 'Kelas yang Diampu', Icons.class_rounded, '/classes'),
                      _buildMenuItem(context, 'Data Siswa', Icons.groups_rounded, '/students'),
                    ] else ...[
                      _buildSectionHeader('CBT UJIAN'),
                      _buildMenuItem(context, 'Daftar CBT', Icons.assignment_rounded, '/cbt'),
                      _buildMenuItem(context, 'Hasil Ujian Saya', Icons.grade_rounded, '/results'),
                    ],

                    _buildSectionHeader('PEMBELAJARAN'),
                    _buildMenuItem(context, 'Mata Pelajaran', Icons.auto_stories_rounded, '/subjects'),
                    _buildMenuItem(context, 'Materi Pembelajaran', Icons.picture_as_pdf_rounded, '/materials'),
                    _buildMenuItem(context, 'Bank Soal', Icons.quiz_rounded, '/bank_soal'),

                    _buildSectionHeader('ASSESSMENT (CBT)'),
                    _buildMenuItem(context, 'Kelola CBT', Icons.assignment_late_rounded, '/manage_cbt'),
                    _buildMenuItem(context, 'Monitoring CBT', Icons.monitor_heart_rounded, '/monitor_cbt'),

                    _buildSectionHeader('PRESENSI'),
                    _buildMenuItem(context, 'E-Presensi Siswa', Icons.fact_check_rounded, '/attendance'),

                    _buildSectionHeader('LAPORAN & ANALYTICS'),
                    _buildMenuItem(context, 'Learning Analytics', Icons.analytics_rounded, '/analytics'),
                    _buildMenuItem(context, 'Penilaian Siswa', Icons.grade_rounded, '/grades'),

                    _buildSectionHeader('PENGATURAN'),
                    _buildMenuItem(context, 'Pengaturan Sistem', Icons.settings_rounded, '/settings'),
                    _buildMenuItem(context, 'Backup Database', Icons.storage_rounded, '/backup'),
                  ],
                ),
              ),
            ),

            // Bottom Profile Card
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderCol),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.electricBlue.withAlpha(30),
                    child: const Icon(Icons.person_rounded, color: AppColors.electricCyan, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              role,
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 16),
                    onPressed: () => authProvider.logout(),
                    tooltip: 'Logout',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 12, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondaryDark,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    final isSelected = activeRoute == route || (activeRoute == '/' && route == '/');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: () {
          if (onSelectRoute != null) onSelectRoute!(route);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.electricBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final userRole = authProvider.userRole ?? 'Admin';
    final userName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? userRole;

    final isSuperAdmin = userRole == 'Super Admin';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;
    final primaryAccent = isDark ? AppColors.electricCyan : AppColors.electricBlueLight;

    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF8D90A0) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
    final tileBg = isDark ? const Color(0xFF0B1326) : const Color(0xFFF8FAFC);
    final borderCol = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    final activeRoute = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? AppSidebar(activeRoute: activeRoute) : null,
      body: Row(
        children: [
          if (!isMobile) AppSidebar(activeRoute: activeRoute),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  onToggleSidebar: isMobile ? () => _scaffoldKey.currentState?.openDrawer() : null,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: isSuperAdmin
                        ? _buildSuperAdminView(context, userName, isDark, isMobile, primaryAccent, textPrimary, textSecondary, cardBg, tileBg, borderCol)
                        : _buildRegularAdminView(context, userName, isDark, isMobile, primaryAccent, textPrimary, textSecondary, cardBg, tileBg, borderCol),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // REGULAR ADMIN VIEW (LEVEL 2)
  Widget _buildRegularAdminView(
    BuildContext context,
    String userName,
    bool isDark,
    bool isMobile,
    Color primaryAccent,
    Color textPrimary,
    Color textSecondary,
    Color cardBg,
    Color tileBg,
    Color borderCol,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard Admin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)),
                const SizedBox(height: 4),
                Text('Selamat datang di E-ACCESS - Electronic Assessment & Classroom System', style: TextStyle(color: textSecondary, fontSize: 13)),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showPrintSummaryDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: cardBg,
                foregroundColor: primaryAccent,
                side: BorderSide(color: borderCol),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.print_rounded, size: 18),
              label: const Text('Cetak Ringkasan'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        GridView.count(
          crossAxisCount: isMobile ? 2 : 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isMobile ? 1.2 : 1.3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatMetricCard(context, 'TOTAL SISWA', '1.248', 'Siswa Aktif', '↑ 12% dari bulan lalu', Icons.groups_rounded, const Color(0xFF2563EB), '/students', cardBg, borderCol, textPrimary, textSecondary),
            _buildStatMetricCard(context, 'TOTAL GURU', '86', 'Guru Aktif', '↑ 8% dari bulan lalu', Icons.person_search_rounded, const Color(0xFF00A572), '/teachers', cardBg, borderCol, textPrimary, textSecondary),
            _buildStatMetricCard(context, 'TOTAL CBT DIBUAT', '124', 'Ujian / Tugas', '↑ 15% dari bulan lalu', Icons.assignment_rounded, const Color(0xFFA855F7), '/cbt', cardBg, borderCol, textPrimary, textSecondary),
            _buildStatMetricCard(context, 'TOTAL PENGGUNA', '156', 'Akun Sistem', '↑ 10% dari bulan lalu', Icons.account_circle_rounded, const Color(0xFFFFB95F), '/users', cardBg, borderCol, textPrimary, textSecondary),
            _buildStatMetricCard(context, 'PERSENTASE PRESENSI', '94,8%', 'Rata-rata Kehadiran', '↑ 5% dari bulan lalu', Icons.analytics_rounded, const Color(0xFF38BDF8), '/attendance', cardBg, borderCol, textPrimary, textSecondary),
          ],
        ),
        const SizedBox(height: 20),

        if (isMobile) ...[
          _buildCbtSummary6MonthsCard(textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildAdminAttendanceDonutCard(context, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildAdmin12QuickActionsCard(context, tileBg, borderCol, textPrimary, textSecondary),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: _buildCbtSummary6MonthsCard(textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _buildAdminAttendanceDonutCard(context, textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _buildAdmin12QuickActionsCard(context, tileBg, borderCol, textPrimary, textSecondary)),
            ],
          ),
        ],
        const SizedBox(height: 20),

        if (isMobile) ...[
          _buildSystemActivitiesTableCard(context, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildOnlineUsersCard(context, tileBg, borderCol, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildAnnouncementsCard(context, tileBg, borderCol, textPrimary, textSecondary),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: _buildSystemActivitiesTableCard(context, textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _buildOnlineUsersCard(context, tileBg, borderCol, textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _buildAnnouncementsCard(context, tileBg, borderCol, textPrimary, textSecondary)),
            ],
          ),
        ],
        const SizedBox(height: 20),

        if (isMobile) ...[
          _buildSupportedFormatsCard(textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildAdminFeaturesCard(textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildLearningStatsCard(tileBg, borderCol, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildAverageGradeDonutCard(context, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildAdminSystemInfoCard(textPrimary, textSecondary),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildSupportedFormatsCard(textPrimary, textSecondary)),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _buildAdminFeaturesCard(textPrimary, textSecondary)),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _buildLearningStatsCard(tileBg, borderCol, textPrimary, textSecondary)),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _buildAverageGradeDonutCard(context, textPrimary, textSecondary)),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _buildAdminSystemInfoCard(textPrimary, textSecondary)),
            ],
          ),
        ],
        const SizedBox(height: 30),

        Center(child: Text('© 2026 E-ACCESS - Electronic Assessment & Classroom System. All rights reserved.', style: TextStyle(color: textSecondary, fontSize: 11))),
        const SizedBox(height: 10),
      ],
    );
  }

  // SUPER ADMIN VIEW (LEVEL 1)
  Widget _buildSuperAdminView(
    BuildContext context,
    String userName,
    bool isDark,
    bool isMobile,
    Color primaryAccent,
    Color textPrimary,
    Color textSecondary,
    Color cardBg,
    Color tileBg,
    Color borderCol,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat datang, $userName! 👑', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)),
                const SizedBox(height: 4),
                Text('Anda memiliki akses penuh terhadap seluruh sistem E-ACCESS.', style: TextStyle(color: textSecondary, fontSize: 13)),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showPrintSummaryDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: cardBg,
                foregroundColor: primaryAccent,
                side: BorderSide(color: borderCol),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.print_rounded, size: 18),
              label: const Text('Cetak Ringkasan'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        GridView.count(
          crossAxisCount: isMobile ? 2 : 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isMobile ? 1.2 : 1.3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatMetricCard(context, 'TOTAL SISWA', '2.456', 'Siswa Aktif', '↑ 12% dari bulan lalu', Icons.groups_rounded, const Color(0xFF2563EB), '/students', cardBg, borderCol, textPrimary, textSecondary),
            _buildStatMetricCard(context, 'TOTAL GURU', '156', 'Guru Aktif', '↑ 8% dari bulan lalu', Icons.person_search_rounded, const Color(0xFF00A572), '/teachers', cardBg, borderCol, textPrimary, textSecondary),
            _buildStatMetricCard(context, 'TOTAL KELAS', '72', 'Kelas', '↑ 6% dari bulan lalu', Icons.class_rounded, const Color(0xFFA855F7), '/academic', cardBg, borderCol, textPrimary, textSecondary),
            _buildStatMetricCard(context, 'TOTAL CBT DIBUAT', '348', 'Ujian / Tugas', '↑ 15% dari bulan lalu', Icons.assignment_rounded, const Color(0xFFFFB95F), '/cbt', cardBg, borderCol, textPrimary, textSecondary),
            _buildStatMetricCard(context, 'PERSENTASE PRESENSI', '94,8%', 'Rata-rata Kehadiran', '↑ 5% dari bulan lalu', Icons.timer_rounded, const Color(0xFF38BDF8), '/attendance', cardBg, borderCol, textPrimary, textSecondary),
          ],
        ),
        const SizedBox(height: 20),

        if (isMobile) ...[
          _buildLineChartCard(textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildSystemSummaryCard(tileBg, borderCol, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildDistributionDonutCard(context, textPrimary, textSecondary),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: _buildLineChartCard(textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _buildSystemSummaryCard(tileBg, borderCol, textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _buildDistributionDonutCard(context, textPrimary, textSecondary)),
            ],
          ),
        ],
        const SizedBox(height: 20),

        if (isMobile) ...[
          _buildCbtMonitoringCard(context, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildAdminAttendanceDonutCard(context, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildAverageGradesCard(context, textPrimary, textSecondary),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: _buildCbtMonitoringCard(context, textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _buildAdminAttendanceDonutCard(context, textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _buildAverageGradesCard(context, textPrimary, textSecondary)),
            ],
          ),
        ],
        const SizedBox(height: 20),

        if (isMobile) ...[
          _buildRecentActivityLogCard(context, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildSuperAdminQuickAccessCard(context, tileBg, borderCol, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildSystemInformationCard(context, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildSupportedFormatsAndExportImportCard(context, tileBg, borderCol, textPrimary, textSecondary),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildRecentActivityLogCard(context, textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _buildSuperAdminQuickAccessCard(context, tileBg, borderCol, textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _buildSystemInformationCard(context, textPrimary, textSecondary)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _buildSupportedFormatsAndExportImportCard(context, tileBg, borderCol, textPrimary, textSecondary)),
            ],
          ),
        ],
        const SizedBox(height: 30),

        Center(child: Text('© 2026 E-ACCESS - Electronic Assessment & Classroom System. All rights reserved.', style: TextStyle(color: textSecondary, fontSize: 11))),
        const SizedBox(height: 10),
      ],
    );
  }

  // WIDGET HELPER BUILDERS
  Widget _buildStatMetricCard(BuildContext context, String title, String value, String subtitle, String trend, IconData icon, Color color, String route, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderCol)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
                Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary, letterSpacing: 0.5)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)),
                Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondary)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.arrow_upward_rounded, color: Color(0xFF00A572), size: 12),
                const SizedBox(width: 2),
                Text(trend, style: const TextStyle(fontSize: 10, color: Color(0xFF00A572), fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCbtSummary6MonthsCard(Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RINGKASAN CBT (6 BULAN TERAKHIR)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCbtBadgeItem('36', 'Ujian Aktif\nSedang Berlangsung', const Color(0xFF0053DB), textSecondary),
              _buildCbtBadgeItem('88', 'Ujian Selesai\nSelesai Dilaksanakan', const Color(0xFF00A572), textSecondary),
              _buildCbtBadgeItem('78,5', 'Rata-rata Nilai\nDari Semua Ujian', const Color(0xFFD97706), textSecondary),
              _buildCbtBadgeItem('94%', 'Tingkat Ketuntasan\nSiswa Tuntas', const Color(0xFF9333EA), textSecondary),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(height: 140, width: double.infinity, child: CustomPaint(painter: SingleTrendLinePainter())),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul'].map((m) => Text(m, style: TextStyle(fontSize: 10, color: textSecondary))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCbtBadgeItem(String val, String desc, Color color, Color textSecondary) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: textSecondary, height: 1.1)),
      ],
    );
  }

  Widget _buildAdminAttendanceDonutCard(BuildContext context, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PRESENSI SISWA HARI INI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A572), width: 6)),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total Siswa', style: TextStyle(fontSize: 8, color: textSecondary)),
                    Text('1.248', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DistributionItem('Hadir', '1.068 (85,6%)', const Color(0xFF00A572), textPrimary, textSecondary),
                    _DistributionItem('Ijin', '86 (6,9%)', const Color(0xFFD97706), textPrimary, textSecondary),
                    _DistributionItem('Sakit', '54 (4,3%)', const Color(0xFF0053DB), textPrimary, textSecondary),
                    _DistributionItem('Alpa', '40 (3,2%)', const Color(0xFFDC2626), textPrimary, textSecondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => context.go('/attendance'), child: const Text('Lihat E-Presensi →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
          ),
        ],
      ),
    );
  }

  Widget _buildAdmin12QuickActionsCard(BuildContext context, Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    final actions = [
      {'title': 'Import Data\nSiswa', 'icon': Icons.person_add_alt_1_rounded, 'route': '/users'},
      {'title': 'Import Data\nGuru', 'icon': Icons.group_add_rounded, 'route': '/users'},
      {'title': 'Buat CBT\nBaru', 'icon': Icons.note_add_rounded, 'route': '/manage_cbt'},
      {'title': 'Upload\nMateri', 'icon': Icons.cloud_upload_rounded, 'route': '/materials'},
      {'title': 'Bank\nSoal', 'icon': Icons.menu_book_rounded, 'route': '/manage_cbt'},
      {'title': 'E-Presensi', 'icon': Icons.fact_check_rounded, 'route': '/attendance'},
      {'title': 'Monitoring\nCBT', 'icon': Icons.monitor_heart_rounded, 'route': '/monitor_cbt'},
      {'title': 'Laporan', 'icon': Icons.insert_chart_outlined_rounded, 'route': '/analytics'},
      {'title': 'Backup\nDatabase', 'icon': Icons.cloud_download_rounded, 'route': '/backup'},
      {'title': 'Pengaturan\nSistem', 'icon': Icons.settings_rounded, 'route': '/settings'},
      {'title': 'Learning\nAnalytics', 'icon': Icons.analytics_rounded, 'route': '/analytics'},
      {'title': 'Log\nAktivitas', 'icon': Icons.receipt_long_rounded, 'route': '/settings'},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AKSI CEPAT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1.0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: actions.map((a) {
              return InkWell(
                onTap: () => context.go(a['route'] as String),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: tileBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderCol)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(a['icon'] as IconData, size: 18, color: const Color(0xFF0053DB)),
                      const SizedBox(height: 2),
                      Text(a['title'] as String, textAlign: TextAlign.center, style: TextStyle(fontSize: 7.5, color: textSecondary, fontWeight: FontWeight.bold, height: 1.1)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemActivitiesTableCard(BuildContext context, Color textPrimary, Color textSecondary) {
    final activities = [
      {'time': '10:30', 'act': 'Login ke sistem', 'by': 'Admin', 'detail': 'Login berhasil dari IP 202.46.12.15'},
      {'time': '10:25', 'act': 'Import data siswa', 'by': 'Admin', 'detail': 'Berhasil import 120 data siswa'},
      {'time': '10:20', 'act': 'Buat CBT baru', 'by': 'Admin', 'detail': 'Ujian Akhir Semester Ganjil'},
      {'time': '10:15', 'act': 'Upload materi pembelajaran', 'by': 'Guru B.Indo', 'detail': 'Materi: Teks LHO'},
      {'time': '10:10', 'act': 'Presensi kelas diperbarui', 'by': 'Sistem', 'detail': 'Data presensi 12 kelas diperbarui'},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AKTIVITAS TERBARU SISTEM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 12,
              headingRowHeight: 28,
              dataRowHeight: 32,
              columns: [
                DataColumn(label: Text('WAKTU', style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('AKTIVITAS', style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('OLEH', style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('DETAIL', style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.bold))),
              ],
              rows: activities.map((a) {
                return DataRow(
                  cells: [
                    DataCell(Text(a['time']!, style: const TextStyle(fontSize: 10, color: Color(0xFF0053DB), fontWeight: FontWeight.bold))),
                    DataCell(Text(a['act']!, style: TextStyle(fontSize: 10, color: textPrimary, fontWeight: FontWeight.bold))),
                    DataCell(Text(a['by']!, style: TextStyle(fontSize: 10, color: textSecondary))),
                    DataCell(Text(a['detail']!, style: TextStyle(fontSize: 10, color: textSecondary))),
                  ],
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => _showAllActivityLogsDialog(context), child: const Text('Lihat Semua Aktivitas →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineUsersCard(BuildContext context, Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    final onlineList = [
      {'name': 'Admin', 'role': 'Admin', 'time': '10:45', 'color': const Color(0xFF00A572)},
      {'name': 'Guru Bahasa Indonesia', 'role': 'Guru', 'time': '10:44', 'color': const Color(0xFFD97706)},
      {'name': 'Guru Matematika', 'role': 'Guru', 'time': '10:43', 'color': const Color(0xFFD97706)},
      {'name': 'Guru Produktif', 'role': 'Guru', 'time': '10:42', 'color': const Color(0xFFD97706)},
      {'name': 'Guru TIK', 'role': 'Guru', 'time': '10:41', 'color': const Color(0xFFD97706)},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PENGGUNA ONLINE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF005236).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: const Text('Total Online: 15', style: TextStyle(color: Color(0xFF00A572), fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: onlineList.map((u) {
              final name = u['name'] as String;
              final role = u['role'] as String;
              final time = u['time'] as String;
              final color = u['color'] as Color;

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    CircleAvatar(radius: 10, backgroundColor: borderCol, child: Icon(Icons.person, size: 12, color: textPrimary)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(name, style: TextStyle(fontSize: 10, color: textPrimary, fontWeight: FontWeight.bold))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(role, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text(time, style: TextStyle(fontSize: 9, color: textSecondary)),
                  ],
                ),
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => context.go('/users'), child: const Text('Lihat Semua Pengguna →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsCard(BuildContext context, Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    final anns = [
      {'title': 'Ujian Akhir Semester Ganjil', 'tag': 'CBT', 'sub': 'Dilaksanakan 1 - 7 Agustus 2026', 'date': '27 Jul 2026', 'color': const Color(0xFF0053DB)},
      {'title': 'Pengumpulan Tugas PKK', 'tag': 'Tugas', 'sub': 'Batas akhir 31 Juli 2026', 'date': '26 Jul 2026', 'color': const Color(0xFF00A572)},
      {'title': 'Libur Hari Kemerdekaan RI', 'tag': 'Informasi', 'sub': '17 Agustus 2026', 'date': '25 Jul 2026', 'color': const Color(0xFF9333EA)},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PENGUMUMAN TERBARU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
              TextButton(onPressed: () => _showAllAnnouncementsDialog(context), child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF0053DB), fontSize: 10))),
            ],
          ),
          const SizedBox(height: 6),
          Column(
            children: anns.map((a) {
              final title = a['title'] as String;
              final tag = a['tag'] as String;
              final sub = a['sub'] as String;
              final date = a['date'] as String;
              final color = a['color'] as Color;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: tileBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderCol)),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Icon(Icons.campaign_rounded, color: color, size: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary)),
                              const SizedBox(width: 4),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: Text(tag, style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Text(sub, style: TextStyle(fontSize: 8, color: textSecondary)),
                        ],
                      ),
                    ),
                    Text(date, style: TextStyle(fontSize: 8, color: textSecondary)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportedFormatsCard(Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FORMAT FILE YANG DIDUKUNG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: textSecondary)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniFormatItem('Excel', '.xlsx', Icons.table_chart_rounded, const Color(0xFF00A572), textPrimary, textSecondary),
              _buildMiniFormatItem('CSV', '.csv', Icons.grid_on_rounded, const Color(0xFF00A572), textPrimary, textSecondary),
              _buildMiniFormatItem('PDF', '.pdf', Icons.picture_as_pdf_rounded, const Color(0xFFDC2626), textPrimary, textSecondary),
              _buildMiniFormatItem('Word', '.docx', Icons.description_rounded, const Color(0xFF0053DB), textPrimary, textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniFormatItem(String name, String ext, IconData icon, Color color, Color textPrimary, Color textSecondary) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        Text(name, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textPrimary)),
        Text('($ext)', style: TextStyle(fontSize: 7, color: textSecondary)),
      ],
    );
  }

  Widget _buildAdminFeaturesCard(Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FITUR UNGGULAN ADMIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: textSecondary)),
          const SizedBox(height: 8),
          Text('✓ Kelola data Guru & Siswa', style: TextStyle(fontSize: 9, color: textPrimary)),
          Text('✓ Buat dan Kelola CBT', style: TextStyle(fontSize: 9, color: textPrimary)),
          Text('✓ Monitoring & Evaluasi Ujian', style: TextStyle(fontSize: 9, color: textPrimary)),
          Text('✓ E-Presensi & Kehadiran', style: TextStyle(fontSize: 9, color: textPrimary)),
          Text('✓ Laporan & Learning Analytics', style: TextStyle(fontSize: 9, color: textPrimary)),
        ],
      ),
    );
  }

  Widget _buildLearningStatsCard(Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('STATISTIK PEMBELAJARAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: textSecondary)),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1.8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _MiniStatBox('48', 'Mata Pelajaran', Icons.subject_rounded, tileBg, borderCol, textPrimary, textSecondary),
              _MiniStatBox('236', 'Materi Pembelajaran', Icons.auto_stories_rounded, tileBg, borderCol, textPrimary, textSecondary),
              _MiniStatBox('1.542', 'Bank Soal', Icons.quiz_rounded, tileBg, borderCol, textPrimary, textSecondary),
              _MiniStatBox('87', 'CBT Tersedia', Icons.assignment_turned_in_rounded, tileBg, borderCol, textPrimary, textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAverageGradeDonutCard(BuildContext context, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PENILAIAN RATA-RATA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: textSecondary)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A572), width: 4)),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('78,5', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary)),
                    Text('Rata-rata', style: TextStyle(fontSize: 6, color: textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DistributionItem('Nilai ≥ 80', '52%', const Color(0xFF00A572), textPrimary, textSecondary),
                    _DistributionItem('70 - 79', '28%', const Color(0xFF0053DB), textPrimary, textSecondary),
                    _DistributionItem('60 - 69', '15%', const Color(0xFFD97706), textPrimary, textSecondary),
                    _DistributionItem('< 60', '5%', const Color(0xFFDC2626), textPrimary, textSecondary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSystemInfoCard(Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('INFORMASI SISTEM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: textSecondary)),
          const SizedBox(height: 8),
          _buildSysInfoRow('Status Server', '● Online', const Color(0xFF00A572), textSecondary),
          _buildSysInfoRow('Database', '● Optimal', const Color(0xFF00A572), textSecondary),
          _buildSysInfoRow('Backup Terakhir', '27/07/2026 02:00', const Color(0xFF0053DB), textSecondary),
          _buildSysInfoRow('Versi Aplikasi', 'v2.6.0', const Color(0xFF00A572), textSecondary),
        ],
      ),
    );
  }

  Widget _buildLineChartCard(Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Grafik Perkembangan Data (6 Bulan Terakhir)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 16),
          SizedBox(height: 180, width: double.infinity, child: CustomPaint(painter: MultiLineChartPainter())),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul'].map((m) => Text(m, style: TextStyle(fontSize: 10, color: textSecondary))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSummaryCard(Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan Sistem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildSystemMetricTile(Icons.people_alt_rounded, 'Pengguna Aktif', '412', 'Online Sekarang', const Color(0xFF00A572), tileBg, borderCol, textPrimary, textSecondary),
              _buildSystemMetricTile(Icons.storage_rounded, 'Database Size', '48,6 GB', 'Total Penyimpanan', const Color(0xFF0053DB), tileBg, borderCol, textPrimary, textSecondary),
              _buildSystemMetricTile(Icons.cloud_upload_rounded, 'Backup Terakhir', '27/07/2026', '02:00 WIB', const Color(0xFF0284C7), tileBg, borderCol, textPrimary, textSecondary),
              _buildSystemMetricTile(Icons.code_rounded, 'Versi Aplikasi', 'v2.6.0', 'Versi Terbaru', const Color(0xFF9333EA), tileBg, borderCol, textPrimary, textSecondary),
              _buildSystemMetricTile(Icons.assessment_rounded, 'Log Aktivitas Hari ini', '1.245', 'Aktivitas', const Color(0xFFD97706), tileBg, borderCol, textPrimary, textSecondary),
              _buildSystemMetricTile(Icons.verified_user_rounded, 'Status Server', 'Optimal', 'Semua Sistem Normal', const Color(0xFF00A572), tileBg, borderCol, textPrimary, textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMetricTile(IconData icon, String title, String value, String sub, Color color, Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: tileBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderCol)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(fontSize: 10, color: textSecondary)),
                Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
                Text(sub, style: TextStyle(fontSize: 8, color: textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionDonutCard(BuildContext context, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Distribusi Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF0053DB), width: 6)),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total', style: TextStyle(fontSize: 9, color: textSecondary)),
                    Text('2.456', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                    Text('Siswa', style: TextStyle(fontSize: 9, color: textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DistributionItem('X TKJ 1', '32% (786)', const Color(0xFF0053DB), textPrimary, textSecondary),
                    _DistributionItem('X TKJ 2', '27% (664)', const Color(0xFF00A572), textPrimary, textSecondary),
                    _DistributionItem('XI TKJ 1', '21% (516)', const Color(0xFF9333EA), textPrimary, textSecondary),
                    _DistributionItem('XI RPL 1', '12% (295)', const Color(0xFFD97706), textPrimary, textSecondary),
                    _DistributionItem('X Bahasa 1', '8% (195)', const Color(0xFFDC2626), textPrimary, textSecondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => _showDistributionDetailsDialog(context), child: const Text('Lihat Detail Data →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
          ),
        ],
      ),
    );
  }

  Widget _buildCbtMonitoringCard(BuildContext context, Color textPrimary, Color textSecondary) {
    final liveExams = [
      {'title': 'Ujian Akhir Semester Ganjil', 'class': 'X TKJ 1', 'total': '32', 'done': '20', 'doing': '10', 'waiting': '2'},
      {'title': 'Ulangan Harian - Bab Teks LHO', 'class': 'X TKJ 2', 'total': '30', 'done': '18', 'doing': '9', 'waiting': '3'},
      {'title': 'Ulangan Harian - Teks Anekdot', 'class': 'XI TKJ 1', 'total': '28', 'done': '15', 'doing': '8', 'waiting': '5'},
      {'title': 'Latihan Soal Hikayat', 'class': 'XI RPL 1', 'total': '30', 'done': '22', 'doing': '6', 'waiting': '2'},
      {'title': 'Ulangan Harian - Teks Negosiasi', 'class': 'X Bahasa 1', 'total': '28', 'done': '12', 'doing': '10', 'waiting': '6'},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monitoring CBT Berjalan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              headingRowHeight: 32,
              dataRowHeight: 36,
              columns: [
                DataColumn(label: Text('Judul CBT', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Kelas', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Peserta', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Selesai', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Sedang', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Belum Mulai', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Aksi', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
              ],
              rows: liveExams.map((e) {
                return DataRow(
                  cells: [
                    DataCell(Text(e['title']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary))),
                    DataCell(Text(e['class']!, style: TextStyle(fontSize: 11, color: textSecondary))),
                    DataCell(Text(e['total']!, style: TextStyle(fontSize: 11, color: textPrimary))),
                    DataCell(Text(e['done']!, style: const TextStyle(fontSize: 11, color: Color(0xFF00A572), fontWeight: FontWeight.bold))),
                    DataCell(Text(e['doing']!, style: const TextStyle(fontSize: 11, color: Color(0xFFD97706), fontWeight: FontWeight.bold))),
                    DataCell(Text(e['waiting']!, style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626)))),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: Color(0xFF0053DB)),
                        onPressed: () => _showCbtMonitoringDetailDialog(context, e['title']!, e['class']!, e['total']!),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => context.go('/monitor_cbt'), child: const Text('Lihat Semua Monitoring CBT →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageGradesCard(BuildContext context, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rekap Nilai Rata-rata', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 14),
          _buildBarRow('X TKJ 1', 0.824, '82,4', const Color(0xFF00A572), textPrimary),
          const SizedBox(height: 8),
          _buildBarRow('X TKJ 2', 0.768, '76,8', const Color(0xFF0053DB), textPrimary),
          const SizedBox(height: 8),
          _buildBarRow('XI TKJ 1', 0.792, '79,2', const Color(0xFF9333EA), textPrimary),
          const SizedBox(height: 8),
          _buildBarRow('XI RPL 1', 0.746, '74,6', const Color(0xFFD97706), textPrimary),
          const SizedBox(height: 8),
          _buildBarRow('X Bahasa 1', 0.796, '79,6', const Color(0xFF0284C7), textPrimary),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => context.go('/grades'), child: const Text('Lihat Semua Rekap Nilai →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
          ),
        ],
      ),
    );
  }

  Widget _buildBarRow(String className, double ratio, String label, Color color, Color textPrimary) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(className, style: TextStyle(fontSize: 11, color: textPrimary))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: ratio, backgroundColor: const Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 8),
          ),
        ),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary)),
      ],
    );
  }

  Widget _buildRecentActivityLogCard(BuildContext context, Color textPrimary, Color textSecondary) {
    final logs = [
      {'time': '10:30', 'text': 'Super Admin membuat akun guru baru oleh Super Admin'},
      {'time': '10:15', 'text': 'Import data siswa dari file Excel (2.456 data berhasil diimport)'},
      {'time': '09:58', 'text': 'Backup database sistem (Backup otomatis berhasil 48,6 GB)'},
      {'time': '09:45', 'text': 'Pengaturan mata pelajaran diperbarui (Menambahkan mata pelajaran baru)'},
      {'time': '09:30', 'text': 'CBT "Ujian Akhir Semester Ganjil" dibuat untuk kelas X TKJ 1, X TKJ 2, XI TKJ 1'},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aktivitas Sistem Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 12),
          Column(
            children: logs.map((l) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l['time']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0053DB))),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l['text']!, style: TextStyle(fontSize: 10, color: textSecondary))),
                  ],
                ),
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => _showAllActivityLogsDialog(context), child: const Text('Lihat Semua Log Aktivitas →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
          ),
        ],
      ),
    );
  }

  Widget _buildSuperAdminQuickAccessCard(BuildContext context, Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    final quickActions = [
      {'title': 'Manajemen\nSistem', 'icon': Icons.settings_applications_rounded, 'color': const Color(0xFF0053DB), 'route': '/settings'},
      {'title': 'Manajemen\nPengguna', 'icon': Icons.manage_accounts_rounded, 'color': const Color(0xFF0053DB), 'route': '/users'},
      {'title': 'Data\nAkademik', 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF9333EA), 'route': '/academic'},
      {'title': 'Data\nGuru', 'icon': Icons.person_search_rounded, 'color': const Color(0xFF00A572), 'route': '/teachers'},
      {'title': 'Data\nSiswa', 'icon': Icons.groups_rounded, 'color': const Color(0xFF0053DB), 'route': '/students'},
      {'title': 'Kelola\nCBT', 'icon': Icons.assignment_rounded, 'color': const Color(0xFF0053DB), 'route': '/manage_cbt'},
      {'title': 'Monitoring\nCBT', 'icon': Icons.monitor_heart_rounded, 'color': const Color(0xFF0284C7), 'route': '/monitor_cbt'},
      {'title': 'Presensi\nSiswa', 'icon': Icons.fact_check_rounded, 'color': const Color(0xFF00A572), 'route': '/attendance'},
      {'title': 'Laporan\n& Export', 'icon': Icons.analytics_rounded, 'color': const Color(0xFF0053DB), 'route': '/analytics'},
      {'title': 'Backup\nDatabase', 'icon': Icons.cloud_download_rounded, 'color': const Color(0xFF0053DB), 'route': '/backup'},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Akses Cepat (Super Admin)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: quickActions.map((a) {
              return InkWell(
                onTap: () => context.go(a['route'] as String),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: tileBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderCol)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(a['icon'] as IconData, size: 20, color: a['color'] as Color),
                      const SizedBox(height: 4),
                      Text(a['title'] as String, textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: textSecondary, fontWeight: FontWeight.bold, height: 1.1)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInformationCard(BuildContext context, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Sistem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 10),
          _buildSysInfoRow('Status Server', '● Online', const Color(0xFF00A572), textSecondary),
          _buildSysInfoRow('Database', '● Optimal', const Color(0xFF00A572), textSecondary),
          _buildSysInfoRow('Backup Terakhir', '27/07/2026 02:00', const Color(0xFF0053DB), textSecondary),
          _buildSysInfoRow('Versi Aplikasi', 'v2.6.0', const Color(0xFF00A572), textSecondary),
          _buildSysInfoRow('Total Pengguna', '2.574 Akun', textPrimary, textSecondary),
          const SizedBox(height: 10),
          Text('Penyimpanan Digunakan', style: TextStyle(fontSize: 10, color: textSecondary)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(value: 0.486, backgroundColor: Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0053DB)), minHeight: 8),
          ),
          const SizedBox(height: 4),
          Text('48.6 GB / 100 GB (48%)', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSupportedFormatsAndExportImportCard(BuildContext context, Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Format Data yang Didukung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimary)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFormatBadge('Excel', '.xlsx', Icons.table_chart_rounded, const Color(0xFF00A572), textPrimary, textSecondary),
              _buildFormatBadge('CSV', '.csv', Icons.grid_on_rounded, const Color(0xFF00A572), textPrimary, textSecondary),
              _buildFormatBadge('PDF', '.pdf', Icons.picture_as_pdf_rounded, const Color(0xFFDC2626), textPrimary, textSecondary),
              _buildFormatBadge('Word', '.docx', Icons.description_rounded, const Color(0xFF0053DB), textPrimary, textSecondary),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFE2E8F0)),
          Text('Export Data Cepat', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondary)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildExportBtn(context, 'Data Siswa', tileBg, borderCol),
              _buildExportBtn(context, 'Data Guru', tileBg, borderCol),
              _buildExportBtn(context, 'Nilai Siswa', tileBg, borderCol),
              _buildExportBtn(context, 'Presensi', tileBg, borderCol),
            ],
          ),
          const SizedBox(height: 10),
          Text('Import Data Cepat', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondary)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildImportBtn(context, 'Import Siswa'),
              _buildImportBtn(context, 'Import Guru'),
              _buildImportBtn(context, 'Import Nilai'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormatBadge(String title, String ext, IconData icon, Color color, Color textPrimary, Color textSecondary) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 2),
        Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textPrimary)),
        Text('($ext)', style: TextStyle(fontSize: 8, color: textSecondary)),
      ],
    );
  }

  Widget _buildExportBtn(BuildContext context, String label, Color tileBg, Color borderCol) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mengekspor data $label ke format Excel (.xlsx)...')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: tileBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderCol)),
        child: Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF0053DB), fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildImportBtn(BuildContext context, String label) {
    return InkWell(
      onTap: () => _showQuickImportDialog(context, label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFF0053DB).withOpacity(0.15), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF0053DB))),
        child: Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF0053DB), fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSysInfoRow(String label, String value, Color color, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: textSecondary)),
          Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // Dialog Helper Actions
  void _showPrintSummaryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cetak Ringkasan Sistem E-ACCESS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Siapkan dokumen laporan ringkasan statistik sekolah dalam format PDF.', style: TextStyle(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dokumen PDF Ringkasan Sistem berhasil dicetak!')));
            },
            child: const Text('Cetak PDF'),
          ),
        ],
      ),
    );
  }

  void _showDistributionDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rincian Distribusi Data Siswa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• X TKJ 1: 786 Siswa (32%)', style: TextStyle(fontSize: 12)),
            Text('• X TKJ 2: 664 Siswa (27%)', style: TextStyle(fontSize: 12)),
            Text('• XI TKJ 1: 516 Siswa (21%)', style: TextStyle(fontSize: 12)),
            Text('• XI RPL 1: 295 Siswa (12%)', style: TextStyle(fontSize: 12)),
            Text('• X Bahasa 1: 195 Siswa (8%)', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showCbtMonitoringDetailDialog(BuildContext context, String title, String className, String total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text('Monitoring Realtime untuk kelas $className (Total $total peserta).', style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showAllActivityLogsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Semua Audit Log Sistem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Audit Trail tercatat 1.245 aktivitas hari ini di database Supabase.', style: TextStyle(fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showAllAnnouncementsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Semua Pengumuman Sekolah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Ujian Akhir Semester Ganjil (1-7 Ags 2026)', style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            Text('2. Pengumpulan Tugas PKK (s/d 31 Jul 2026)', style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            Text('3. Libur Hari Kemerdekaan RI (17 Ags 2026)', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showQuickImportDialog(BuildContext context, String label) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Pilih file data Excel (.xlsx / .csv) dari komputer Anda.', style: TextStyle(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label berhasil diimpor!')));
            },
            child: const Text('Pilih File'),
          ),
        ],
      ),
    );
  }
}

class _DistributionItem extends StatelessWidget {
  final String label;
  final String val;
  final Color color;
  final Color textPrimary;
  final Color textSecondary;

  const _DistributionItem(this.label, this.val, this.color, this.textPrimary, this.textSecondary);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Expanded(child: Text(label, style: TextStyle(fontSize: 10, color: textSecondary))),
          Text(val, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary)),
        ],
      ),
    );
  }
}

class _MiniStatBox extends StatelessWidget {
  final String val;
  final String label;
  final IconData icon;
  final Color tileBg;
  final Color borderCol;
  final Color textPrimary;
  final Color textSecondary;

  const _MiniStatBox(this.val, this.label, this.icon, this.tileBg, this.borderCol, this.textPrimary, this.textSecondary);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: tileBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderCol)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF0053DB)),
          Text(val, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary)),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 6, color: textSecondary)),
        ],
      ),
    );
  }
}

class MultiLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pSiswa = Paint()..color = const Color(0xFF0053DB)..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final pGuru = Paint()..color = const Color(0xFF00A572)..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final pCbt = Paint()..color = const Color(0xFFD97706)..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final pPresensi = Paint()..color = const Color(0xFF0284C7)..strokeWidth = 2.5..style = PaintingStyle.stroke;

    final dotPaint = Paint()..style = PaintingStyle.fill;

    final pathSiswa = Path()..moveTo(0, size.height * 0.4)..lineTo(size.width * 0.2, size.height * 0.35)..lineTo(size.width * 0.4, size.height * 0.32)..lineTo(size.width * 0.6, size.height * 0.28)..lineTo(size.width * 0.8, size.height * 0.22)..lineTo(size.width, size.height * 0.18);
    canvas.drawPath(pathSiswa, pSiswa);

    final pathGuru = Path()..moveTo(0, size.height * 0.85)..lineTo(size.width * 0.2, size.height * 0.84)..lineTo(size.width * 0.4, size.height * 0.83)..lineTo(size.width * 0.6, size.height * 0.82)..lineTo(size.width * 0.8, size.height * 0.81)..lineTo(size.width, size.height * 0.8);
    canvas.drawPath(pathGuru, pGuru);

    final pathCbt = Path()..moveTo(0, size.height * 0.75)..lineTo(size.width * 0.2, size.height * 0.73)..lineTo(size.width * 0.4, size.height * 0.70)..lineTo(size.width * 0.6, size.height * 0.66)..lineTo(size.width * 0.8, size.height * 0.62)..lineTo(size.width, size.height * 0.58);
    canvas.drawPath(pathCbt, pCbt);

    final pathPresensi = Path()..moveTo(0, size.height * 0.25)..lineTo(size.width * 0.2, size.height * 0.23)..lineTo(size.width * 0.4, size.height * 0.21)..lineTo(size.width * 0.6, size.height * 0.19)..lineTo(size.width * 0.8, size.height * 0.16)..lineTo(size.width, size.height * 0.12);
    canvas.drawPath(pathPresensi, pPresensi);

    canvas.drawCircle(Offset(size.width, size.height * 0.18), 4, dotPaint..color = const Color(0xFF0053DB));
    canvas.drawCircle(Offset(size.width, size.height * 0.8), 4, dotPaint..color = const Color(0xFF00A572));
    canvas.drawCircle(Offset(size.width, size.height * 0.58), 4, dotPaint..color = const Color(0xFFD97706));
    canvas.drawCircle(Offset(size.width, size.height * 0.12), 4, dotPaint..color = const Color(0xFF0284C7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SingleTrendLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0053DB)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF0053DB)
      ..style = PaintingStyle.fill;

    final points = [
      Offset(0, size.height * 0.72),
      Offset(size.width * 0.16, size.height * 0.65),
      Offset(size.width * 0.33, size.height * 0.55),
      Offset(size.width * 0.5, size.height * 0.68),
      Offset(size.width * 0.66, size.height * 0.48),
      Offset(size.width * 0.83, size.height * 0.42),
      Offset(size.width, size.height * 0.52),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      path.lineTo(points[i + 1].dx, points[i + 1].dy);
    }

    canvas.drawPath(path, paint);

    for (var p in points) {
      canvas.drawCircle(p, 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/status_chip.dart';
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
    final user = context.watch<AuthProvider>().user;
    final userName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? 'Super Admin';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;
    final primaryAccent = isDark ? AppColors.electricCyan : AppColors.electricBlueLight;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? const AppSidebar(activeRoute: '/') : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(activeRoute: '/'),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  onToggleSidebar: isMobile ? () => _scaffoldKey.currentState?.openDrawer() : null,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Banner
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Selamat datang, $userName! 👑',
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Anda memiliki akses penuh terhadap seluruh sistem E-ACCESS.',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Mencetak Ringkasan Sistem PDF...')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? AppColors.backgroundCardDark : AppColors.backgroundCardLight,
                                foregroundColor: primaryAccent,
                                side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                              icon: const Icon(Icons.print_rounded, size: 18),
                              label: const Text('Cetak Ringkasan'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Top 5 Stat Cards (Matches Image 2 & 5)
                        GridView.count(
                          crossAxisCount: isMobile ? 2 : 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isMobile ? 1.2 : 1.3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            StatCard(
                              title: 'TOTAL SISWA',
                              value: '2.456',
                              icon: Icons.person_rounded,
                              iconColor: AppColors.siswaBlue,
                              subtitle: '↑ 12% dari bulan lalu',
                            ),
                            StatCard(
                              title: 'TOTAL GURU',
                              value: '156',
                              icon: Icons.person_search_rounded,
                              iconColor: AppColors.adminGreen,
                              subtitle: '↑ 8% dari bulan lalu',
                            ),
                            StatCard(
                              title: 'TOTAL KELAS',
                              value: '72',
                              icon: Icons.class_rounded,
                              iconColor: AppColors.purple,
                              subtitle: '↑ 6% dari bulan lalu',
                            ),
                            StatCard(
                              title: 'TOTAL CBT DIBUAT',
                              value: '348',
                              icon: Icons.assignment_rounded,
                              iconColor: AppColors.guruOrange,
                              subtitle: '↑ 15% dari bulan lalu',
                            ),
                            StatCard(
                              title: 'PERSENTASE PRESENSI',
                              value: '94,8%',
                              icon: Icons.access_time_rounded,
                              iconColor: AppColors.electricCyan,
                              subtitle: '↑ 5% dari bulan lalu',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section 2: Charts & Distributions
                        if (isMobile) ...[
                          _buildGraphCard(context),
                          const SizedBox(height: 16),
                          _buildSystemSummaryCard(context),
                          const SizedBox(height: 16),
                          _buildDistributionCard(context),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildGraphCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildSystemSummaryCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildDistributionCard(context)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Section 3: CBT Monitoring, Presensi & Rekap Nilai
                        if (isMobile) ...[
                          _buildCbtMonitoringCard(context),
                          const SizedBox(height: 16),
                          _buildTodayAttendanceCard(context),
                          const SizedBox(height: 16),
                          _buildAverageGradesCard(context),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: _buildCbtMonitoringCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildTodayAttendanceCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildAverageGradesCard(context)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Section 4: Activity Stream, Quick Actions, System Info
                        if (isMobile) ...[
                          _buildRecentActivityCard(context),
                          const SizedBox(height: 16),
                          _buildQuickActionsCard(context),
                          const SizedBox(height: 16),
                          _buildSystemInfoAndFormatsCard(context),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: _buildRecentActivityCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildQuickActionsCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildSystemInfoAndFormatsCard(context)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET CARDS MATCHING REFERENCE IMAGES ---

  Widget _buildGraphCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.electricCyan : AppColors.electricBlueLight;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Grafik Perkembangan Data (6 Bulan Terakhir)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart_rounded, size: 48, color: primaryAccent),
                  const SizedBox(height: 8),
                  const Text('Tren Siswa, Guru, CBT, & Presensi (94.8%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSummaryCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Sistem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 14),
          _buildSummaryRow(Icons.people_rounded, AppColors.success, 'Pengguna Aktif', '412 Online Sekarang'),
          const Divider(height: 16),
          _buildSummaryRow(Icons.storage_rounded, AppColors.siswaBlue, 'Database Size', '48,6 GB Penyimpanan'),
          const Divider(height: 16),
          _buildSummaryRow(Icons.cloud_upload_rounded, AppColors.warning, 'Backup Terakhir', '27/07/2026 02:00 WIB'),
          const Divider(height: 16),
          _buildSummaryRow(Icons.verified_rounded, AppColors.purple, 'Status Sistem', 'Optimal (v2.6.0)'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(subtitle, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Distribusi Data Siswa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: 0.78,
                    strokeWidth: 12,
                    backgroundColor: AppColors.borderDark,
                    color: AppColors.electricCyan,
                  ),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
                    Text('2.456', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildDistRow('X TKJ 1', '32% (786)'),
          _buildDistRow('X TKJ 2', '27% (664)'),
          _buildDistRow('XI TKJ 1', '21% (516)'),
        ],
      ),
    );
  }

  Widget _buildDistRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11)),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.electricCyan)),
        ],
      ),
    );
  }

  Widget _buildCbtMonitoringCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Monitoring CBT Berjalan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextButton(onPressed: () {}, child: const Text('Lihat Semua →', style: TextStyle(fontSize: 11))),
            ],
          ),
          const SizedBox(height: 8),
          _buildCbtRow('Ujian Akhir Semester Ganjil', 'X TKJ 1', '32', '20', '10', '2'),
          const Divider(height: 12),
          _buildCbtRow('Ulangan Harian - Bab Teks LHO', 'X TKJ 2', '30', '18', '9', '3'),
          const Divider(height: 12),
          _buildCbtRow('Latihan Soal Hikayat', 'XI RPL 1', '30', '22', '6', '2'),
        ],
      ),
    );
  }

  Widget _buildCbtRow(String title, String kelas, String peserta, String selesai, String sedang, String belum) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(kelas, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 10)),
            ],
          ),
        ),
        Expanded(flex: 1, child: StatusChip(status: '$selesai/$peserta', fontSize: 9)),
      ],
    );
  }

  Widget _buildTodayAttendanceCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Presensi Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.success, width: 6)),
                alignment: Alignment.center,
                child: const Text('85.1%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hadir: 2.092 Siswa', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                  Text('Ijin: 196 Siswa', style: TextStyle(color: AppColors.warning, fontSize: 11)),
                  Text('Sakit: 112 Siswa', style: TextStyle(color: AppColors.siswaBlue, fontSize: 11)),
                  Text('Alpa: 56 Siswa', style: TextStyle(color: AppColors.error, fontSize: 11)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAverageGradesCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rekap Nilai Rata-rata', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _buildGradeBar('X TKJ 1', 82.4),
          _buildGradeBar('X TKJ 2', 76.8),
          _buildGradeBar('XI TKJ 1', 79.2),
          _buildGradeBar('XI RPL 1', 74.6),
        ],
      ),
    );
  }

  Widget _buildGradeBar(String kelas, double score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(kelas, style: const TextStyle(fontSize: 11)),
              Text('$score', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.electricCyan)),
            ],
          ),
          const SizedBox(height: 2),
          LinearProgressIndicator(value: score / 100, color: AppColors.electricCyan, backgroundColor: AppColors.borderDark),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aktivitas Sistem Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          _buildActivityTimeline('10:30', 'Super Admin membuat akun guru baru'),
          _buildActivityTimeline('10:15', 'Import data siswa dari file Excel (2.456 data)'),
          _buildActivityTimeline('09:58', 'Backup database sistem otomatis berhasil'),
          _buildActivityTimeline('09:30', 'CBT "Ujian Akhir Semester" diterbitkan'),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline(String time, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(time, style: const TextStyle(color: AppColors.electricCyan, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(detail, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aksi Cepat (Super Admin)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(Icons.settings_rounded, 'Manajemen Sistem'),
              _buildActionButton(Icons.person_add_rounded, 'Manajemen Pengguna'),
              _buildActionButton(Icons.school_rounded, 'Data Akademik'),
              _buildActionButton(Icons.assignment_rounded, 'Kelola CBT'),
              _buildActionButton(Icons.backup_rounded, 'Backup Database'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.electricBlue.withAlpha(25),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.electricBlue.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.electricCyan),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfoAndFormatsCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Format Data Yang Didukung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [Icon(Icons.table_chart_rounded, color: Colors.green, size: 24), Text('Excel', style: TextStyle(fontSize: 10))]),
              Column(children: [Icon(Icons.insert_drive_file_rounded, color: Colors.teal, size: 24), Text('CSV', style: TextStyle(fontSize: 10))]),
              Column(children: [Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 24), Text('PDF', style: TextStyle(fontSize: 10))]),
              Column(children: [Icon(Icons.description_rounded, color: Colors.blue, size: 24), Text('Word', style: TextStyle(fontSize: 10))]),
            ],
          ),
        ],
      ),
    );
  }
}

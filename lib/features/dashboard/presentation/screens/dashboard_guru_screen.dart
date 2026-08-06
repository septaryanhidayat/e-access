import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardGuruScreen extends StatefulWidget {
  const DashboardGuruScreen({super.key});

  @override
  State<DashboardGuruScreen> createState() => _DashboardGuruScreenState();
}

class _DashboardGuruScreenState extends State<DashboardGuruScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final guruName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? 'Budi Santoso, S.Pd.';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;

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
                                Text(
                                  'Selamat datang, $guruName! 👋',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Kelola kelas, materi, dan penilaian siswa dengan mudah dan efisien.',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Top 5 Stat Cards (Matches Image 3)
                        GridView.count(
                          crossAxisCount: isMobile ? 2 : 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isMobile ? 1.2 : 1.3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const StatCard(
                              title: 'KELAS DIAMPU',
                              value: '5 Kelas',
                              icon: Icons.class_rounded,
                              iconColor: AppColors.siswaBlue,
                              subtitle: 'Kelas Aktif',
                            ),
                            const StatCard(
                              title: 'TOTAL SISWA',
                              value: '148 Siswa',
                              icon: Icons.groups_rounded,
                              iconColor: AppColors.adminGreen,
                              subtitle: 'Siswa Aktif',
                            ),
                            const StatCard(
                              title: 'TOTAL CBT DIBUAT',
                              value: '18 Ujian',
                              icon: Icons.assignment_rounded,
                              iconColor: AppColors.purple,
                              subtitle: 'Ujian / Tugas',
                            ),
                            const StatCard(
                              title: 'RATA-RATA NILAI',
                              value: '78,6',
                              icon: Icons.star_rounded,
                              iconColor: AppColors.guruOrange,
                              subtitle: 'Dari Semua Ujian',
                            ),
                            const StatCard(
                              title: 'PERSENTASE PRESENSI',
                              value: '92,4%',
                              icon: Icons.access_time_rounded,
                              iconColor: AppColors.electricCyan,
                              subtitle: 'Rata-rata Kehadiran',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section 2: Ringkasan Kelas & Performance Chart & Presensi
                        if (isMobile) ...[
                          _buildClassesSummaryCard(context),
                          const SizedBox(height: 16),
                          _buildClassPerformanceChartCard(context),
                          const SizedBox(height: 16),
                          _buildClassAttendanceCard(context),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildClassesSummaryCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildClassPerformanceChartCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildClassAttendanceCard(context)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Section 3: CBT Terbaru & Activity Stream
                        if (isMobile) ...[
                          _buildRecentCbtCard(context),
                          const SizedBox(height: 16),
                          _buildTeacherActivityCard(context),
                          const SizedBox(height: 16),
                          _buildAnnouncementsCard(context),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: _buildRecentCbtCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildTeacherActivityCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildAnnouncementsCard(context)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Section 4: Quick Menu, Learning Analytics & Schedule
                        if (isMobile) ...[
                          _buildQuickMenuCard(context),
                          const SizedBox(height: 16),
                          _buildLearningAnalyticsCard(context),
                          const SizedBox(height: 16),
                          _buildTeachingScheduleCard(context),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildQuickMenuCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildLearningAnalyticsCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildTeachingScheduleCard(context)),
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

  Widget _buildClassesSummaryCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Kelas yang Diampu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _buildClassSummaryRow('X TKJ 1', '32 Siswa', '82.4', '94.1%'),
          const Divider(height: 12),
          _buildClassSummaryRow('X TKJ 2', '30 Siswa', '76.8', '91.3%'),
          const Divider(height: 12),
          _buildClassSummaryRow('XI TKJ 1', '28 Siswa', '79.2', '93.7%'),
        ],
      ),
    );
  }

  Widget _buildClassSummaryRow(String kelas, String siswa, String nilai, String presensi) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kelas, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(siswa, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 10)),
          ],
        ),
        Text('Nilai: $nilai', style: const TextStyle(fontSize: 11, color: AppColors.electricCyan, fontWeight: FontWeight.bold)),
        StatusChip(status: presensi, fontSize: 9),
      ],
    );
  }

  Widget _buildClassPerformanceChartCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.electricCyan : AppColors.electricBlueLight;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Grafik Performa Kelas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Container(
            height: 120,
            decoration: BoxDecoration(color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Icon(Icons.analytics_rounded, size: 40, color: primaryAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildClassAttendanceCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Presensi Siswa Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.success, width: 5)),
                alignment: Alignment.center,
                child: const Text('91.9%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hadir: 136', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text('Ijin: 6', style: TextStyle(color: AppColors.warning, fontSize: 10)),
                  Text('Sakit: 4 | Alpa: 2', style: TextStyle(color: AppColors.error, fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCbtCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CBT Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.electricBlue, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                icon: const Icon(Icons.add_rounded, size: 14),
                label: const Text('Buat CBT Baru', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildCbtTile('Ujian Akhir Semester Ganjil', 'X TKJ 1', 'Selesai', '32/32'),
          const Divider(height: 10),
          _buildCbtTile('Ulangan Harian - Bab Teks LHO', 'XI TKJ 2', 'Berlangsung', '25/28'),
        ],
      ),
    );
  }

  Widget _buildCbtTile(String title, String kelas, String status, String peserta) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(kelas, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 10)),
            ],
          ),
        ),
        StatusChip(status: '$status ($peserta)', fontSize: 9),
      ],
    );
  }

  Widget _buildTeacherActivityCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aktivitas Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          _buildActivityTile('CBT Ujian Akhir Dibuat', '10:30'),
          _buildActivityTile('Materi PDF baru diunggah', '09:25'),
          _buildActivityTile('Nilai CBT diinput', 'Kemarin'),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
          Text(time, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pengumuman & Informasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          _buildNoticeItem('Ujian Akhir Semester Ganjil', '1 - 7 Agustus 2026', AppColors.electricCyan),
          const SizedBox(height: 6),
          _buildNoticeItem('Libur Hari Kemerdekaan RI', '17 Agustus 2026', AppColors.purple),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(String title, String date, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withAlpha(60))),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                Text(date, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenuCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Menu Cepat Guru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTeacherMenuChip(Icons.note_add_rounded, 'Buat CBT'),
              _buildTeacherMenuChip(Icons.upload_file_rounded, 'Upload Materi'),
              _buildTeacherMenuChip(Icons.fact_check_rounded, 'E-Presensi'),
              _buildTeacherMenuChip(Icons.grade_rounded, 'Input Nilai'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherMenuChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: AppColors.electricBlue.withAlpha(25), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.electricBlue.withAlpha(80))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.electricCyan),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLearningAnalyticsCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Learning Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rata-rata: 78.6', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.electricCyan)),
              Text('Tren: Naik ▲ 6.2%', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeachingScheduleCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Jadwal Mengajar Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          _buildScheduleRow('08:00 - 09:30', 'X TKJ 1', 'Bahasa Indonesia'),
          const Divider(height: 8),
          _buildScheduleRow('10:00 - 11:30', 'XI TKJ 1', 'Bahasa Indonesia'),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String time, String kelas, String subject) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(time, style: const TextStyle(fontSize: 10, color: AppColors.electricCyan, fontWeight: FontWeight.bold)),
        Text('$kelas • $subject', style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

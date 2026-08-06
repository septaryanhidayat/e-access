import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardSiswaScreen extends StatefulWidget {
  const DashboardSiswaScreen({super.key});

  @override
  State<DashboardSiswaScreen> createState() => _DashboardSiswaScreenState();
}

class _DashboardSiswaScreenState extends State<DashboardSiswaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final userName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? 'Andi Pratama';

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
                                  'Selamat datang, $userName! 👋',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tetap semangat belajar dan selesaikan setiap tugas dengan baik.',
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

                        // Top 5 Stat Cards (Matches Image 4)
                        GridView.count(
                          crossAxisCount: isMobile ? 2 : 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isMobile ? 1.2 : 1.3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const StatCard(
                              title: 'TOTAL CBT',
                              value: '18 CBT',
                              icon: Icons.assignment_rounded,
                              iconColor: AppColors.siswaBlue,
                              subtitle: 'CBT Tersedia',
                            ),
                            const StatCard(
                              title: 'CBT SELESAI',
                              value: '12 (66,7%)',
                              icon: Icons.check_circle_rounded,
                              iconColor: AppColors.success,
                              subtitle: 'Selesai Dikerjakan',
                            ),
                            const StatCard(
                              title: 'CBT BELUM SELESAI',
                              value: '6 (33,3%)',
                              icon: Icons.hourglass_top_rounded,
                              iconColor: AppColors.purple,
                              subtitle: 'Menunggu Dikerjakan',
                            ),
                            const StatCard(
                              title: 'RATA-RATA NILAI',
                              value: '78,6',
                              icon: Icons.star_rounded,
                              iconColor: AppColors.guruOrange,
                              subtitle: 'Dari Semua Ujian',
                            ),
                            const StatCard(
                              title: 'PERINGKAT KELAS',
                              value: '7 dari 32',
                              icon: Icons.military_tech_rounded,
                              iconColor: AppColors.electricCyan,
                              subtitle: 'Siswa Kelas X TKJ 1',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section 2: CBT Tersedia & Ringkasan Nilai
                        if (isMobile) ...[
                          _buildAvailableCbtCard(context),
                          const SizedBox(height: 16),
                          _buildMyGradesSummaryCard(context),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: _buildAvailableCbtCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildMyGradesSummaryCard(context)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Section 3: Materi Terbaru, Aktivitas & Pengumuman
                        if (isMobile) ...[
                          _buildLatestMaterialsCard(context),
                          const SizedBox(height: 16),
                          _buildStudentActivityCard(context),
                          const SizedBox(height: 16),
                          _buildAnnouncementsCard(context),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildLatestMaterialsCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildStudentActivityCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildAnnouncementsCard(context)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Section 4: Progres Belajar & Waktu Belajar
                        if (isMobile) ...[
                          _buildLearningProgressCard(context),
                          const SizedBox(height: 16),
                          _buildStudyTimeCard(context),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: _buildLearningProgressCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildStudyTimeCard(context)),
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

  Widget _buildAvailableCbtCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CBT Tersedia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextButton(onPressed: () {}, child: const Text('Lihat Semua →', style: TextStyle(fontSize: 11))),
            ],
          ),
          const SizedBox(height: 10),
          _buildCbtItem(context, 'Ujian Akhir Semester Ganjil', 'Bahasa Indonesia', '90 Mnt', true, 'demo_1'),
          const Divider(height: 12),
          _buildCbtItem(context, 'Ulangan Harian - Bab Teks Anekdot', 'Bahasa Indonesia', '60 Mnt', true, 'demo_2'),
          const Divider(height: 12),
          _buildCbtItem(context, 'Latihan Soal Hikayat', 'Bahasa Indonesia', '40 Mnt', false, 'demo_3'),
        ],
      ),
    );
  }

  Widget _buildCbtItem(BuildContext context, String title, String subject, String duration, bool isActive, String id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text('$subject • Durasi: $duration', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => context.push('/cbt_exam/$id'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? AppColors.electricBlue : AppColors.borderDark,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text(
            isActive ? 'Kerjakan' : 'Belum Dibuka',
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildMyGradesSummaryCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Nilai Saya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.electricCyan, width: 6)),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('78,6', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('Baik', style: TextStyle(fontSize: 9, color: AppColors.success)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nilai ≥ 80: 5 CBT', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                    Text('Nilai 70 - 79: 4 CBT', style: TextStyle(color: AppColors.siswaBlue, fontSize: 11)),
                    Text('Nilai 60 - 69: 2 CBT', style: TextStyle(color: AppColors.warning, fontSize: 11)),
                    Text('Nilai < 60: 1 CBT', style: TextStyle(color: AppColors.error, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLatestMaterialsCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Materi Pembelajaran Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          _buildMaterialRow(context, 'Teks Laporan Hasil Observasi (LHO)', 'PDF Literasi • Kelas X TKJ 1', 'mat_1'),
          const Divider(height: 12),
          _buildMaterialRow(context, 'Tutorial State Management Provider', 'Video YouTube • Kelas X TKJ 1', 'mat_3'),
        ],
      ),
    );
  }

  Widget _buildMaterialRow(BuildContext context, String title, String subtitle, String id) {
    return InkWell(
      onTap: () => context.push('/material_detail/$id'),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf_rounded, color: AppColors.electricCyan, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentActivityCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aktivitas Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          _buildActivityTimeline('CBT Ujian Akhir Selesai (Score: 92)', '10:30'),
          _buildActivityTimeline('Materi Teks Anektod dibaca (15 mnt)', '09:25'),
          _buildActivityTimeline('Presensi Kelas Hadir tepat waktu', 'Kemarin'),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline(String title, String time) {
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
          const Text('Pengumuman Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          _buildNoticeItem('Ujian Akhir Semester Ganjil', '1 - 7 Agu 2026', AppColors.electricCyan),
          const SizedBox(height: 6),
          _buildNoticeItem('Pengumpulan Tugas PKK', 'Batas 31 Juli 2026', AppColors.success),
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
          Icon(Icons.notifications_active_rounded, color: color, size: 16),
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

  Widget _buildLearningProgressCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Progres Belajar & Kehadiran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressCircle('CBT', '66.7%', AppColors.electricCyan),
              _buildProgressCircle('Materi', '75%', AppColors.purple),
              _buildProgressCircle('Tugas', '80%', AppColors.warning),
              _buildProgressCircle('Presensi', '92.4%', AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 4)),
          alignment: Alignment.center,
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
      ],
    );
  }

  Widget _buildStudyTimeCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Waktu Belajar Minggu Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.access_time_filled_rounded, color: AppColors.electricCyan, size: 20),
              SizedBox(width: 8),
              Text('6 Jam 45 Menit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.electricCyan)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Rata-rata per hari: 1 Jam 21 Menit', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }
}

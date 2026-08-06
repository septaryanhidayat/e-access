import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Learning Analytics & Rekapitulasi',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Statistik jam belajar, lama baca materi, lama nonton video, dan analisis hasil CBT.',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mengekspor Laporan Rapor PDF...')));
                              },
                              icon: const Icon(Icons.file_download_rounded),
                              label: const Text('Export Laporan PDF'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        GridView.count(
                          crossAxisCount: isMobile ? 2 : 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: const [
                            StatCard(
                              title: 'TOTAL JAM BELAJAR',
                              value: '1.240 Jam',
                              icon: Icons.timer_rounded,
                              iconColor: AppColors.electricCyan,
                              subtitle: 'Seluruh Siswa',
                            ),
                            StatCard(
                              title: 'MATERI DIBACA',
                              value: '458 Kali',
                              icon: Icons.auto_stories_rounded,
                              iconColor: AppColors.siswaBlue,
                              subtitle: 'PDF & Modul',
                            ),
                            StatCard(
                              title: 'VIDEO DITONTON',
                              value: '312 Kali',
                              icon: Icons.video_library_rounded,
                              iconColor: AppColors.guruOrange,
                              subtitle: 'YouTube External',
                            ),
                            StatCard(
                              title: 'RATA-RATA NILAI CBT',
                              value: '78,6',
                              icon: Icons.star_rounded,
                              iconColor: AppColors.success,
                              subtitle: 'Kategori Baik',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Aktivitas Belajar Teraktif Siswa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 12),
                              _buildStudentRankRow('1', 'Andi Pratama (X TKJ 1)', '42 Jam Belajar', 'Nilai: 94.5'),
                              const Divider(height: 12),
                              _buildStudentRankRow('2', 'Siti Aminah (X TKJ 1)', '38 Jam Belajar', 'Nilai: 91.2'),
                              const Divider(height: 12),
                              _buildStudentRankRow('3', 'Rudi Hermawan (XI RPL 1)', '35 Jam Belajar', 'Nilai: 88.0'),
                            ],
                          ),
                        ),
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

  Widget _buildStudentRankRow(String rank, String name, String time, String score) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: AppColors.electricBlue, shape: BoxShape.circle),
          child: Text(rank, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
            ],
          ),
        ),
        Text(score, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.electricCyan)),
      ],
    );
  }
}

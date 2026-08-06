import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
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
  String _selectedTimeFilter = '6 Bulan Terakhir';

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final guruName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? 'Budi Santoso, S.Pd.';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;
    final primaryAccent = isDark ? AppColors.electricCyan : AppColors.electricBlueLight;

    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF8D90A0) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
    final tileBg = isDark ? const Color(0xFF0B1326) : const Color(0xFFF8FAFC);
    final borderCol = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

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
                                Text('Selamat datang, $guruName 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)),
                                const SizedBox(height: 4),
                                Text('Kelola kelas, materi, dan penilaian siswa dengan mudah dan efisien.', style: TextStyle(color: textSecondary, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Top 5 Stat Cards (Metrics Grid for Level 3 Guru)
                        GridView.count(
                          crossAxisCount: isMobile ? 2 : 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isMobile ? 1.2 : 1.3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildStatMetricCard(context, 'KELAS YANG DIAMPU', '5', 'Kelas Aktif', Icons.class_rounded, const Color(0xFF0053DB), '/academic', cardBg, borderCol, textPrimary, textSecondary),
                            _buildStatMetricCard(context, 'TOTAL SISWA', '148', 'Siswa Aktif', Icons.groups_rounded, const Color(0xFF00A572), '/students', cardBg, borderCol, textPrimary, textSecondary),
                            _buildStatMetricCard(context, 'TOTAL CBT DIBUAT', '18', 'Ujian / Tugas', Icons.assignment_rounded, const Color(0xFF9333EA), '/manage_cbt', cardBg, borderCol, textPrimary, textSecondary),
                            _buildStatMetricCard(context, 'RATA-RATA NILAI', '78,6', 'Dari Semua Ujian', Icons.assessment_rounded, const Color(0xFFD97706), '/grades', cardBg, borderCol, textPrimary, textSecondary),
                            _buildStatMetricCard(context, 'PERSENTASE PRESENSI', '92,4%', 'Rata-rata Kehadiran', Icons.timer_rounded, const Color(0xFF0284C7), '/attendance', cardBg, borderCol, textPrimary, textSecondary),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Middle Row 1
                        if (isMobile) ...[
                          _buildClassSummaryCard(context, textPrimary, textSecondary),
                          const SizedBox(height: 16),
                          _buildClassPerformanceChartCard(textPrimary, textSecondary),
                          const SizedBox(height: 16),
                          _buildTeacherAttendanceDonutCard(context, textPrimary, textSecondary),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: _buildClassSummaryCard(context, textPrimary, textSecondary)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildClassPerformanceChartCard(textPrimary, textSecondary)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildTeacherAttendanceDonutCard(context, textPrimary, textSecondary)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Middle Row 2
                        if (isMobile) ...[
                          _buildRecentCbtsCard(context, textPrimary, textSecondary),
                          const SizedBox(height: 16),
                          _buildRecentActivitiesCard(context, textPrimary, textSecondary),
                          const SizedBox(height: 16),
                          _buildAnnouncementsCard(context, tileBg, borderCol, textPrimary, textSecondary),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: _buildRecentCbtsCard(context, textPrimary, textSecondary)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildRecentActivitiesCard(context, textPrimary, textSecondary)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildAnnouncementsCard(context, tileBg, borderCol, textPrimary, textSecondary)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Bottom Row 3
                        if (isMobile) ...[
                          _buildTeacherQuickMenuCard(context, tileBg, borderCol, textPrimary, textSecondary),
                          const SizedBox(height: 16),
                          _buildTeacherLearningAnalyticsCard(tileBg, borderCol, textPrimary, textSecondary),
                          const SizedBox(height: 16),
                          _buildTeachingScheduleCard(context, tileBg, borderCol, textPrimary, textSecondary),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: _buildTeacherQuickMenuCard(context, tileBg, borderCol, textPrimary, textSecondary)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildTeacherLearningAnalyticsCard(tileBg, borderCol, textPrimary, textSecondary)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildTeachingScheduleCard(context, tileBg, borderCol, textPrimary, textSecondary)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 30),

                        Center(child: Text('© 2026 E-ACCESS - Electronic Assessment & Classroom System. All rights reserved.', style: TextStyle(color: textSecondary, fontSize: 11))),
                        const SizedBox(height: 10),
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

  Widget _buildStatMetricCard(BuildContext context, String title, String value, String subtitle, IconData icon, Color color, String route, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
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
            const Row(children: [Text('Lihat Detail →', style: TextStyle(fontSize: 10, color: Color(0xFF0053DB), fontWeight: FontWeight.w600))]),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSummaryCard(BuildContext context, Color textPrimary, Color textSecondary) {
    final classes = [
      {'name': 'X TKJ 1', 'students': '32 Siswa', 'grade': '82,4', 'att': '94,1%', 'color': const Color(0xFF00A572)},
      {'name': 'X TKJ 2', 'students': '30 Siswa', 'grade': '76,8', 'att': '91,3%', 'color': const Color(0xFF0053DB)},
      {'name': 'XI TKJ 1', 'students': '28 Siswa', 'grade': '79,2', 'att': '93,7%', 'color': const Color(0xFF9333EA)},
      {'name': 'XI RPL 1', 'students': '29 Siswa', 'grade': '74,6', 'att': '90,2%', 'color': const Color(0xFFD97706)},
      {'name': 'X Bahasa 1', 'students': '29 Siswa', 'grade': '79,6', 'att': '92,8%', 'color': const Color(0xFF0284C7)},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan Kelas yang Diampu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              headingRowHeight: 32,
              dataRowHeight: 36,
              columns: [
                DataColumn(label: Text('Kelas', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Siswa', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Rata-rata Nilai', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Presensi', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Aksi', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
              ],
              rows: classes.map((c) {
                final name = c['name'] as String;
                final students = c['students'] as String;
                final grade = c['grade'] as String;
                final att = c['att'] as String;
                final color = c['color'] as Color;

                return DataRow(
                  cells: [
                    DataCell(Text(name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary))),
                    DataCell(Text(students, style: TextStyle(fontSize: 11, color: textSecondary))),
                    DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text(grade, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)))),
                    DataCell(Text(att, style: const TextStyle(fontSize: 11, color: Color(0xFF00A572), fontWeight: FontWeight.bold))),
                    DataCell(IconButton(icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: Color(0xFF0053DB)), onPressed: () => _showClassDetailDialog(context, name, students, grade, att))),
                  ],
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => context.go('/academic'), child: const Text('Lihat Semua Kelas →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
          ),
        ],
      ),
    );
  }

  Widget _buildClassPerformanceChartCard(Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grafik Performa Kelas (Rata-rata Nilai)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
              DropdownButton<String>(
                value: _selectedTimeFilter,
                dropdownColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131B2E) : Colors.white,
                style: const TextStyle(color: Color(0xFF0053DB), fontSize: 10),
                underline: const SizedBox(),
                items: ['6 Bulan Terakhir', '1 Semester', '1 Tahun'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedTimeFilter = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _LegendDot('X TKJ 1', const Color(0xFF0053DB), textSecondary),
              const SizedBox(width: 8),
              _LegendDot('X TKJ 2', const Color(0xFF00A572), textSecondary),
              const SizedBox(width: 8),
              _LegendDot('XI TKJ 1', const Color(0xFF9333EA), textSecondary),
              const SizedBox(width: 8),
              _LegendDot('XI RPL 1', const Color(0xFFD97706), textSecondary),
              const SizedBox(width: 8),
              _LegendDot('X Bahasa 1', const Color(0xFF0284C7), textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(height: 130, width: double.infinity, child: CustomPaint(painter: TeacherMultiLinePainter())),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul'].map((m) => Text(m, style: TextStyle(fontSize: 10, color: textSecondary))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherAttendanceDonutCard(BuildContext context, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Presensi Siswa Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
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
                    Text('148', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                    Text('Total Siswa', style: TextStyle(fontSize: 8, color: textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DistributionItem('Hadir', '136 (91,9%)', const Color(0xFF00A572), textPrimary, textSecondary),
                    _DistributionItem('Ijin', '6 (4,1%)', const Color(0xFFD97706), textPrimary, textSecondary),
                    _DistributionItem('Sakit', '4 (2,7%)', const Color(0xFF0053DB), textPrimary, textSecondary),
                    _DistributionItem('Alpa', '2 (1,3%)', const Color(0xFFDC2626), textPrimary, textSecondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => context.go('/attendance'), child: const Text('Lihat E-Presensi →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCbtsCard(BuildContext context, Color textPrimary, Color textSecondary) {
    final cbts = [
      {'title': 'Ujian Akhir Semester Ganjil', 'class': 'X TKJ 1', 'type': 'Ujian', 'status': 'Selesai', 'stColor': const Color(0xFF00A572), 'count': '32/32'},
      {'title': 'Ulangan Harian - Bab Teks LHO', 'class': 'XI TKJ 2', 'type': 'Ulangan', 'status': 'Selesai', 'stColor': const Color(0xFF00A572), 'count': '30/30'},
      {'title': 'Ujian Akhir Semester Ganjil', 'class': 'XI TKJ 1', 'type': 'Ujian', 'status': 'Berlangsung', 'stColor': const Color(0xFF0053DB), 'count': '25/28'},
      {'title': 'Latihan Soal Hikayat', 'class': 'XI RPL 1', 'type': 'Latihan', 'status': 'Selesai', 'stColor': const Color(0xFF00A572), 'count': '30/30'},
      {'title': 'Ulangan Harian - Teks Anekdot', 'class': 'X Bahasa 1', 'type': 'Ulangan', 'status': 'Dijadwalkan', 'stColor': const Color(0xFF9333EA), 'count': '0/28'},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CBT Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 12,
              headingRowHeight: 32,
              dataRowHeight: 36,
              columns: [
                DataColumn(label: Text('Judul CBT', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Kelas', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Tipe', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Peserta', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Aksi', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold))),
              ],
              rows: cbts.map((c) {
                final title = c['title'] as String;
                final className = c['class'] as String;
                final type = c['type'] as String;
                final status = c['status'] as String;
                final stColor = c['stColor'] as Color;
                final count = c['count'] as String;

                return DataRow(
                  cells: [
                    DataCell(Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary))),
                    DataCell(Text(className, style: TextStyle(fontSize: 11, color: textSecondary))),
                    DataCell(Text(type, style: TextStyle(fontSize: 11, color: textPrimary))),
                    DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: stColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text(status, style: TextStyle(color: stColor, fontSize: 9, fontWeight: FontWeight.bold)))),
                    DataCell(Text(count, style: TextStyle(fontSize: 11, color: textPrimary))),
                    DataCell(Row(children: [IconButton(icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: Color(0xFF0053DB)), onPressed: () => _showCbtDetailDialog(context, title, className, status)), IconButton(icon: const Icon(Icons.bar_chart_rounded, size: 16, color: Color(0xFF00A572)), onPressed: () => _showCbtAnalyticsDialog(context, title, count))])),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: () => context.go('/manage_cbt'), child: const Text('Lihat Semua CBT →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
              ElevatedButton.icon(
                onPressed: () => _showCreateCbtModal(context),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('+ Buat CBT Baru'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0053DB), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesCard(BuildContext context, Color textPrimary, Color textSecondary) {
    final activities = [
      {'title': 'CBT Ujian Akhir Semester Ganjil', 'sub': 'XI TKJ 1 - 32 peserta', 'time': '10:30', 'icon': Icons.assignment_rounded, 'color': const Color(0xFF0053DB)},
      {'title': 'Materi baru diunggah', 'sub': 'Teks Laporan Hasil Observasi (X TKJ 1)', 'time': '09:25', 'icon': Icons.cloud_upload_rounded, 'color': const Color(0xFF9333EA)},
      {'title': 'Nilai CBT diinput', 'sub': 'Ulangan Harian - Hikayat (XI RPL 1)', 'time': 'Kemarin', 'icon': Icons.assessment_rounded, 'color': const Color(0xFF00A572)},
      {'title': 'Presensi kelas diperbarui', 'sub': 'X Bahasa 1 - 28 siswa', 'time': 'Kemarin', 'icon': Icons.fact_check_rounded, 'color': const Color(0xFF0284C7)},
      {'title': 'Bank Soal diperbarui', 'sub': 'Menambahkan 15 soal baru', 'time': '2 hari lalu', 'icon': Icons.menu_book_rounded, 'color': const Color(0xFFD97706)},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aktivitas Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 12),
          Column(
            children: activities.map((a) {
              final title = a['title'] as String;
              final sub = a['sub'] as String;
              final time = a['time'] as String;
              final icon = a['icon'] as IconData;
              final color = a['color'] as Color;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary)),
                          Text(sub, style: TextStyle(fontSize: 9, color: textSecondary)),
                        ],
                      ),
                    ),
                    Text(time, style: TextStyle(fontSize: 9, color: textSecondary)),
                  ],
                ),
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => _showAllActivitiesDialog(context), child: const Text('Lihat Semua Aktivitas →', style: TextStyle(color: Color(0xFF0053DB), fontSize: 11))),
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
              Text('Pengumuman & Informasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
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

  Widget _buildTeacherQuickMenuCard(BuildContext context, Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    final menus = [
      {'title': 'Buat CBT Baru', 'icon': Icons.note_add_rounded, 'color': const Color(0xFF0053DB), 'action': () => _showCreateCbtModal(context)},
      {'title': 'Upload Materi', 'icon': Icons.cloud_upload_rounded, 'color': const Color(0xFF0053DB), 'action': () => context.go('/materials')},
      {'title': 'Import Soal', 'icon': Icons.file_present_rounded, 'color': const Color(0xFFD97706), 'action': () => _showImportQuestionsModal(context)},
      {'title': 'E-Presensi', 'icon': Icons.fact_check_rounded, 'color': const Color(0xFF00A572), 'action': () => context.go('/attendance')},
      {'title': 'Input Nilai', 'icon': Icons.grade_rounded, 'color': const Color(0xFF9333EA), 'action': () => context.go('/grades')},
      {'title': 'Laporan Kelas', 'icon': Icons.analytics_rounded, 'color': const Color(0xFF0284C7), 'action': () => context.go('/analytics')},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Menu Cepat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: menus.map((m) {
              final title = m['title'] as String;
              final icon = m['icon'] as IconData;
              final color = m['color'] as Color;
              final action = m['action'] as VoidCallback;

              return InkWell(
                onTap: action,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: tileBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderCol)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)),
                      const SizedBox(height: 6),
                      Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: textPrimary, fontWeight: FontWeight.bold, height: 1.1)),
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

  Widget _buildTeacherLearningAnalyticsCard(Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Learning Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1.1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _AnalyticsBox('Rata-rata Nilai', '78,6', const Color(0xFF00A572), tileBg, borderCol, textPrimary, textSecondary),
              _AnalyticsBox('Nilai Tertinggi', '96', const Color(0xFF00A572), tileBg, borderCol, textPrimary, textSecondary),
              _AnalyticsBox('Nilai Terendah', '45', const Color(0xFFDC2626), tileBg, borderCol, textPrimary, textSecondary),
              _AnalyticsBox('Tren Nilai', 'Naik ▲ 6,2%', const Color(0xFF00A572), tileBg, borderCol, textPrimary, textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeachingScheduleCard(BuildContext context, Color tileBg, Color borderCol, Color textPrimary, Color textSecondary) {
    final schedules = [
      {'time': '08:00 - 09:30', 'class': 'X TKJ 1', 'subject': 'Bahasa Indonesia', 'room': 'Ruang R1'},
      {'time': '10:00 - 11:30', 'class': 'XI TKJ 1', 'subject': 'Bahasa Indonesia', 'room': 'Ruang R2'},
      {'time': '13:00 - 14:30', 'class': 'X Bahasa 1', 'subject': 'Bahasa Indonesia', 'room': 'Ruang R3'},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jadwal Mengajar Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
              TextButton(onPressed: () => _showScheduleModal(context), child: const Text('Lihat Jadwal', style: TextStyle(color: Color(0xFF0053DB), fontSize: 10))),
            ],
          ),
          const SizedBox(height: 6),
          Column(
            children: schedules.map((s) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(color: tileBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderCol)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s['time']!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0053DB))),
                    Text(s['class']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary)),
                    Text(s['subject']!, style: TextStyle(fontSize: 9, color: textSecondary)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: borderCol, borderRadius: BorderRadius.circular(4)), child: Text(s['room']!, style: TextStyle(fontSize: 8, color: textPrimary))),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Dialog Helpers
  void _showClassDetailDialog(BuildContext context, String className, String students, String grade, String att) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Kelas $className', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('👥 Jumlah Siswa: $students', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 4),
            Text('📊 Rata-rata Nilai CBT: $grade', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('📅 Persentase Kehadiran: $att', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showCbtDetailDialog(BuildContext context, String title, String className, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text('Rincian ujian CBT untuk kelas $className (Status: $status).', style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showCbtAnalyticsDialog(BuildContext context, String title, String count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Analisis Hasil: $title', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text('Partisipasi Siswa: $count tuntas mengerjakan.', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showCreateCbtModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buat CBT Baru (Level 3 Guru)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Judul Ujian CBT')),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CBT Baru Berhasil Dibuat!')));
              },
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('SIMPAN & RILIS CBT'),
            ),
          ],
        ),
      ),
    );
  }

  void _showImportQuestionsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Bank Soal (Excel/PDF)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Pilih file bank soal dari komputer Anda untuk dimasukkan ke sistem CBT.', style: TextStyle(fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('15 Soal Berhasil Diimpor ke Bank Soal!')));
            },
            child: const Text('Upload File'),
          ),
        ],
      ),
    );
  }

  void _showAllActivitiesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Semua Aktivitas Mengajar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Histori aktivitas pembuatan CBT, upload materi, dan input nilai.', style: TextStyle(fontSize: 12)),
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
        title: const Text('Pengumuman Sekolah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Ujian Akhir Semester Ganjil (1-7 Ags 2026)', style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            Text('2. Pengumpulan Tugas PKK (s/d 31 Jul 2026)', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showScheduleModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jadwal Pekan Ini (Budi Santoso, S.Pd.)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Senin: 08:00 - 09:30 (X TKJ 1)', style: TextStyle(fontSize: 12)),
            Text('• Selasa: 10:00 - 11:30 (XI TKJ 1)', style: TextStyle(fontSize: 12)),
            Text('• Rabu: 13:00 - 14:30 (X Bahasa 1)', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
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

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;
  final Color textSecondary;

  const _LegendDot(this.label, this.color, this.textSecondary);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 9, color: textSecondary)),
      ],
    );
  }
}

class _AnalyticsBox extends StatelessWidget {
  final String label;
  final String val;
  final Color color;
  final Color tileBg;
  final Color borderCol;
  final Color textPrimary;
  final Color textSecondary;

  const _AnalyticsBox(this.label, this.val, this.color, this.tileBg, this.borderCol, this.textPrimary, this.textSecondary);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: tileBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderCol)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 7.5, color: textSecondary)),
          const SizedBox(height: 2),
          Text(val, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class TeacherMultiLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()..color = const Color(0xFF0053DB)..strokeWidth = 2.0..style = PaintingStyle.stroke;
    final p2 = Paint()..color = const Color(0xFF00A572)..strokeWidth = 2.0..style = PaintingStyle.stroke;
    final p3 = Paint()..color = const Color(0xFF9333EA)..strokeWidth = 2.0..style = PaintingStyle.stroke;
    final p4 = Paint()..color = const Color(0xFFD97706)..strokeWidth = 2.0..style = PaintingStyle.stroke;
    final p5 = Paint()..color = const Color(0xFF0284C7)..strokeWidth = 2.5..style = PaintingStyle.stroke;

    final dotPaint = Paint()..style = PaintingStyle.fill;

    final path1 = Path()..moveTo(0, size.height * 0.3)..lineTo(size.width * 0.2, size.height * 0.25)..lineTo(size.width * 0.4, size.height * 0.28)..lineTo(size.width * 0.6, size.height * 0.35)..lineTo(size.width * 0.8, size.height * 0.22)..lineTo(size.width, size.height * 0.18);
    canvas.drawPath(path1, p1);

    final path2 = Path()..moveTo(0, size.height * 0.5)..lineTo(size.width * 0.2, size.height * 0.48)..lineTo(size.width * 0.4, size.height * 0.45)..lineTo(size.width * 0.6, size.height * 0.52)..lineTo(size.width * 0.8, size.height * 0.42)..lineTo(size.width, size.height * 0.4);
    canvas.drawPath(path2, p2);

    final path3 = Path()..moveTo(0, size.height * 0.62)..lineTo(size.width * 0.2, size.height * 0.6)..lineTo(size.width * 0.4, size.height * 0.58)..lineTo(size.width * 0.6, size.height * 0.65)..lineTo(size.width * 0.8, size.height * 0.55)..lineTo(size.width, size.height * 0.5);
    canvas.drawPath(path3, p3);

    final path4 = Path()..moveTo(0, size.height * 0.85)..lineTo(size.width * 0.2, size.height * 0.82)..lineTo(size.width * 0.4, size.height * 0.84)..lineTo(size.width * 0.6, size.height * 0.8)..lineTo(size.width * 0.8, size.height * 0.75)..lineTo(size.width, size.height * 0.72);
    canvas.drawPath(path4, p4);

    final path5 = Path()..moveTo(0, size.height * 0.42)..lineTo(size.width * 0.2, size.height * 0.4)..lineTo(size.width * 0.4, size.height * 0.38)..lineTo(size.width * 0.6, size.height * 0.44)..lineTo(size.width * 0.8, size.height * 0.32)..lineTo(size.width, size.height * 0.28);
    canvas.drawPath(path5, p5);

    canvas.drawCircle(Offset(size.width, size.height * 0.18), 3.5, dotPaint..color = const Color(0xFF0053DB));
    canvas.drawCircle(Offset(size.width, size.height * 0.4), 3.5, dotPaint..color = const Color(0xFF00A572));
    canvas.drawCircle(Offset(size.width, size.height * 0.5), 3.5, dotPaint..color = const Color(0xFF9333EA));
    canvas.drawCircle(Offset(size.width, size.height * 0.72), 3.5, dotPaint..color = const Color(0xFFD97706));
    canvas.drawCircle(Offset(size.width, size.height * 0.28), 3.5, dotPaint..color = const Color(0xFF0284C7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

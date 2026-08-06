import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/student_bottom_nav.dart';
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
    final isMobile = MediaQuery.of(context).size.width < 1000;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF8D90A0) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
    final tileBg = isDark ? const Color(0xFF0B1326) : const Color(0xFFF8FAFC);
    final borderCol = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? const AppSidebar(activeRoute: '/dashboard_siswa') : null,
      bottomNavigationBar: isMobile ? const StudentBottomNav(activeRoute: '/dashboard_siswa') : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(activeRoute: '/dashboard_siswa'),
          Expanded(
            child: Column(
              children: [
                if (!isMobile)
                  AppHeader(
                    onToggleSidebar: isMobile ? () => _scaffoldKey.currentState?.openDrawer() : null,
                  )
                else
                  _buildMobileHeader(context, textPrimary, textSecondary, cardBg, borderCol),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting Header
                        Text(
                          'Halo, $userName! 👋',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Semangat belajar hari ini!',
                          style: TextStyle(color: textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 10),

                        // Badges Row
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            InkWell(
                              onTap: () => _showBadgeDetailDialog(context, 'LEVEL 4 SISWA', 'Status siswa aktif dalam sistem E-ACCESS SMK Negeri 2 Balikpapan.'),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2563EB).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.4)),
                                ),
                                child: const Text(
                                  'LEVEL 4 SISWA',
                                  style: TextStyle(color: Color(0xFF2563EB), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _showBadgeDetailDialog(context, 'SMK NEGERI 2 BALIKPAPAN', 'Sekolah Menengah Kejuruan Negeri 2 Balikpapan, Kalimantan Timur.'),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: tileBg,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: borderCol),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.shield_outlined, size: 14, color: AppColors.amberWarning),
                                    const SizedBox(width: 6),
                                    Text(
                                      'SMK NEGERI 2 BALIKPAPAN',
                                      style: TextStyle(color: textPrimary, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Hero Banner Card
                        InkWell(
                          onTap: () => context.go('/cbt'),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark ? [const Color(0xFF1E293B), const Color(0xFF0F172A)] : [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2563EB).withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'UJIAN AKTIF HARI INI',
                                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Ujian Akhir Semester Ganjil',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Mata Pelajaran: Bahasa Indonesia • 90 Menit',
                                        style: TextStyle(color: Colors.white70, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () => context.go('/cbt'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF2563EB),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: const Text('Kerjakan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Quick Stat Cards
                        GridView.count(
                          crossAxisCount: isMobile ? 2 : 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildStatBox(context, 'Total CBT', '18', 'CBT Tersedia', Icons.assignment_rounded, const Color(0xFF2563EB), '/cbt', cardBg, borderCol, textPrimary, textSecondary),
                            _buildStatBox(context, 'CBT Selesai', '12', '66,7% Selesai', Icons.check_circle_rounded, const Color(0xFF00A572), '/cbt', cardBg, borderCol, textPrimary, textSecondary),
                            _buildStatBox(context, 'Belum Selesai', '6', '33,3% Belum', Icons.pending_actions_rounded, const Color(0xFFA855F7), '/cbt', cardBg, borderCol, textPrimary, textSecondary),
                            _buildStatBox(context, 'Rata-rata Nilai', '78,6', 'Dari Semua Ujian', Icons.star_rounded, const Color(0xFFFFB95F), '/grades', cardBg, borderCol, textPrimary, textSecondary),
                            _buildStatBox(context, 'Peringkat Kelas', '7', 'Dari 32 Siswa', Icons.leaderboard_rounded, const Color(0xFF38BDF8), '/grades', cardBg, borderCol, textPrimary, textSecondary),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Available CBT List & Summary
                        if (isMobile) ...[
                          _buildAvailableCbtCard(context, cardBg, borderCol, textPrimary, textSecondary),
                          const SizedBox(height: 16),
                          _buildGradeSummaryCard(context, cardBg, borderCol, textPrimary, textSecondary),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildAvailableCbtCard(context, cardBg, borderCol, textPrimary, textSecondary)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildGradeSummaryCard(context, cardBg, borderCol, textPrimary, textSecondary)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Learning Materials & Today's Schedule
                        if (isMobile) ...[
                          _buildLearningMaterialsCard(context, cardBg, borderCol, textPrimary, textSecondary),
                          const SizedBox(height: 16),
                          _buildTodayScheduleCard(context, cardBg, borderCol, textPrimary, textSecondary),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildLearningMaterialsCard(context, cardBg, borderCol, textPrimary, textSecondary)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildTodayScheduleCard(context, cardBg, borderCol, textPrimary, textSecondary)),
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

  Widget _buildMobileHeader(BuildContext context, Color textPrimary, Color textSecondary, Color cardBg, Color borderCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(bottom: BorderSide(color: borderCol)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu_rounded, color: textPrimary),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const SizedBox(width: 8),
              Text(
                'E-ACCESS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: 1),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF2563EB)),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak ada notifikasi baru'))),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, String title, String val, String sub, IconData icon, Color color, String route, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderCol),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold)),
                Icon(icon, size: 16, color: color),
              ],
            ),
            Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary)),
            Text(sub, style: TextStyle(fontSize: 9, color: textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableCbtCard(BuildContext context, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
    final list = [
      {'title': 'Ujian Akhir Semester Ganjil', 'subject': 'Bahasa Indonesia', 'time': '08:00 - 09:30', 'dur': '90 Menit', 'status': 'Kerjakan'},
      {'title': 'Ulangan Harian - Bab Teks LHO', 'subject': 'Bahasa Indonesia', 'time': '10:00 - 11:00', 'dur': '60 Menit', 'status': 'Kerjakan'},
      {'title': 'Latihan Soal Hikayat', 'subject': 'Bahasa Indonesia', 'time': '13:00 - 13:40', 'dur': '40 Menit', 'status': 'Kerjakan'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderCol)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('CBT Tersedia', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
              TextButton(onPressed: () => context.go('/cbt'), child: const Text('Lihat Semua →', style: TextStyle(color: Color(0xFF2563EB), fontSize: 11))),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: list.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0B1326) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderCol),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary)),
                          const SizedBox(height: 2),
                          Text('${item['subject']} • ${item['time']} (${item['dur']})', style: TextStyle(fontSize: 9, color: textSecondary)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go('/cbt'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                      child: Text(item['status']!, style: const TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSummaryCard(BuildContext context, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderCol)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ringkasan Nilai Saya', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
              TextButton(onPressed: () => context.go('/grades'), child: const Text('Lihat Detail →', style: TextStyle(color: Color(0xFF2563EB), fontSize: 11))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A572), width: 5)),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('78,6', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                    Text('Rata-rata', style: TextStyle(fontSize: 8, color: textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DistributionItem('Nilai ≥ 80', '5 CBT', const Color(0xFF00A572), textPrimary, textSecondary),
                    _DistributionItem('Nilai 70 - 79', '4 CBT', const Color(0xFF2563EB), textPrimary, textSecondary),
                    _DistributionItem('Nilai 60 - 69', '2 CBT', const Color(0xFFFFB95F), textPrimary, textSecondary),
                    _DistributionItem('Nilai < 60', '1 CBT', const Color(0xFFFFB4AB), textPrimary, textSecondary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLearningMaterialsCard(BuildContext context, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
    final materials = [
      {'title': 'Teks Laporan Hasil Observasi (LHO)', 'desc': 'Bahasa Indonesia • Kelas X'},
      {'title': 'Teks Anekdot & Struktur Humor', 'desc': 'Bahasa Indonesia • Kelas X'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderCol)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Materi Pembelajaran Terbaru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
              TextButton(onPressed: () => context.go('/materials'), child: const Text('Lihat Semua →', style: TextStyle(color: Color(0xFF2563EB), fontSize: 11))),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: materials.map((m) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0B1326) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderCol),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFFFB4AB), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['title']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary)),
                          Text(m['desc']!, style: TextStyle(fontSize: 9, color: textSecondary)),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.download_rounded, size: 16, color: Color(0xFF2563EB)), onPressed: () => context.go('/materials')),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayScheduleCard(BuildContext context, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
    final schedule = [
      {'time': '08:00 - 09:30', 'subject': 'Bahasa Indonesia', 'room': 'Ruang R1'},
      {'time': '10:00 - 11:30', 'subject': 'Matematika', 'room': 'Ruang R2'},
      {'time': '13:00 - 14:30', 'subject': 'Informatika', 'room': 'Lab Komputer 1'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderCol)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jadwal Hari Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
              TextButton(onPressed: () => _showFullScheduleDialog(context), child: const Text('Lihat Kalender →', style: TextStyle(color: Color(0xFF2563EB), fontSize: 11))),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: schedule.map((s) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0B1326) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderCol),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s['time']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                    Text(s['subject']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary)),
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

  void _showBadgeDetailDialog(BuildContext context, String title, String desc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text(desc, style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showFullScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jadwal Pelajaran Pekan Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Senin: Bahasa Indonesia (08:00 - 09:30)', style: TextStyle(fontSize: 12)),
            Text('• Selasa: Matematika (10:00 - 11:30)', style: TextStyle(fontSize: 12)),
            Text('• Rabu: Informatika (13:00 - 14:30)', style: TextStyle(fontSize: 12)),
            Text('• Kamis: Bahasa Inggris (08:00 - 09:30)', style: TextStyle(fontSize: 12)),
            Text('• Jumat: Pendidikan Agama (08:00 - 09:30)', style: TextStyle(fontSize: 12)),
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

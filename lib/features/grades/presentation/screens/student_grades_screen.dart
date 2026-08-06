import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/student_bottom_nav.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class StudentGradesScreen extends StatefulWidget {
  const StudentGradesScreen({super.key});

  @override
  State<StudentGradesScreen> createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeFilter = 'Semua';

  final List<Map<String, dynamic>> _grades = [
    {
      'title': 'Ujian Akhir Semester Ganjil',
      'subject': 'Bahasa Indonesia',
      'category': 'Ujian',
      'score': '90',
      'grade': 'A',
      'kkm': '75',
      'note': 'Sangat Baik, tingkatkan prestasi literasi.',
      'color': const Color(0xFF4EDEAE),
      'icon': Icons.assignment_outlined,
    },
    {
      'title': 'Ulangan Harian - Teks Anekdot',
      'subject': 'Bahasa Indonesia',
      'category': 'Penilaian Harian',
      'score': '80',
      'grade': 'B+',
      'kkm': '75',
      'note': 'Pemahaman konsep anekdot sudah baik.',
      'color': const Color(0xFF4EDEAE),
      'icon': Icons.quiz_outlined,
    },
    {
      'title': 'Latihan Soal Hikayat',
      'subject': 'Bahasa Indonesia',
      'category': 'Penilaian Harian',
      'score': '75',
      'grade': 'B',
      'kkm': '75',
      'note': 'Memenuhi batas KKM minimal.',
      'color': const Color(0xFFFFB95F),
      'icon': Icons.menu_book_rounded,
    },
    {
      'title': 'Tugas - Teks Negosiasi',
      'subject': 'Bahasa Indonesia',
      'category': 'Tugas',
      'score': '85',
      'grade': 'A-',
      'kkm': '75',
      'note': 'Penulisan naskah negosiasi runtut.',
      'color': const Color(0xFF38BDF8),
      'icon': Icons.assignment_turned_in_outlined,
    },
    {
      'title': 'Ulangan Harian - Biografi',
      'subject': 'Bahasa Indonesia',
      'category': 'Penilaian Harian',
      'score': '70',
      'grade': 'B-',
      'kkm': '75',
      'note': 'Perlu perbaikan pada analisis struktur teks.',
      'color': const Color(0xFFFFB95F),
      'icon': Icons.quiz_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isStudent = authProvider.userRole == 'Siswa' || authProvider.userRole == null;
    final isMobile = MediaQuery.of(context).size.width < 1000;
    final activeRoute = GoRouterState.of(context).matchedLocation;

    final filteredGrades = _grades.where((g) {
      if (_activeFilter == 'Semua') return true;
      return g['category'] == _activeFilter;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? AppSidebar(activeRoute: activeRoute) : null,
      bottomNavigationBar: (isMobile || isStudent) ? StudentBottomNav(activeRoute: activeRoute) : null,
      body: Row(
        children: [
          if (!isMobile) AppSidebar(activeRoute: activeRoute),
          Expanded(
            child: Column(
              children: [
                if (!isMobile)
                  AppHeader(
                    onToggleSidebar: isMobile ? () => _scaffoldKey.currentState?.openDrawer() : null,
                  )
                else
                  _buildMobileHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Chips Row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('Semua'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Ujian'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Tugas'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Penilaian Harian'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Rata-rata Nilai Card with Trend Line Chart
                        InkWell(
                          onTap: () => _showTranscriptModal(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF131B2E), Color(0xFF1A2744)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF1E293B)),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Rata-rata Nilai', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                        SizedBox(height: 2),
                                        Text('Dari Semua Ujian', style: TextStyle(fontSize: 11, color: Color(0xFF8D90A0))),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('78,6', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4EDEAE))),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF005236),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text('BAIK', style: TextStyle(color: Color(0xFF4EDEAE), fontSize: 11, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Trend Chart Custom Painter
                                SizedBox(
                                  height: 100,
                                  width: double.infinity,
                                  child: CustomPaint(
                                    painter: GradeTrendChartPainter(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Feb', style: TextStyle(fontSize: 10, color: Color(0xFF8D90A0))),
                                    Text('Mar', style: TextStyle(fontSize: 10, color: Color(0xFF8D90A0))),
                                    Text('Apr', style: TextStyle(fontSize: 10, color: Color(0xFF8D90A0))),
                                    Text('Mei', style: TextStyle(fontSize: 10, color: Color(0xFF8D90A0))),
                                    Text('Jun', style: TextStyle(fontSize: 10, color: Color(0xFF8D90A0))),
                                    Text('Jul', style: TextStyle(fontSize: 10, color: Color(0xFF8D90A0))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Section: Daftar Nilai
                        const Text('Daftar Nilai', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 12),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredGrades.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final g = filteredGrades[index];
                            return _buildGradeTile(
                              context,
                              g['title'],
                              g['subject'],
                              g['score'],
                              g['grade'],
                              g['kkm'],
                              g['note'],
                              g['color'],
                              g['icon'],
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Button Lihat Semua Nilai
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showTranscriptModal(context),
                            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                            label: const Text('Lihat Semua Nilai'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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

  Widget _buildMobileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1326),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/dashboard_siswa');
              }
            },
          ),
          const SizedBox(width: 4),
          const Text('Nilai Saya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _activeFilter == label;
    return InkWell(
      onTap: () => setState(() => _activeFilter = label),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF334155)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildGradeTile(
    BuildContext context,
    String title,
    String subject,
    String score,
    String grade,
    String kkm,
    String note,
    Color gradeColor,
    IconData icon,
  ) {
    return InkWell(
      onTap: () => _showGradeDetailDialog(context, title, subject, score, grade, kkm, note),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF93C5FD), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(subject, style: const TextStyle(fontSize: 11, color: Color(0xFF8D90A0))),
                ],
              ),
            ),
            Text(score, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: gradeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: gradeColor.withOpacity(0.4)),
              ),
              child: Text(grade, style: TextStyle(color: gradeColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Text('Filter Jenis Penilaian', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Semua', 'Ujian', 'Tugas', 'Penilaian Harian'].map((filter) {
            return RadioListTile<String>(
              title: Text(filter, style: const TextStyle(color: Colors.white, fontSize: 14)),
              value: filter,
              groupValue: _activeFilter,
              onChanged: (val) {
                if (val != null) {
                  setState(() => _activeFilter = val);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showGradeDetailDialog(BuildContext context, String title, String subject, String score, String grade, String kkm, String note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📚 Mata Pelajaran: $subject', style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 13)),
            const SizedBox(height: 6),
            Text('📊 Nilai Perolehan: $score (Predikat: $grade)', style: const TextStyle(color: Color(0xFF4EDEAE), fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('🎯 KKM Minimal: $kkm', style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 13)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Catatan Guru:', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(note, style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup', style: TextStyle(color: Color(0xFF38BDF8)))),
        ],
      ),
    );
  }

  void _showTranscriptModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131B2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transkrip Nilai Akademik Siswa', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Semester Ganjil TA 2026/2027', style: TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
            const SizedBox(height: 16),
            _buildTranscriptRow('Bahasa Indonesia', '83,4', 'A-'),
            const Divider(color: Color(0xFF1E293B)),
            _buildTranscriptRow('Informatika', '88,0', 'A'),
            const Divider(color: Color(0xFF1E293B)),
            _buildTranscriptRow('Matematika', '79,2', 'B+'),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscriptRow(String subject, String score, String grade) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(subject, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        Row(
          children: [
            Text(score, style: const TextStyle(color: Color(0xFF4EDEAE), fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(6)),
              child: Text(grade, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}

class GradeTrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4EDEAE)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = const Color(0xFF4EDEAE)
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.65),
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.15),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final x1 = points[i].dx;
      final y1 = points[i].dy;
      final x2 = points[i + 1].dx;
      final y2 = points[i + 1].dy;
      final cx1 = x1 + (x2 - x1) / 2;
      final cx2 = x1 + (x2 - x1) / 2;
      path.cubicTo(cx1, y1, cx2, y2, x2, y2);
    }

    canvas.drawPath(path, paint);

    for (var point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

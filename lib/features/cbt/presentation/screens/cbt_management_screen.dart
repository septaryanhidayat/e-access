import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/student_bottom_nav.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CbtManagementScreen extends StatefulWidget {
  const CbtManagementScreen({super.key});

  @override
  State<CbtManagementScreen> createState() => _CbtManagementScreenState();
}

class _CbtManagementScreenState extends State<CbtManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeFilter = 'Semua';

  final List<Map<String, dynamic>> _cbtExams = [
    {
      'id': 'exam_1',
      'title': 'Ujian Akhir Semester Ganjil',
      'subject': 'Bahasa Indonesia • Kelas X TKJ 1',
      'date': '27 Jul 2026',
      'time': '08:00 - 09:30 WIB',
      'duration': '90 Menit',
      'questions': '40 Soal',
      'status': 'Aktif',
      'token': 'TOKEN: BPN-2026-X1',
    },
    {
      'id': 'exam_2',
      'title': 'Ulangan Harian - Bab Teks LHO',
      'subject': 'Bahasa Indonesia • Kelas X TKJ 2',
      'date': '28 Jul 2026',
      'time': '10:00 - 11:00 WIB',
      'duration': '60 Menit',
      'questions': '25 Soal',
      'status': 'Terjadwal',
      'token': 'TOKEN: BPN-2026-X2',
    },
    {
      'id': 'exam_3',
      'title': 'Latihan Soal Hikayat & Melayu Klasik',
      'subject': 'Bahasa Indonesia • Kelas XI RPL 1',
      'date': '25 Jul 2026',
      'time': '13:00 - 13:40 WIB',
      'duration': '40 Menit',
      'questions': '20 Soal',
      'status': 'Selesai',
      'token': 'TOKEN: BPN-2026-R1',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final role = authProvider.userRole ?? 'Siswa';
    final isTeacherOrAdmin = role == 'Guru' || role == 'Admin' || role == 'Super Admin';
    final isStudent = role == 'Siswa';
    final isMobile = MediaQuery.of(context).size.width < 1000;
    final activeRoute = GoRouterState.of(context).matchedLocation;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredExams = _cbtExams.where((e) {
      if (_activeFilter == 'Semua') return true;
      return e['status'] == _activeFilter;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? AppSidebar(activeRoute: activeRoute) : null,
      bottomNavigationBar: (isMobile || isStudent) ? StudentBottomNav(activeRoute: activeRoute) : null,
      floatingActionButton: isTeacherOrAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showCreateCbtModal(context),
              backgroundColor: const Color(0xFF2563EB),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('Buat CBT Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Banner
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Assessment & CBT Ujian Digital', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                                const SizedBox(height: 4),
                                Text('Kelola ujian online, jadwal kuis, token ujian, serta analisis hasil siswa.', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, fontSize: 12)),
                              ],
                            ),
                            if (isTeacherOrAdmin)
                              ElevatedButton.icon(
                                onPressed: () => _showCreateCbtModal(context),
                                icon: const Icon(Icons.note_add_rounded, size: 18),
                                label: const Text('Buat CBT Baru'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Filter Chips Row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('Semua'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Aktif'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Terjadwal'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Selesai'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Exam List
                        if (filteredExams.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Text('Tidak ada jadwal ujian CBT di kategori ini.'),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredExams.length,
                            separatorBuilder: (_, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final exam = filteredExams[index];
                              return _buildExamCard(context, exam, isTeacherOrAdmin, isDark);
                            },
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

  Widget _buildMobileHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
                const SizedBox(width: 8),
                const Text('Daftar CBT Ujian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.note_add_rounded, color: Color(0xFF2563EB)),
              onPressed: () => _showCreateCbtModal(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _activeFilter == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      onSelected: (val) {
        setState(() => _activeFilter = label);
      },
    );
  }

  Widget _buildExamCard(BuildContext context, Map<String, dynamic> exam, bool isTeacherOrAdmin, bool isDark) {
    final title = exam['title'] as String;
    final subject = exam['subject'] as String;
    final date = exam['date'] as String;
    final time = exam['time'] as String;
    final duration = exam['duration'] as String;
    final questions = exam['questions'] as String;
    final status = exam['status'] as String;
    final token = exam['token'] as String;

    Color statusColor = const Color(0xFF2563EB);
    if (status == 'Aktif') statusColor = const Color(0xFF10B981);
    if (status == 'Terjadwal') statusColor = const Color(0xFFD97706);
    if (status == 'Selesai') statusColor = const Color(0xFF9333EA);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Text(token, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, fontWeight: FontWeight.bold)),
                ],
              ),
              if (isTeacherOrAdmin)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                  onPressed: () => _confirmDeleteExam(context, exam['id']),
                  tooltip: 'Hapus CBT',
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A))),
          const SizedBox(height: 2),
          Text(subject, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: statusColor),
              const SizedBox(width: 4),
              Text('$date ($time)', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : const Color(0xFF475569))),
              const SizedBox(width: 14),
              Icon(Icons.timer_rounded, size: 14, color: statusColor),
              const SizedBox(width: 4),
              Text('$duration • $questions', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : const Color(0xFF475569))),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (status == 'Aktif')
                ElevatedButton.icon(
                  onPressed: () => context.go('/cbt_exam/${exam['id']}'),
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: const Text('Mulai Ujian Sekarang'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                )
              else if (status == 'Terjadwal')
                OutlinedButton.icon(
                  onPressed: () => _showTokenInfoDialog(context, title, token),
                  icon: const Icon(Icons.key_rounded, size: 16),
                  label: const Text('Lihat Token Ujian'),
                )
              else
                ElevatedButton.icon(
                  onPressed: () => _showCbtResultDialog(context, title, subject, '88', 'Tuntas 100%'),
                  icon: const Icon(Icons.bar_chart_rounded, size: 16),
                  label: const Text('Lihat Hasil Ujian'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateCbtModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final durationCtrl = TextEditingController(text: '60');
    final questionsCtrl = TextEditingController(text: '30');
    String status = 'Aktif';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Buat Jadwal CBT Ujian Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
              const SizedBox(height: 14),
              TextFormField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Judul Ujian CBT (misal: Ujian Akhir Semester)')),
              const SizedBox(height: 10),
              TextFormField(controller: subjectCtrl, decoration: const InputDecoration(labelText: 'Mata Pelajaran & Kelas Target')),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: durationCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Durasi (Menit)'))),
                  const SizedBox(width: 10),
                  Expanded(child: TextFormField(controller: questionsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah Soal'))),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: status,
                items: ['Aktif', 'Terjadwal', 'Selesai'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setModalState(() => status = val!),
                decoration: const InputDecoration(labelText: 'Status Ujian'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (titleCtrl.text.trim().isEmpty) return;

                    final now = DateTime.now();
                    final randomToken = 'TOKEN: BPN-${now.millisecond}-X';

                    setState(() {
                      _cbtExams.insert(0, {
                        'id': 'exam_${now.millisecondsSinceEpoch}',
                        'title': titleCtrl.text.trim(),
                        'subject': subjectCtrl.text.trim().isEmpty ? 'Bahasa Indonesia • Kelas X' : subjectCtrl.text.trim(),
                        'date': 'Hari Ini',
                        'time': '08:00 WIB',
                        'duration': '${durationCtrl.text.trim()} Menit',
                        'questions': '${questionsCtrl.text.trim()} Soal',
                        'status': status,
                        'token': randomToken,
                      });
                    });

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Berhasil merilis CBT "${titleCtrl.text.trim()}" ($randomToken)!')),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('SIMPAN & RILIS CBT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteExam(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Ujian CBT?'),
        content: const Text('Apakah Anda yakin ingin menghapus jadwal ujian CBT ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _cbtExams.removeWhere((e) => e['id'] == id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jadwal CBT dihapus.')));
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showTokenInfoDialog(BuildContext context, String title, String token) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Token Ujian: $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Berikan token ini kepada siswa saat ujian dimulai:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF2563EB).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Text(token, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showCbtResultDialog(BuildContext context, String title, String subject, String score, String detail) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hasil CBT: $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF10B981), width: 4)),
              alignment: Alignment.center,
              child: Text(score, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
            ),
            const SizedBox(height: 12),
            Text(subject, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(detail, style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }
}

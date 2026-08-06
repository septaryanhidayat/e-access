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

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isStudent = authProvider.userRole == 'Siswa' || authProvider.userRole == null;
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? const AppSidebar(activeRoute: '/cbt') : null,
      bottomNavigationBar: (isMobile || isStudent) ? const StudentBottomNav(activeRoute: '/cbt') : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(activeRoute: '/cbt'),
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
                              _buildFilterChip('Aktif'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Terjadwal'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Selesai'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 1: CBT Aktif (Sedang Berjalan)
                        if (_activeFilter == 'Semua' || _activeFilter == 'Aktif') ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('CBT Aktif (Sedang Berjalan)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              TextButton(
                                onPressed: () => setState(() => _activeFilter = 'Aktif'),
                                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFFB4C5FF), fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildCbtAktifCard(
                            context,
                            'Ujian Akhir Semester Ganjil',
                            'Bahasa Indonesia',
                            '27 Jul 2026',
                            '08:00 - 09:30',
                            '90 Menit',
                            '32 Soal',
                            '01:29:45',
                            'demo_1',
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Section 2: CBT Terjadwal
                        if (_activeFilter == 'Semua' || _activeFilter == 'Terjadwal') ...[
                          const Text('CBT Terjadwal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 8),
                          _buildCbtTerjadwalCard(
                            context,
                            'Ulangan Harian - Teks Anekdot',
                            'Bahasa Indonesia',
                            '28 Jul 2026',
                            '10:00 - 11:00',
                            '25 Soal',
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Section 3: CBT Selesai
                        if (_activeFilter == 'Semua' || _activeFilter == 'Selesai') ...[
                          const Text('CBT Selesai', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 8),
                          _buildCbtSelesaiCard(
                            context,
                            'Latihan Soal Hikayat',
                            'Bahasa Indonesia',
                            '25 Jul 2026',
                            '13:00 - 13:40',
                            '20 Soal',
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Section 4: Riwayat CBT
                        if (_activeFilter == 'Semua') ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Riwayat CBT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              TextButton(
                                onPressed: () => _showHistoryModal(context),
                                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFFB4C5FF), fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildHistoryItem(context, 'Latihan Teks Negosiasi', '22 Jul 2026', '85', isPassed: true),
                          const SizedBox(height: 8),
                          _buildHistoryItem(context, 'Latihan Biografi', '21 Jul 2026', '78', isPassed: false),
                          const SizedBox(height: 20),
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
          const Text(
            'Daftar CBT',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
            onPressed: () => _showFilterOptionsDialog(context),
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
          color: isSelected ? const Color(0xFF93C5FD) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF93C5FD) : const Color(0xFF334155)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCbtAktifCard(
    BuildContext context,
    String title,
    String subject,
    String date,
    String time,
    String duration,
    String questions,
    String timeLeft,
    String examId,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A572).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF4EDEAE)),
                ),
                child: const Text('AKTIF', style: TextStyle(color: Color(0xFF4EDEAE), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subject, style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildInfoBadge(Icons.calendar_today_rounded, date),
              _buildInfoBadge(Icons.access_time_rounded, time),
              _buildInfoBadge(Icons.timer_outlined, duration),
              _buildInfoBadge(Icons.article_outlined, questions),
            ],
          ),
          const Divider(height: 24, color: Color(0xFF1E293B)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SISA WAKTU', style: TextStyle(fontSize: 9, color: Color(0xFF8D90A0), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(timeLeft, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4EDEAE))),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => context.push('/cbt_exam/$examId'),
                icon: const Icon(Icons.play_arrow_rounded, size: 18),
                label: const Text('Mulai Ujian'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB4C5FF),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCbtTerjadwalCard(BuildContext context, String title, String subject, String date, String time, String questions) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB95F).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFB95F)),
                ),
                child: const Text('TERJADWAL', style: TextStyle(color: Color(0xFFFFB95F), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subject, style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildInfoBadge(Icons.calendar_today_rounded, date),
              _buildInfoBadge(Icons.access_time_rounded, time),
              _buildInfoBadge(Icons.article_outlined, questions),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showCbtDetailDialog(context, title, subject, date, time, questions, 'TOKEN: CBT-8890'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF334155)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Lihat Detail'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCbtSelesaiCard(BuildContext context, String title, String subject, String date, String time, String questions) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF005236).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF00A572)),
                ),
                child: const Text('SELESAI', style: TextStyle(color: Color(0xFF4EDEAE), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subject, style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildInfoBadge(Icons.calendar_today_rounded, date),
              _buildInfoBadge(Icons.access_time_rounded, time),
              _buildInfoBadge(Icons.article_outlined, questions),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCbtResultDialog(context, title, subject, '88 / 100', '18 Benar, 2 Salah'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Lihat Hasil'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, String title, String date, String score, {required bool isPassed}) {
    return InkWell(
      onTap: () => _showCbtResultDialog(context, title, 'Bahasa Indonesia', '$score / 100', isPassed ? 'Lulus KKM' : 'Remidi'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
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
              child: const Icon(Icons.assignment_outlined, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF8D90A0))),
                ],
              ),
            ),
            Text(
              'Skor: $score',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4EDEAE)),
            ),
            const SizedBox(width: 8),
            Icon(
              isPassed ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
              color: isPassed ? const Color(0xFF4EDEAE) : const Color(0xFFFFB95F),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF8D90A0)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF8D90A0))),
      ],
    );
  }

  void _showFilterOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Text('Filter Kategori CBT', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Semua', 'Aktif', 'Terjadwal', 'Selesai'].map((filter) {
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

  void _showCbtDetailDialog(BuildContext context, String title, String subject, String date, String time, String questions, String token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📚 Mata Pelajaran: $subject', style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
            const SizedBox(height: 6),
            Text('📅 Tanggal: $date ($time)', style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
            const SizedBox(height: 6),
            Text('📝 Jumlah Soal: $questions', style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
              child: Text(token, style: const TextStyle(color: Color(0xFF4EDEAE), fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup', style: TextStyle(color: Color(0xFF38BDF8)))),
        ],
      ),
    );
  }

  void _showCbtResultDialog(BuildContext context, String title, String subject, String score, String detail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: Text('Hasil CBT: $title', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4EDEAE), width: 4),
              ),
              alignment: Alignment.center,
              child: Text(score, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            Text(subject, style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 13)),
            const SizedBox(height: 4),
            Text(detail, style: const TextStyle(color: Color(0xFF4EDEAE), fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup', style: TextStyle(color: Color(0xFF38BDF8)))),
        ],
      ),
    );
  }

  void _showHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131B2E),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Riwayat Ujian CBT Lengkap', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildHistoryItem(context, 'Latihan Teks Negosiasi', '22 Jul 2026', '85', isPassed: true),
            const SizedBox(height: 8),
            _buildHistoryItem(context, 'Latihan Biografi', '21 Jul 2026', '78', isPassed: false),
            const SizedBox(height: 8),
            _buildHistoryItem(context, 'Kuis Teks Eksplanasi', '15 Jul 2026', '92', isPassed: true),
          ],
        ),
      ),
    );
  }
}

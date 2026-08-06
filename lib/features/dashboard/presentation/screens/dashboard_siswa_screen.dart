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
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
    final tileBg = isDark ? const Color(0xFF0B1326) : const Color(0xFFF8FAFC);
    final borderCol = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? const Color(0xFF070D1B) : const Color(0xFFF1F5F9),
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
                  _buildReferenceMobileHeader(context, userName, textPrimary, textSecondary),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting Header
                        Text(
                          'Halo, $userName! 👋',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Semangat belajar hari ini!',
                          style: TextStyle(color: textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 12),

                        // Badges Row
                        Row(
                          children: [
                            _buildPillBadge(
                              context,
                              'LEVEL 4 SISWA',
                              const Color(0xFF2563EB),
                              onTap: () => _showBadgeDetailDialog(context, 'LEVEL 4 SISWA', 'Status siswa aktif dalam sistem E-ACCESS SMK Negeri 2 Balikpapan.'),
                            ),
                            const SizedBox(width: 8),
                            _buildPillBadgeWithIcon(
                              context,
                              'SMK NEGERI 2 BALIKPAPAN',
                              Icons.shield_outlined,
                              const Color(0xFFFFB95F),
                              tileBg,
                              borderCol,
                              textPrimary,
                              onTap: () => _showBadgeDetailDialog(context, 'SMK NEGERI 2 BALIKPAPAN', 'Sekolah Menengah Kejuruan Negeri 2 Balikpapan, Kalimantan Timur.'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Hero Banner Card (Reference Design)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [const Color(0xFF192238), const Color(0xFF10172A)]
                                  : [const Color(0xFF2563EB), const Color(0xFF1E40AF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: isDark ? const Color(0xFF2B3654) : const Color(0xFF3B82F6)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Belajar · Ujian · Nilai ·\nPrestasi',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Semua dalam satu genggaman',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.touch_app_rounded, size: 40, color: Color(0xFF00F0FF)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Section: Ringkasan Aktivitas Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ringkasan Aktivitas',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                            ),
                            TextButton(
                              onPressed: () => context.go('/cbt'),
                              child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Grid 3x2 (6 Stat Tiles Reference)
                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.05,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildRefStatTile(context, '18', 'TOTAL CBT\nTERSEDIA', Icons.assignment_outlined, const Color(0xFF38BDF8), '/cbt', cardBg, borderCol, textPrimary, textSecondary),
                            _buildRefStatTile(context, '12', 'CBT\nSELESAI', Icons.check_circle_outline_rounded, const Color(0xFF4EDEAE), '/cbt', cardBg, borderCol, textPrimary, textSecondary),
                            _buildRefStatTile(context, '78,6', 'RATA-RATA\nNILAI', Icons.star_outline_rounded, const Color(0xFFFFB95F), '/grades', cardBg, borderCol, textPrimary, textSecondary),
                            _buildRefStatTile(context, '92,4%', 'PRESENSI\nHADIR', Icons.person_search_outlined, const Color(0xFF4EDEAE), '/attendance', cardBg, borderCol, textPrimary, textSecondary),
                            _buildRefStatTile(context, '7', 'PERINGKAT\nDARI 32', Icons.emoji_events_outlined, const Color(0xFF9333EA), '/grades', cardBg, borderCol, textPrimary, textSecondary),
                            _buildRefStatTile(context, '24', 'MATERI\nDIPELAJARI', Icons.menu_book_outlined, const Color(0xFF38BDF8), '/materials', cardBg, borderCol, textPrimary, textSecondary),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section: Jadwal Hari Ini Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Jadwal Hari Ini',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                            ),
                            TextButton(
                              onPressed: () => _showFullScheduleDialog(context),
                              child: const Text('Lihat Jadwal', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Schedule Cards (Reference Vertical Indicator Style)
                        _buildRefScheduleItem('08:00 - 09:30', 'Bahasa Indonesia', 'X TKJ 1', const Color(0xFF2563EB), cardBg, borderCol, textPrimary, textSecondary),
                        const SizedBox(height: 10),
                        _buildRefScheduleItem('10:00 - 11:30', 'Informatika', 'X TKJ 1', const Color(0xFFFFB95F), cardBg, borderCol, textPrimary, textSecondary),
                        const SizedBox(height: 10),
                        _buildRefScheduleItem('13:00 - 14:30', 'Matematika', 'X TKJ 1', const Color(0xFF4EDEAE), cardBg, borderCol, textPrimary, textSecondary),
                        const SizedBox(height: 24),

                        // Section: Pengumuman Terbaru Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pengumuman Terbaru',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                            ),
                            TextButton(
                              onPressed: () => _showAllAnnouncementsModal(context),
                              child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Announcement Card Reference Style
                        _buildRefAnnouncementCard(context, 'Pengumpulan Tugas PKK', 'Batas akhir 31 Juli 2026', '26', 'JUL', cardBg, borderCol, textPrimary, textSecondary),
                        const SizedBox(height: 30),

                        Center(
                          child: Text(
                            '© 2026 E-ACCESS - Electronic Assessment & Classroom System. All rights reserved.',
                            style: TextStyle(color: textSecondary, fontSize: 11),
                          ),
                        ),
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

  Widget _buildReferenceMobileHeader(BuildContext context, String userName, Color textPrimary, Color textSecondary) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            InkWell(
              onTap: () => context.go('/profile'),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF2563EB),
                child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'E-ACCESS',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: 1),
                  ),
                  Text(
                    'Electronic Assessment System',
                    style: TextStyle(fontSize: 10, color: textSecondary),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF38BDF8), size: 24),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak ada notifikasi baru'))),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillBadge(BuildContext context, String title, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(
          title,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _buildPillBadgeWithIcon(BuildContext context, String title, IconData icon, Color iconColor, Color tileBg, Color borderCol, Color textPrimary, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
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
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(color: textPrimary, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefStatTile(BuildContext context, String value, String label, IconData icon, Color accentColor, String route, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderCol),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 16),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 8, color: textSecondary, fontWeight: FontWeight.bold, height: 1.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefScheduleItem(String time, String subject, String className, Color barColor, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderCol),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 34,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: TextStyle(fontSize: 11, color: textSecondary)),
                const SizedBox(height: 2),
                Text(subject, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: borderCol,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              className,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefAnnouncementCard(BuildContext context, String title, String subtitle, String day, String month, Color cardBg, Color borderCol, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderCol),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF38BDF8).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.campaign_outlined, color: Color(0xFF38BDF8), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: borderCol,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(day, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
                Text(month, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary)),
              ],
            ),
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
            SizedBox(height: 4),
            Text('• Selasa: Informatika (10:00 - 11:30)', style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            Text('• Rabu: Matematika (13:00 - 14:30)', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showAllAnnouncementsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengumuman Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Pengumpulan Tugas PKK (Batas akhir 31 Juli 2026)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('2. Ujian Akhir Semester Ganjil (1-7 Agustus 2026)', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }
}

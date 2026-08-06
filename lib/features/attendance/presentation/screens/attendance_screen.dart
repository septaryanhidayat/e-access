import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/student_bottom_nav.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _activeTab = 0; // 0: Ringkasan, 1: Riwayat
  String? _selectedFilterStatus;

  final List<Map<String, dynamic>> _attendanceHistory = [
    {
      'dayNum': '26',
      'month': 'JUL',
      'dayName': 'Minggu',
      'subtitle': 'Waktu: 07:30 WIB',
      'status': 'HADIR',
      'color': const Color(0xFF4EDEAE),
      'icon': Icons.check_circle_outline_rounded,
      'location': 'SMK Negeri 2 Balikpapan (GPS Verified)',
      'method': 'Scan QR Code Digital',
    },
    {
      'dayNum': '25',
      'month': 'JUL',
      'dayName': 'Sabtu',
      'subtitle': 'Keterangan: Acara Keluarga',
      'status': 'IJIN',
      'color': const Color(0xFFFFB95F),
      'icon': Icons.star_outline_rounded,
      'location': 'Surat Izin Orang Tua',
      'method': 'Unggah Surat Keterangan',
    },
    {
      'dayNum': '24',
      'month': 'JUL',
      'dayName': 'Jumat',
      'subtitle': 'Keterangan: Demam',
      'status': 'SAKIT',
      'color': const Color(0xFFB4C5FF),
      'icon': Icons.person_outline_rounded,
      'location': 'Surat Dokter / Puskesmas',
      'method': 'Surat Keterangan Sakit',
    },
    {
      'dayNum': '23',
      'month': 'JUL',
      'dayName': 'Kamis',
      'subtitle': 'Waktu: 07:12 WIB',
      'status': 'HADIR',
      'color': const Color(0xFF4EDEAE),
      'icon': Icons.check_circle_outline_rounded,
      'location': 'SMK Negeri 2 Balikpapan (GPS Verified)',
      'method': 'Scan QR Code Digital',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isStudent = authProvider.userRole == 'Siswa' || authProvider.userRole == null;
    final isMobile = MediaQuery.of(context).size.width < 1000;
    final activeRoute = GoRouterState.of(context).matchedLocation;

    final filteredHistory = _attendanceHistory.where((h) {
      if (_selectedFilterStatus == null) return true;
      return h['status'] == _selectedFilterStatus;
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
                        // Tab Bar Toggle
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF131B2E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF1E293B)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() {
                                    _activeTab = 0;
                                    _selectedFilterStatus = null;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _activeTab == 0 ? const Color(0xFFB4C5FF) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Ringkasan',
                                      style: TextStyle(
                                        color: _activeTab == 0 ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() => _activeTab = 1),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _activeTab == 1 ? const Color(0xFFB4C5FF) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Riwayat',
                                      style: TextStyle(
                                        color: _activeTab == 1 ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (_activeTab == 0) ...[
                          // Section 1: Ringkasan Presensi Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF131B2E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF1E293B)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Ringkasan Presensi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 2),
                                const Text('Bulan Juli 2026', style: TextStyle(fontSize: 11, color: Color(0xFF8D90A0))),
                                const SizedBox(height: 16),

                                // Donut Chart
                                Center(
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF4EDEAE), width: 8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('92,4%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                        Text('HADIR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF4EDEAE), letterSpacing: 1)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Legend Grid 2x2
                                GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2.5,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    _buildLegendTile(context, 'Hadir', '138 (92.4%)', const Color(0xFF4EDEAE), 'HADIR'),
                                    _buildLegendTile(context, 'Ijin', '6 (4.0%)', const Color(0xFFFFB95F), 'IJIN'),
                                    _buildLegendTile(context, 'Sakit', '4 (2.7%)', const Color(0xFFB4C5FF), 'SAKIT'),
                                    _buildLegendTile(context, 'Alpa', '2 (1.3%)', const Color(0xFFFFB4AB), 'ALPA'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Section 2: 4 Quick Stat Cards
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.6,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildStatCard(context, '138 Hari', 'Hadir', Icons.check_circle_outline_rounded, const Color(0xFF4EDEAE), 'HADIR'),
                              _buildStatCard(context, '6 Hari', 'Ijin', Icons.star_outline_rounded, const Color(0xFFFFB95F), 'IJIN'),
                              _buildStatCard(context, '4 Hari', 'Sakit', Icons.person_outline_rounded, const Color(0xFFB4C5FF), 'SAKIT'),
                              _buildStatCard(context, '2 Hari', 'Alpa', Icons.warning_amber_rounded, const Color(0xFFFFB4AB), 'ALPA'),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Section 3: Riwayat Presensi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedFilterStatus == null ? 'Riwayat Presensi' : 'Riwayat $_selectedFilterStatus',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            if (_selectedFilterStatus != null)
                              TextButton(
                                onPressed: () => setState(() => _selectedFilterStatus = null),
                                child: const Text('Reset Filter', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredHistory.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = filteredHistory[index];
                            return _buildRiwayatTile(
                              context,
                              item['dayNum'],
                              item['month'],
                              item['dayName'],
                              item['subtitle'],
                              item['status'],
                              item['color'],
                              item['icon'],
                              item['location'],
                              item['method'],
                            );
                          },
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
          const Text('Presensi Saya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLegendTile(BuildContext context, String title, String subtitle, Color color, String filterStatus) {
    return InkWell(
      onTap: () => setState(() {
        _activeTab = 1;
        _selectedFilterStatus = filterStatus;
      }),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1326),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 4, backgroundColor: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF8D90A0))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String count, String label, IconData icon, Color color, String filterStatus) {
    return InkWell(
      onTap: () => setState(() {
        _activeTab = 1;
        _selectedFilterStatus = filterStatus;
      }),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 6),
            Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF8D90A0))),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatTile(
    BuildContext context,
    String dayNum,
    String month,
    String dayName,
    String subtitle,
    String status,
    Color statusColor,
    IconData icon,
    String location,
    String method,
  ) {
    return InkWell(
      onTap: () => _showAttendanceDetailDialog(context, dayName, '$dayNum $month 2026', status, subtitle, location, method),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(dayNum, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(month, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF8D90A0))),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dayName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF8D90A0))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 14, color: statusColor),
                  const SizedBox(width: 4),
                  Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceDetailDialog(BuildContext context, String dayName, String date, String status, String note, String location, String method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: Text('Detail Presensi - $dayName', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📅 Tanggal: $date', style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 13)),
            const SizedBox(height: 6),
            Text('📌 Status: $status', style: const TextStyle(color: Color(0xFF4EDEAE), fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('📝 $note', style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 13)),
            const SizedBox(height: 6),
            Text('📍 Lokasi: $location', style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 13)),
            const SizedBox(height: 6),
            Text('🔑 Metode: $method', style: const TextStyle(color: Color(0xFF8D90A0), fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup', style: TextStyle(color: Color(0xFF38BDF8)))),
        ],
      ),
    );
  }
}

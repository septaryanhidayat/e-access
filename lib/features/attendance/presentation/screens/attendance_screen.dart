import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> _attendanceLogs = [
    {'name': 'Andi Pratama', 'class': 'X TKJ 1', 'time': '07:15:22', 'status': 'Hadir', 'type': 'QR Code'},
    {'name': 'Siti Aminah', 'class': 'X TKJ 1', 'time': '07:20:10', 'status': 'Hadir', 'type': 'Manual'},
    {'name': 'Rudi Hermawan', 'class': 'XI RPL 1', 'time': '08:05:44', 'status': 'Izin', 'type': 'Surat Izin'},
    {'name': 'Bambang Prasetyo', 'class': 'X TKJ 2', 'time': '-', 'status': 'Alpa', 'type': 'Sistem'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? const AppSidebar(activeRoute: '/attendance') : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(activeRoute: '/attendance'),
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
                                  'E-Presensi & Rekap Kehadiran',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Monitoring kehadiran siswa real-time, presensi QR Code, dan ekspor rekapitulasi.',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Presensi QR Code Dibuka.')));
                              },
                              icon: const Icon(Icons.qr_code_scanner_rounded),
                              label: const Text('Buka Sesi Presensi'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        CustomCard(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _attendanceLogs.length,
                            separatorBuilder: (_, index) => const Divider(height: 16),
                            itemBuilder: (context, index) {
                              final item = _attendanceLogs[index];
                              return Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: item['status'] == 'Hadir' ? AppColors.success.withAlpha(25) : AppColors.error.withAlpha(25),
                                    child: Icon(
                                      item['status'] == 'Hadir' ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                      color: item['status'] == 'Hadir' ? AppColors.success : AppColors.error,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        Text('Kelas: ${item['class']} • Jam Masuk: ${item['time']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                                      ],
                                    ),
                                  ),
                                  StatusChip(status: item['status']!, fontSize: 10),
                                ],
                              );
                            },
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
}

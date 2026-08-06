import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';

class CbtManagementScreen extends StatefulWidget {
  const CbtManagementScreen({super.key});

  @override
  State<CbtManagementScreen> createState() => _CbtManagementScreenState();
}

class _CbtManagementScreenState extends State<CbtManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> _cbtList = [
    {'title': 'Ujian Akhir Semester Ganjil', 'class': 'X TKJ 1', 'duration': '90 Menit', 'status': 'Selesai', 'submitted': '32/32'},
    {'title': 'Ulangan Harian - Bab Teks LHO', 'class': 'X TKJ 2', 'duration': '60 Menit', 'status': 'Berlangsung', 'submitted': '18/30'},
    {'title': 'Latihan Soal Hikayat', 'class': 'XI RPL 1', 'duration': '40 Menit', 'status': 'Dijadwalkan', 'submitted': '0/28'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? const AppSidebar(activeRoute: '/manage_cbt') : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(activeRoute: '/manage_cbt'),
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
                                  'Kelola CBT & Bank Soal',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Buat ujian baru, atur durasi & token, import soal dari Word/Excel, dan ekspor nilai.',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _showCreateCbtDialog(context),
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Buat CBT Baru'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        CustomCard(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _cbtList.length,
                            separatorBuilder: (_, index) => const Divider(height: 16),
                            itemBuilder: (context, index) {
                              final item = _cbtList[index];
                              return Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.electricBlue.withAlpha(25),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.assignment_rounded, color: AppColors.electricCyan, size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        Text('Kelas: ${item['class']} • Durasi: ${item['duration']} • Terkumpul: ${item['submitted']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                                      ],
                                    ),
                                  ),
                                  StatusChip(status: item['status']!, fontSize: 10),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.play_arrow_rounded, color: AppColors.success),
                                    onPressed: () => context.push('/cbt_exam/demo_1'),
                                    tooltip: 'Simulasi Kerjakan',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.file_download_rounded, color: AppColors.siswaBlue),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mengunduh Nilai Excel untuk ${item['title']}...')));
                                    },
                                    tooltip: 'Export Nilai Excel',
                                  ),
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

  void _showCreateCbtDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundCardDark : AppColors.backgroundCardLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buat CBT Ujian Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.electricCyan)),
            const SizedBox(height: 14),
            TextFormField(decoration: const InputDecoration(labelText: 'Judul Ujian / CBT')),
            const SizedBox(height: 10),
            TextFormField(decoration: const InputDecoration(labelText: 'Durasi Ujian (Menit)')),
            const SizedBox(height: 10),
            TextFormField(decoration: const InputDecoration(labelText: 'Token Akses (Opsional)')),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CBT Berhasil Diterbitkan!')));
                },
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('TERBITKAN CBT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

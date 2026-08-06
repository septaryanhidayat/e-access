import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';

class AcademicScreen extends StatefulWidget {
  const AcademicScreen({super.key});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _rombelList = [
    {'name': 'X TKJ 1', 'wali': 'Ahmad Fauzi, S.T.', 'students': 32, 'major': 'Teknik Komputer & Jaringan'},
    {'name': 'X TKJ 2', 'wali': 'Dewi Lestari, S.Pd.', 'students': 30, 'major': 'Teknik Komputer & Jaringan'},
    {'name': 'XI RPL 1', 'wali': 'Budi Santoso, S.Pd.', 'students': 28, 'major': 'Rekayasa Perangkat Lunak'},
    {'name': 'X Bahasa 1', 'wali': 'Siti Rahma, M.Pd.', 'students': 29, 'major': 'Bahasa & Sastra'},
  ];

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
                                  'Data Akademik & Rombel',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Pengaturan Kelas, Pembagian Wali Kelas, dan Mata Pelajaran.',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Form Rombel Baru dibuka.')));
                              },
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Tambah Rombel'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 1 : 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 2.2,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _rombelList.length,
                          itemBuilder: (context, index) {
                            final r = _rombelList[index];
                            return CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(r['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.electricCyan)),
                                      StatusChip(status: '${r['students']} Siswa', fontSize: 10),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Jurusan: ${r['major']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                                  const SizedBox(height: 4),
                                  Text('Wali Kelas: ${r['wali']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_rounded, size: 14), label: const Text('Edit')),
                                      TextButton.icon(onPressed: () {}, icon: const Icon(Icons.schedule_rounded, size: 14), label: const Text('Jadwal')),
                                    ],
                                  ),
                                ],
                              ),
                            );
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
}

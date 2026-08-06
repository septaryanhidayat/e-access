import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? const AppSidebar(activeRoute: '/settings') : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(activeRoute: '/settings'),
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
                        const Text(
                          'Pengaturan Sistem & Database',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Identitas Sekolah, Logo Kop Surat, Backup Database, dan Sinkronisasi.',
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 20),

                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Identitas Sekolah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.electricCyan)),
                              const SizedBox(height: 12),
                              TextFormField(initialValue: 'SMK NEGERI 2 BALIKPAPAN', decoration: const InputDecoration(labelText: 'Nama Sekolah')),
                              const SizedBox(height: 10),
                              TextFormField(initialValue: 'Jl. Soekarno Hatta Km. 2, Balikpapan', decoration: const InputDecoration(labelText: 'Alamat Sekolah')),
                              const SizedBox(height: 10),
                              TextFormField(initialValue: '2026/2027 - Ganjil', decoration: const InputDecoration(labelText: 'Tahun Ajaran & Semester')),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengaturan Sekolah Diperbarui!')));
                                },
                                icon: const Icon(Icons.save_rounded),
                                label: const Text('Simpan Pengaturan'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Backup & Restore Database', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.electricCyan)),
                              const SizedBox(height: 8),
                              const Text('Buat cadangan database Supabase secara otomatis atau unduh file SQL dump.', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup Database Berhasil Dibuat (48.6 GB)!')));
                                    },
                                    icon: const Icon(Icons.cloud_download_rounded),
                                    label: const Text('Backup Sekarang'),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restore Database Siap.')));
                                    },
                                    icon: const Icon(Icons.restore_rounded),
                                    label: const Text('Restore File SQL'),
                                  ),
                                ],
                              ),
                            ],
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

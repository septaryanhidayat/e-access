import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  final _schoolNameCtrl = TextEditingController(text: 'SMK NEGERI 2 BALIKPAPAN');
  final _schoolAddrCtrl = TextEditingController(text: 'Jl. Soekarno Hatta Km. 2, Balikpapan');
  final _academicYearCtrl = TextEditingController(text: '2026/2027 - Ganjil');
  final _contactEmailCtrl = TextEditingController(text: 'info@smkn2balikpapan.sch.id');
  final _principalCtrl = TextEditingController(text: 'Drs. H. Bambang Irianto, M.Pd.');

  final List<Map<String, String>> _backups = [
    {'name': 'backup_eaccess_2026_07_27.sql', 'date': '27/07/2026 02:00 WIB', 'size': '48,6 MB', 'status': 'Sukses'},
    {'name': 'backup_eaccess_2026_07_20.sql', 'date': '20/07/2026 02:00 WIB', 'size': '46,2 MB', 'status': 'Sukses'},
    {'name': 'backup_eaccess_2026_07_13.sql', 'date': '13/07/2026 02:00 WIB', 'size': '44,8 MB', 'status': 'Sukses'},
  ];

  @override
  void dispose() {
    _schoolNameCtrl.dispose();
    _schoolAddrCtrl.dispose();
    _academicYearCtrl.dispose();
    _contactEmailCtrl.dispose();
    _principalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;
    final activeRoute = GoRouterState.of(context).matchedLocation;

    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF8D90A0) : const Color(0xFF475569);

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
                        Text('Pengaturan Sistem & Backup Database', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)),
                        const SizedBox(height: 4),
                        Text('Kelola Identitas Sekolah, Pengaturan Aplikasi, serta Cadangkan & Pulihkan Database.', style: TextStyle(color: textSecondary, fontSize: 13)),
                        const SizedBox(height: 20),

                        // Form Identitas Sekolah
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Identitas Sekolah & Kop Surat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2563EB))),
                              const SizedBox(height: 12),
                              TextFormField(controller: _schoolNameCtrl, decoration: const InputDecoration(labelText: 'Nama Sekolah')),
                              const SizedBox(height: 10),
                              TextFormField(controller: _schoolAddrCtrl, decoration: const InputDecoration(labelText: 'Alamat Lengkap')),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: TextFormField(controller: _academicYearCtrl, decoration: const InputDecoration(labelText: 'Tahun Ajaran & Semester'))),
                                  const SizedBox(width: 10),
                                  Expanded(child: TextFormField(controller: _contactEmailCtrl, decoration: const InputDecoration(labelText: 'Email Kontak'))),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextFormField(controller: _principalCtrl, decoration: const InputDecoration(labelText: 'Kepala Sekolah')),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Identitas ${_schoolNameCtrl.text.trim()} berhasil diperbarui!')),
                                  );
                                },
                                icon: const Icon(Icons.save_rounded),
                                label: const Text('SIMPAN PENGATURAN'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Backup & Restore Database Panel
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Backup & Restore Database SQL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2563EB))),
                                  ElevatedButton.icon(
                                    onPressed: () => _performDatabaseBackup(context),
                                    icon: const Icon(Icons.cloud_download_rounded, size: 18),
                                    label: const Text('Backup Sekarang'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('Buat file cadangan SQL otomatis dari seluruh tabel database Supabase.', style: TextStyle(fontSize: 12, color: textSecondary)),
                              const SizedBox(height: 16),

                              // Backup List Table
                              Text('Daftar File Backup (${_backups.length})', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
                              const SizedBox(height: 10),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _backups.length,
                                separatorBuilder: (_, index) => const Divider(height: 12),
                                itemBuilder: (context, index) {
                                  final b = _backups[index];
                                  return Row(
                                    children: [
                                      const Icon(Icons.storage_rounded, color: Color(0xFF2563EB), size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(b['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
                                            Text('${b['date']} • Ukuran: ${b['size']}', style: TextStyle(fontSize: 11, color: textSecondary)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                                        child: Text(b['status']!, style: const TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.download_rounded, color: Color(0xFF2563EB), size: 18),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mengunduh file ${b['name']} ke perangkat...')));
                                        },
                                        tooltip: 'Unduh File SQL',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.restore_page_rounded, color: Color(0xFFD97706), size: 18),
                                        onPressed: () => _confirmRestoreDatabase(context, b['name']!),
                                        tooltip: 'Restore Database',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                                        onPressed: () {
                                          setState(() => _backups.removeAt(index));
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup ${b['name']} dihapus.')));
                                        },
                                        tooltip: 'Hapus Backup',
                                      ),
                                    ],
                                  );
                                },
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

  void _performDatabaseBackup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: Color(0xFF2563EB)),
            SizedBox(width: 16),
            Text('Membuat cadangan database SQL...', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);

      final now = DateTime.now();
      final filename = 'backup_eaccess_${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}.sql';

      setState(() {
        _backups.insert(0, {
          'name': filename,
          'date': 'Hari ini, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB',
          'size': '48,6 MB',
          'status': 'Sukses',
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup Database "$filename" Berhasil Dibuat!')),
      );
    });
  }

  void _confirmRestoreDatabase(BuildContext context, String filename) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pulihkan Database?'),
        content: Text('Apakah Anda yakin ingin memulihkan seluruh data sistem dari file "$filename"? Data saat ini akan diperbarui.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Database berhasil dipulihkan dari $filename!')));
            },
            child: const Text('Restore Database'),
          ),
        ],
      ),
    );
  }
}

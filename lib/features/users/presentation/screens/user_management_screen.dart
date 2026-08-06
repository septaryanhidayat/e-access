import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  final List<Map<String, String>> _teachers = [
    {'nip': '198606152010011007', 'name': 'Ahmad Fauzi, S.T.', 'email': 'ahmad@smkn2balikpapan.sch.id', 'role': 'Guru', 'mapel': 'Pemrograman Mobile'},
    {'nip': '198804122012022003', 'name': 'Dewi Lestari, S.Pd.', 'email': 'dewi@smkn2balikpapan.sch.id', 'role': 'Guru', 'mapel': 'Basis Data'},
    {'nip': '199001202015031002', 'name': 'Budi Santoso, S.Pd.', 'email': 'budi@smkn2balikpapan.sch.id', 'role': 'Guru', 'mapel': 'Bahasa Indonesia'},
  ];

  final List<Map<String, String>> _students = [
    {'nisn': '0087654321', 'name': 'Andi Pratama', 'email': 'andi@student.sch.id', 'class': 'X TKJ 1', 'role': 'Siswa'},
    {'nisn': '0087654322', 'name': 'Siti Aminah', 'email': 'siti@student.sch.id', 'class': 'X TKJ 1', 'role': 'Siswa'},
    {'nisn': '0087654323', 'name': 'Rudi Hermawan', 'email': 'rudi@student.sch.id', 'class': 'XI RPL 1', 'role': 'Siswa'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;
    final primaryAccent = isDark ? AppColors.electricCyan : AppColors.electricBlueLight;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? const AppSidebar(activeRoute: '/users') : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(activeRoute: '/users'),
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
                        // Header Action Banner
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Manajemen Data Pengguna',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Kelola akun Guru, Siswa, Admin, serta Import/Export massal via Excel.',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => _showImportModal(context),
                                  icon: const Icon(Icons.file_upload_rounded, size: 18),
                                  label: const Text('Import Excel/CSV'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: () => _showAddUserModal(context),
                                  icon: const Icon(Icons.person_add_rounded, size: 18),
                                  label: const Text('Tambah User'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Tabs
                        TabBar(
                          controller: _tabController,
                          indicatorColor: primaryAccent,
                          labelColor: primaryAccent,
                          unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          tabs: const [
                            Tab(text: 'Data Guru Pengajar'),
                            Tab(text: 'Data Siswa Terdaftar'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 500,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildTeacherTable(context),
                              _buildStudentTable(context),
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

  Widget _buildTeacherTable(BuildContext context) {
    return CustomCard(
      child: ListView.separated(
        itemCount: _teachers.length,
        separatorBuilder: (_, index) => const Divider(height: 16),
        itemBuilder: (context, index) {
          final t = _teachers[index];
          return Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.adminGreen.withAlpha(25),
                child: const Icon(Icons.person_rounded, color: AppColors.adminGreen, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('NIP: ${t['nip']} • Mapel: ${t['mapel']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                  ],
                ),
              ),
              StatusChip(status: t['role']!, fontSize: 10),
              IconButton(
                icon: const Icon(Icons.lock_reset_rounded, size: 18, color: AppColors.warning),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reset password untuk ${t['name']} berhasil!')),
                  );
                },
                tooltip: 'Reset Password',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStudentTable(BuildContext context) {
    return CustomCard(
      child: ListView.separated(
        itemCount: _students.length,
        separatorBuilder: (_, index) => const Divider(height: 16),
        itemBuilder: (context, index) {
          final s = _students[index];
          return Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.siswaBlue.withAlpha(25),
                child: const Icon(Icons.school_rounded, color: AppColors.siswaBlue, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('NISN: ${s['nisn']} • Kelas: ${s['class']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                  ],
                ),
              ),
              StatusChip(status: s['class']!, fontSize: 10),
              IconButton(
                icon: const Icon(Icons.lock_reset_rounded, size: 18, color: AppColors.warning),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reset password untuk ${s['name']} berhasil!')),
                  );
                },
                tooltip: 'Reset Password',
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddUserModal(BuildContext context) {
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
            const Text('Tambah Pengguna Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.electricCyan)),
            const SizedBox(height: 14),
            TextFormField(decoration: const InputDecoration(labelText: 'Nama Lengkap')),
            const SizedBox(height: 10),
            TextFormField(decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextFormField(decoration: const InputDecoration(labelText: 'NIP / NISN')),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengguna Berhasil Ditambahkan!')));
                },
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('SIMPAN PENGGUNA'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundCardDark : AppColors.backgroundCardLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Import Data Massal (Excel / CSV)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File Excel Berhasil Diimpor (120 data)!')));
              },
              icon: const Icon(Icons.file_present_rounded, color: Colors.green),
              label: const Text('Pilih File Excel (.xlsx / .csv)'),
            ),
          ],
        ),
      ),
    );
  }
}

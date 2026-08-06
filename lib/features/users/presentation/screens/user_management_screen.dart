import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    final activeRoute = GoRouterState.of(context).matchedLocation;

    if (activeRoute == '/teachers' && _tabController.index != 0) {
      _tabController.index = 0;
    } else if (activeRoute == '/students' && _tabController.index != 1) {
      _tabController.index = 1;
    }

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
                          tabs: [
                            Tab(text: 'Data Guru Pengajar (${_teachers.length})'),
                            Tab(text: 'Data Siswa Terdaftar (${_students.length})'),
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
    if (_teachers.isEmpty) {
      return const Center(child: Text('Belum ada data guru. Klik "Tambah User" untuk menambah baru.'));
    }

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
                    Text('NIP: ${t['nip']} • Mapel: ${t['mapel']}', style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                  ],
                ),
              ),
              StatusChip(status: t['role']!, fontSize: 10),
              IconButton(
                icon: const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF2563EB)),
                onPressed: () => _showEditUserModal(context, isTeacher: true, index: index),
                tooltip: 'Edit Guru',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                onPressed: () => _confirmDeleteUser(context, isTeacher: true, index: index),
                tooltip: 'Hapus Guru',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStudentTable(BuildContext context) {
    if (_students.isEmpty) {
      return const Center(child: Text('Belum ada data siswa. Klik "Tambah User" untuk menambah baru.'));
    }

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
                    Text('NISN: ${s['nisn']} • Kelas: ${s['class']}', style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                  ],
                ),
              ),
              StatusChip(status: s['class']!, fontSize: 10),
              IconButton(
                icon: const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF2563EB)),
                onPressed: () => _showEditUserModal(context, isTeacher: false, index: index),
                tooltip: 'Edit Siswa',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                onPressed: () => _confirmDeleteUser(context, isTeacher: false, index: index),
                tooltip: 'Hapus Siswa',
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddUserModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    final detailCtrl = TextEditingController();
    String selectedRole = 'Guru';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundCardDark : AppColors.backgroundCardLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tambah Pengguna Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.electricBlue)),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: ['Guru', 'Siswa'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedRole = val);
                },
                decoration: const InputDecoration(labelText: 'Tipe Peran (Role)'),
              ),
              const SizedBox(height: 10),
              TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
              const SizedBox(height: 10),
              TextFormField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 10),
              TextFormField(controller: idCtrl, decoration: InputDecoration(labelText: selectedRole == 'Guru' ? 'NIP' : 'NISN')),
              const SizedBox(height: 10),
              TextFormField(controller: detailCtrl, decoration: InputDecoration(labelText: selectedRole == 'Guru' ? 'Mata Pelajaran yang Diampu' : 'Kelas (misal: X TKJ 1)')),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) return;

                    setState(() {
                      if (selectedRole == 'Guru') {
                        _teachers.add({
                          'nip': idCtrl.text.trim().isEmpty ? '1995000000000' : idCtrl.text.trim(),
                          'name': nameCtrl.text.trim(),
                          'email': emailCtrl.text.trim().isEmpty ? 'guru@smkn2balikpapan.sch.id' : emailCtrl.text.trim(),
                          'role': 'Guru',
                          'mapel': detailCtrl.text.trim().isEmpty ? 'Informatika' : detailCtrl.text.trim(),
                        });
                      } else {
                        _students.add({
                          'nisn': idCtrl.text.trim().isEmpty ? '009000000' : idCtrl.text.trim(),
                          'name': nameCtrl.text.trim(),
                          'email': emailCtrl.text.trim().isEmpty ? 'siswa@student.sch.id' : emailCtrl.text.trim(),
                          'class': detailCtrl.text.trim().isEmpty ? 'X TKJ 1' : detailCtrl.text.trim(),
                          'role': 'Siswa',
                        });
                      }
                    });

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Berhasil menambahkan ${nameCtrl.text.trim()} ke dalam daftar ${selectedRole}!')),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('SIMPAN PENGGUNA'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditUserModal(BuildContext context, {required bool isTeacher, required int index}) {
    final item = isTeacher ? _teachers[index] : _students[index];
    final nameCtrl = TextEditingController(text: item['name']);
    final emailCtrl = TextEditingController(text: item['email']);
    final idCtrl = TextEditingController(text: isTeacher ? item['nip'] : item['nisn']);
    final detailCtrl = TextEditingController(text: isTeacher ? item['mapel'] : item['class']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Data ${isTeacher ? "Guru" : "Siswa"}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.electricBlue)),
            const SizedBox(height: 14),
            TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
            const SizedBox(height: 10),
            TextFormField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextFormField(controller: idCtrl, decoration: InputDecoration(labelText: isTeacher ? 'NIP' : 'NISN')),
            const SizedBox(height: 10),
            TextFormField(controller: detailCtrl, decoration: InputDecoration(labelText: isTeacher ? 'Mata Pelajaran' : 'Kelas')),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (isTeacher) {
                      _teachers[index] = {
                        ..._teachers[index],
                        'name': nameCtrl.text.trim(),
                        'email': emailCtrl.text.trim(),
                        'nip': idCtrl.text.trim(),
                        'mapel': detailCtrl.text.trim(),
                      };
                    } else {
                      _students[index] = {
                        ..._students[index],
                        'name': nameCtrl.text.trim(),
                        'email': emailCtrl.text.trim(),
                        'nisn': idCtrl.text.trim(),
                        'class': detailCtrl.text.trim(),
                      };
                    }
                  });

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data pengguna berhasil diperbarui!')));
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('UPDATE DATA'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, {required bool isTeacher, required int index}) {
    final item = isTeacher ? _teachers[index] : _students[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus ${isTeacher ? "Guru" : "Siswa"}?'),
        content: Text('Apakah Anda yakin ingin menghapus data "${item['name']}" secara permanen?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                if (isTeacher) {
                  _teachers.removeAt(index);
                } else {
                  _students.removeAt(index);
                }
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data ${item['name']} telah dihapus.')));
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showImportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Import Data Massal (Excel / CSV)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Sistem akan mengimpor data pengajar dan siswa secara otomatis dari spreadsheet.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _teachers.add({'nip': '19920101202001', 'name': 'Drs. Hendra Wijaya', 'email': 'hendra@smkn2.sch.id', 'role': 'Guru', 'mapel': 'Fisika'});
                  _students.add({'nisn': '008999111', 'name': 'Bagus Saputra', 'email': 'bagus@student.sch.id', 'class': 'X TKJ 2', 'role': 'Siswa'});
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil mengimpor 2 data baru dari file Excel!')));
              },
              icon: const Icon(Icons.file_present_rounded),
              label: const Text('Pilih File Excel (.xlsx / .csv)'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/student_bottom_nav.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isNotificationEnabled = true;
  String _selectedLanguage = 'Indonesia';

  String _birthDate = 'Balikpapan, 12 Mei 2010';
  String _gender = 'Laki-laki';
  String _address = 'Jl. Jend. Sudirman No. 10 Balikpapan, Kalimantan Timur';
  String _phone = '0812-3456-7890';

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final userName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? 'Andi Pratama';
    final userEmail = user?.email ?? 'andi.pratama@smkn2bpn.sch.id';
    final isStudent = authProvider.userRole == 'Siswa' || authProvider.userRole == null;

    final isMobile = MediaQuery.of(context).size.width < 1000;
    final activeRoute = GoRouterState.of(context).matchedLocation;

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
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Identity Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF131B2E),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF1E293B)),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF4EDEAE)]),
                                        ),
                                        child: const CircleAvatar(
                                          radius: 42,
                                          backgroundColor: Color(0xFF0B1326),
                                          child: Icon(Icons.face_retouching_natural_rounded, size: 46, color: Color(0xFF93C5FD)),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () => _showEditAvatarDialog(context),
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1E293B),
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                            child: const Icon(Icons.edit_outlined, size: 14, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF005236),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Row(
                                          children: [
                                            CircleAvatar(radius: 3, backgroundColor: Color(0xFF4EDEAE)),
                                            SizedBox(width: 4),
                                            Text('Aktif', style: TextStyle(color: Color(0xFF4EDEAE), fontSize: 10, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Kelas X TKJ 1 • NISN 0087654321', style: TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: const Color(0xFF334155)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.school_outlined, size: 14, color: Color(0xFFFFB95F)),
                                        SizedBox(width: 6),
                                        Text('SMK NEGERI 2 BALIKPAPAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Section: Informasi Pribadi
                            const Row(
                              children: [
                                Icon(Icons.person_outline_rounded, size: 20, color: Color(0xFF4EDEAE)),
                                SizedBox(width: 8),
                                Text('Informasi Pribadi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF131B2E),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF1E293B)),
                              ),
                              child: Column(
                                children: [
                                  _buildInfoRow(context, Icons.calendar_today_rounded, 'TEMPAT, TANGGAL LAHIR', _birthDate, hasChevron: true, fieldKey: 'birthDate'),
                                  const Divider(height: 1, color: Color(0xFF1E293B)),
                                  _buildInfoRow(context, Icons.wc_rounded, 'JENIS KELAMIN', _gender, hasChevron: false),
                                  const Divider(height: 1, color: Color(0xFF1E293B)),
                                  _buildInfoRow(context, Icons.location_on_outlined, 'ALAMAT', _address, hasChevron: true, fieldKey: 'address'),
                                  const Divider(height: 1, color: Color(0xFF1E293B)),
                                  _buildInfoRow(context, Icons.email_outlined, 'EMAIL', userEmail, hasChevron: true, fieldKey: 'email'),
                                  const Divider(height: 1, color: Color(0xFF1E293B)),
                                  _buildInfoRow(context, Icons.phone_android_rounded, 'NO. TELEPON', _phone, hasChevron: true, fieldKey: 'phone'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Section: Pengaturan Akun
                            const Row(
                              children: [
                                Icon(Icons.settings_outlined, size: 20, color: Color(0xFF4EDEAE)),
                                SizedBox(width: 8),
                                Text('Pengaturan Akun', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF131B2E),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF1E293B)),
                              ),
                              child: Column(
                                children: [
                                  _buildSettingRow(
                                    context,
                                    Icons.lock_outline_rounded,
                                    'Ubah Password',
                                    onTap: () => _showChangePasswordDialog(context),
                                  ),
                                  const Divider(height: 1, color: Color(0xFF1E293B)),
                                  _buildSettingRow(
                                    context,
                                    Icons.notifications_outlined,
                                    'Notifikasi',
                                    trailingText: _isNotificationEnabled ? 'Aktif' : 'Non-aktif',
                                    onTap: () {
                                      setState(() => _isNotificationEnabled = !_isNotificationEnabled);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(_isNotificationEnabled ? 'Notifikasi diaktifkan' : 'Notifikasi dinonaktifkan')),
                                      );
                                    },
                                  ),
                                  const Divider(height: 1, color: Color(0xFF1E293B)),
                                  _buildSettingRow(
                                    context,
                                    Icons.language_rounded,
                                    'Bahasa',
                                    trailingText: _selectedLanguage,
                                    onTap: () => _showLanguageModal(context),
                                  ),
                                  const Divider(height: 1, color: Color(0xFF1E293B)),
                                  _buildSettingRow(
                                    context,
                                    Icons.info_outline_rounded,
                                    'Tentang Aplikasi',
                                    onTap: () => _showAboutAppDialog(context),
                                  ),
                                  const Divider(height: 1, color: Color(0xFF1E293B)),
                                  _buildSettingRow(
                                    context,
                                    Icons.help_outline_rounded,
                                    'Bantuan & Panduan',
                                    onTap: () => _showHelpCenterDialog(context),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Keluar Akun Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _showLogoutConfirmDialog(context, authProvider),
                                icon: const Icon(Icons.logout_rounded, color: Color(0xFFFFB4AB), size: 18),
                                label: const Text('Keluar Akun', style: TextStyle(color: Color(0xFFFFB4AB), fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  side: const BorderSide(color: Color(0xFF93000A)),
                                  backgroundColor: const Color(0xFF131B2E),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          const Text('Profil Saya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
            onPressed: () => _showNotificationsDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, {required bool hasChevron, String? fieldKey}) {
    return InkWell(
      onTap: fieldKey != null ? () => _showEditFieldDialog(context, label, value, fieldKey) : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: const Color(0xFF93C5FD), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF8D90A0), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
            ),
            if (hasChevron) const Icon(Icons.chevron_right_rounded, color: Color(0xFF8D90A0), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(BuildContext context, IconData icon, String title, {String? trailingText, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: const Color(0xFFFFB95F), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
            if (trailingText != null) ...[
              Text(trailingText, style: const TextStyle(fontSize: 12, color: Color(0xFF4EDEAE), fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
            ],
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF8D90A0), size: 20),
          ],
        ),
      ),
    );
  }

  // Interactive Helper Dialogs
  void _showEditAvatarDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131B2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ubah Foto Profil', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: Color(0xFF38BDF8)),
              title: const Text('Ambil Foto Kamera', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kamera dibuka...')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF4EDEAE)),
              title: const Text('Pilih dari Galeri', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Galeri dibuka...')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditFieldDialog(BuildContext context, String title, String currentValue, String fieldKey) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: Text('Edit $title', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Ketik nilai baru...', hintStyle: TextStyle(color: Color(0xFF8D90A0))),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal', style: TextStyle(color: Color(0xFFFFB4AB)))),
          TextButton(
            onPressed: () {
              setState(() {
                if (fieldKey == 'birthDate') _birthDate = controller.text;
                if (fieldKey == 'address') _address = controller.text;
                if (fieldKey == 'phone') _phone = controller.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil diperbarui.')));
            },
            child: const Text('Simpan', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Text('Ubah Password Akun', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'Password Lama', labelStyle: TextStyle(color: Color(0xFF8D90A0))),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'Password Baru', labelStyle: TextStyle(color: Color(0xFF8D90A0))),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal', style: TextStyle(color: Color(0xFFFFB4AB)))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password berhasil diubah.')));
            },
            child: const Text('Simpan', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLanguageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131B2E),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Indonesia', 'English'].map((lang) {
          return RadioListTile<String>(
            title: Text(lang, style: const TextStyle(color: Colors.white)),
            value: lang,
            groupValue: _selectedLanguage,
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedLanguage = val);
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Text('Tentang E-ACCESS System', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('E-ACCESS System v2.4.0', style: TextStyle(color: Color(0xFF4EDEAE), fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 6),
            Text('Sistem Manajemen Pembelajaran & CBT Terintegrasi SMK Negeri 2 Balikpapan.', style: TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup', style: TextStyle(color: Color(0xFF38BDF8)))),
        ],
      ),
    );
  }

  void _showHelpCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Text('Bantuan & Panduan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Bagaimana cara scan QR Code Presensi?', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Buka menu Beranda -> klik tombol Presensi Sekarang.', style: TextStyle(color: Color(0xFF8D90A0), fontSize: 11)),
            SizedBox(height: 8),
            Text('2. Kendala saat ujian CBT?', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Pastikan koneksi internet stabil dan minta token ulang dari pengawas.', style: TextStyle(color: Color(0xFF8D90A0), fontSize: 11)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup', style: TextStyle(color: Color(0xFF38BDF8)))),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Text('Notifikasi Profil', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Tidak ada notifikasi penting saat ini.', style: TextStyle(color: Color(0xFF8D90A0), fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup', style: TextStyle(color: Color(0xFF38BDF8)))),
        ],
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Text('Konfirmasi Keluar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?', style: TextStyle(color: Color(0xFF8D90A0), fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal', style: TextStyle(color: Color(0xFF8D90A0)))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              authProvider.logout();
            },
            child: const Text('Keluar', style: TextStyle(color: Color(0xFFFFB4AB), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/student_bottom_nav.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class StudentMaterialsScreen extends StatefulWidget {
  const StudentMaterialsScreen({super.key});

  @override
  State<StudentMaterialsScreen> createState() => _StudentMaterialsScreenState();
}

class _StudentMaterialsScreenState extends State<StudentMaterialsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeCategory = 'Semua';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _materials = [
    {
      'id': 'mat_1',
      'title': 'Teks Laporan Hasil Observasi (LHO)',
      'subtitle': 'Bahasa Indonesia • Kelas X',
      'category': 'Bahasa Indonesia',
      'type': 'PDF',
      'progress': 75,
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFFEC4899),
      'isHighlighted': false,
    },
    {
      'id': 'mat_2',
      'title': 'Teks Anekdot & Struktur Humor',
      'subtitle': 'Bahasa Indonesia • Kelas X',
      'category': 'Bahasa Indonesia',
      'type': 'Video',
      'progress': 60,
      'icon': Icons.play_circle_fill_rounded,
      'color': const Color(0xFF3B82F6),
      'isHighlighted': false,
    },
    {
      'id': 'mat_3',
      'title': 'Hikayat & Sastra Melayu Klasik',
      'subtitle': 'Bahasa Indonesia • Kelas X',
      'category': 'Bahasa Indonesia',
      'type': 'PDF',
      'progress': 40,
      'icon': Icons.picture_as_pdf_rounded,
      'color': const Color(0xFF10B981),
      'isHighlighted': false,
    },
    {
      'id': 'mat_4',
      'title': 'Pemrograman Dasal Dart & Flutter',
      'subtitle': 'Informatika • Kelas XI',
      'category': 'Informatika',
      'type': 'Video',
      'progress': 90,
      'icon': Icons.ondemand_video_rounded,
      'color': const Color(0xFF8B5CF6),
      'isHighlighted': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final role = authProvider.userRole ?? 'Siswa';
    final isTeacherOrAdmin = role == 'Guru' || role == 'Admin' || role == 'Super Admin';
    final isStudent = role == 'Siswa';
    final isMobile = MediaQuery.of(context).size.width < 1000;
    final activeRoute = GoRouterState.of(context).matchedLocation;

    final filteredList = _materials.where((m) {
      final matchesCategory = _activeCategory == 'Semua' || m['category'] == _activeCategory;
      final matchesSearch = _searchQuery.isEmpty || m['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? AppSidebar(activeRoute: activeRoute) : null,
      bottomNavigationBar: (isMobile || isStudent) ? StudentBottomNav(activeRoute: activeRoute) : null,
      floatingActionButton: isTeacherOrAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showAddMaterialModal(context),
              backgroundColor: const Color(0xFF2563EB),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('Upload Materi / Video', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
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
                        // Page Banner
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Materi & Video Pembelajaran', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('Pelajari modul PDF, ringkasan materi, dan video pembelajaran interaktif.', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, fontSize: 12)),
                              ],
                            ),
                            if (isTeacherOrAdmin)
                              ElevatedButton.icon(
                                onPressed: () => _showAddMaterialModal(context),
                                icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                                label: const Text('Tambah Materi Baru'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Category Filter Chips Row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildCategoryChip('Semua'),
                              const SizedBox(width: 8),
                              _buildCategoryChip('Bahasa Indonesia'),
                              const SizedBox(width: 8),
                              _buildCategoryChip('Informatika'),
                              const SizedBox(width: 8),
                              _buildCategoryChip('Matematika'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Search Bar & Filter Options
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: 'Cari materi atau modul pelajaran...',
                                  prefixIcon: const Icon(Icons.search_rounded),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = ''))
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Materials Grid/List
                        if (filteredList.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Text('Tidak ada materi yang cocok dengan pencarian.'),
                            ),
                          )
                        else
                          GridView.count(
                            crossAxisCount: isMobile ? 1 : 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: isMobile ? 1.8 : 2.2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: filteredList.map((m) {
                              return _buildMaterialCard(context, m, isTeacherOrAdmin);
                            }).toList(),
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

  Widget _buildMobileHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
                const SizedBox(width: 8),
                const Text('Materi Pembelajaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.add_rounded, color: Color(0xFF2563EB)),
              onPressed: () => _showAddMaterialModal(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _activeCategory == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      onSelected: (val) {
        setState(() => _activeCategory = label);
      },
    );
  }

  Widget _buildMaterialCard(BuildContext context, Map<String, dynamic> item, bool isTeacherOrAdmin) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = item['title'] as String;
    final subtitle = item['subtitle'] as String;
    final category = item['category'] as String;
    final type = item['type'] ?? 'PDF';
    final progress = item['progress'] as int;
    final icon = item['icon'] as IconData;
    final color = item['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                          child: Text(type, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 6),
                        Text(category, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(subtitle, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                  ],
                ),
              ),
              if (isTeacherOrAdmin)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                  onPressed: () => _confirmDeleteMaterial(context, item['id']),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progres Membaca', style: TextStyle(fontSize: 10, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                  Text('$progress%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: progress / 100, backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 6),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => context.go('/material_detail/${item['id']}'),
                icon: Icon(type == 'Video' ? Icons.play_arrow_rounded : Icons.menu_book_rounded, size: 16),
                label: Text(type == 'Video' ? 'Tonton Video' : 'Baca Modul PDF', style: const TextStyle(fontSize: 11)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMaterialModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final subCtrl = TextEditingController();
    String category = 'Bahasa Indonesia';
    String type = 'PDF';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Upload Materi / Video Pembelajaran Baru', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: category,
                      items: ['Bahasa Indonesia', 'Informatika', 'Matematika'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setModalState(() => category = val!),
                      decoration: const InputDecoration(labelText: 'Mata Pelajaran'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: type,
                      items: ['PDF', 'Video'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (val) => setModalState(() => type = val!),
                      decoration: const InputDecoration(labelText: 'Tipe Konten'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Judul Modul / Video')),
              const SizedBox(height: 10),
              TextFormField(controller: subCtrl, decoration: const InputDecoration(labelText: 'Deskripsi Singkat / Target Kelas')),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (titleCtrl.text.trim().isEmpty) return;

                    setState(() {
                      _materials.add({
                        'id': 'mat_${DateTime.now().millisecondsSinceEpoch}',
                        'title': titleCtrl.text.trim(),
                        'subtitle': subCtrl.text.trim().isEmpty ? '$category • Modul Terbaru' : subCtrl.text.trim(),
                        'category': category,
                        'type': type,
                        'progress': 0,
                        'icon': type == 'Video' ? Icons.play_circle_fill_rounded : Icons.picture_as_pdf_rounded,
                        'color': type == 'Video' ? const Color(0xFF3B82F6) : const Color(0xFF10B981),
                        'isHighlighted': false,
                      });
                    });

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil mengunggah $type "${titleCtrl.text.trim()}"!')));
                  },
                  icon: const Icon(Icons.cloud_upload_rounded),
                  label: const Text('PUBLIKASIKAN MATERI'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteMaterial(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Materi?'),
        content: const Text('Apakah Anda yakin ingin menghapus materi ini dari daftar pembelajaran?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _materials.removeWhere((m) => m['id'] == id);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Materi telah dihapus.')));
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

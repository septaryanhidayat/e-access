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
      'progress': 75,
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFFEC4899),
      'isHighlighted': false,
    },
    {
      'id': 'mat_2',
      'title': 'Teks Anekdot',
      'subtitle': 'Bahasa Indonesia • Kelas X',
      'category': 'Bahasa Indonesia',
      'progress': 60,
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFFEC4899),
      'isHighlighted': false,
    },
    {
      'id': 'mat_3',
      'title': 'Hikayat',
      'subtitle': 'Bahasa Indonesia • Kelas X',
      'category': 'Bahasa Indonesia',
      'progress': 40,
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFFEC4899),
      'isHighlighted': false,
    },
    {
      'id': 'mat_4',
      'title': 'Algoritma & Flowchart',
      'subtitle': 'Informatika • Kelas X',
      'category': 'Informatika',
      'progress': 20,
      'icon': Icons.laptop_chromebook_rounded,
      'color': const Color(0xFF38BDF8),
      'isHighlighted': true,
    },
    {
      'id': 'mat_5',
      'title': 'Persamaan & Pertidaksamaan Linear',
      'subtitle': 'Matematika • Kelas X',
      'category': 'Matematika',
      'progress': 85,
      'icon': Icons.calculate_rounded,
      'color': const Color(0xFFFFB95F),
      'isHighlighted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isStudent = authProvider.userRole == 'Siswa' || authProvider.userRole == null;
    final isMobile = MediaQuery.of(context).size.width < 1000;

    final filteredList = _materials.where((m) {
      final matchesCategory = _activeCategory == 'Semua' || m['category'] == _activeCategory;
      final matchesSearch = _searchQuery.isEmpty || m['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? const AppSidebar(activeRoute: '/materials') : null,
      bottomNavigationBar: (isMobile || isStudent) ? const StudentBottomNav(activeRoute: '/materials') : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(activeRoute: '/materials'),
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
                        // Category Filter Chips
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
                        const SizedBox(height: 20),

                        // Section: Materi Terbaru
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _activeCategory == 'Semua' ? 'Materi Terbaru' : 'Materi $_activeCategory',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () => setState(() {
                                _activeCategory = 'Semua';
                                _searchQuery = '';
                              }),
                              child: const Text('Reset Filter', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // List of Materials
                        if (filteredList.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(24),
                            alignment: Alignment.center,
                            child: const Text('Tidak ada materi yang cocok dengan pencarian.', style: TextStyle(color: Color(0xFF8D90A0))),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              return _buildMaterialCard(
                                context,
                                item['title'],
                                item['subtitle'],
                                item['progress'],
                                item['icon'],
                                item['color'],
                                item['id'],
                                isHighlighted: item['isHighlighted'],
                              );
                            },
                          ),
                        const SizedBox(height: 24),

                        // Section: Kategori Materi (4 Grid Tiles)
                        const Text('Kategori Materi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 12),

                        GridView.count(
                          crossAxisCount: isMobile ? 4 : 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: isMobile ? 0.75 : 1.4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildCategoryGridTile('Bahasa\nIndonesia', Icons.menu_book_rounded, const Color(0xFFEC4899), 'Bahasa Indonesia'),
                            _buildCategoryGridTile('Informatika', Icons.laptop_chromebook_rounded, const Color(0xFF38BDF8), 'Informatika'),
                            _buildCategoryGridTile('Matematika', Icons.calculate_rounded, const Color(0xFFFFB95F), 'Matematika'),
                            _buildCategoryGridTile('Lainnya', Icons.lightbulb_rounded, const Color(0xFF4EDEAE), 'Semua'),
                          ],
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
          const Text(
            'Materi Pembelajaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _activeCategory == label;
    return InkWell(
      onTap: () => setState(() => _activeCategory = label),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF334155)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialCard(
    BuildContext context,
    String title,
    String subtitle,
    int progress,
    IconData icon,
    Color iconColor,
    String id, {
    bool isHighlighted = false,
  }) {
    return InkWell(
      onTap: () => context.push('/material_detail/$id'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(16),
          border: isHighlighted
              ? Border.all(color: const Color(0xFF4EDEAE), width: 1.5)
              : Border.all(color: const Color(0xFF1E293B)),
          boxShadow: isHighlighted
              ? [BoxShadow(color: const Color(0xFF4EDEAE).withOpacity(0.2), blurRadius: 10)]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF005236),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Baru', style: TextStyle(color: Color(0xFF4EDEAE), fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF8D90A0))),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: const Color(0xFF1E293B),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('$progress%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: iconColor.withOpacity(0.8), size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGridTile(String title, IconData icon, Color color, String targetCategory) {
    return InkWell(
      onTap: () => setState(() => _activeCategory = targetCategory),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final controller = TextEditingController(text: _searchQuery);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Text('Cari Materi Pembelajaran', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Ketik judul materi (contoh: LHO, Algoritma)...',
            hintStyle: TextStyle(color: Color(0xFF8D90A0)),
          ),
          onChanged: (val) {
            setState(() => _searchQuery = val);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: const Text('Reset', style: TextStyle(color: Color(0xFFFFB4AB))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cari', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

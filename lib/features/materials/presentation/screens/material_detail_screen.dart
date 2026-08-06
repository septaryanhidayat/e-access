import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/material_model.dart';
import '../../../../core/widgets/custom_card.dart';

class MaterialDetailScreen extends StatefulWidget {
  final String materialId;
  const MaterialDetailScreen({super.key, required this.materialId});

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoading = true;
  MaterialModel? _material;
  int _secondsSpent = 0;
  Timer? _trackerTimer;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _fetchMaterial();
    _startActivityTracker();
  }

  @override
  void dispose() {
    _trackerTimer?.cancel();
    _logActivityToSupabase();
    super.dispose();
  }

  Future<void> _fetchMaterial() async {
    try {
      final res = await _supabase
          .from('materials')
          .select('*')
          .eq('id', widget.materialId)
          .single();

      _material = MaterialModel.fromJson(res);
      setState(() => _isLoading = false);
    } catch (e) {
      final isVideo = widget.materialId.contains('video') || widget.materialId == 'mat_3';
      _material = MaterialModel(
        id: widget.materialId,
        teacherId: 't1',
        classId: 'c1',
        subjectId: 's1',
        title: isVideo ? 'Video Tutorial State Management Provider' : 'Modul Literasi: Pengenalan Flutter & Supabase',
        description: isVideo
            ? 'Video pembelajaran eksternal YouTube tentang penggunaan Provider pada Flutter.'
            : 'Materi dasar mengenai arsitektur Flutter, State Management, dan Row Level Security (RLS) pada Supabase.',
        type: isVideo ? 'video' : 'pdf',
        fileUrl: isVideo
            ? 'https://www.youtube.com/watch?v=d_m5csmrf7I'
            : 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        videoUrl: isVideo ? 'https://www.youtube.com/watch?v=d_m5csmrf7I' : null,
        estimatedReadMinutes: isVideo ? 25 : 15,
        createdAt: DateTime.now(),
      );
      setState(() => _isLoading = false);
    }
  }

  void _startActivityTracker() {
    _trackerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsSpent++;
        });
      }
    });
  }

  Future<void> _logActivityToSupabase() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null && _secondsSpent > 5) {
      try {
        await _supabase.from('activity_logs').insert({
          'user_id': userId,
          'material_id': widget.materialId,
          'action_type': _material?.type == 'video' ? 'watch_video' : 'read_pdf',
          'duration_seconds': _secondsSpent,
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {}
    }
  }

  Future<void> _openExternalLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka link: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.electricBlue : AppColors.electricBlueLight;
    final cardBg = isDark ? AppColors.backgroundCardDark : AppColors.backgroundCardLight;
    final borderCol = isDark ? AppColors.borderDark : AppColors.borderLight;

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryAccent)),
      );
    }

    final mat = _material!;
    final minutes = _secondsSpent ~/ 60;
    final seconds = _secondsSpent % 60;
    final isVideo = mat.type == 'video';

    return Scaffold(
      appBar: AppBar(
        title: Text(mat.title),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderCol),
            ),
            child: Row(
              children: [
                Icon(Icons.remove_red_eye_outlined, color: primaryAccent, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${minutes}m ${seconds}s',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              hasGlow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isVideo ? Colors.red : primaryAccent).withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isVideo ? Icons.play_circle_fill_rounded : Icons.picture_as_pdf_rounded,
                          color: isVideo ? Colors.redAccent : primaryAccent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mat.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isVideo
                                  ? 'Video Pembelajaran YouTube (Eksternal)'
                                  : 'Estimasi Membaca: ${mat.estimatedReadMinutes} Menit',
                              style: TextStyle(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (mat.description != null) ...[
                    Divider(color: borderCol, height: 24),
                    Text(
                      mat.description!,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Video YouTube Link Container or PDF Reader View
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderCol),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isVideo ? Icons.video_library_rounded : Icons.picture_as_pdf_rounded,
                    size: 64,
                    color: isVideo ? Colors.redAccent : primaryAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isVideo ? 'Video Pembelajaran YouTube' : 'Dokumen PDF Literasi',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mat.fileUrl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isVideo)
                    ElevatedButton.icon(
                      onPressed: () => _openExternalLink(mat.fileUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text(
                        'TONTON DI YOUTUBE (LINK EKSTERNAL)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => _openExternalLink(mat.fileUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text(
                        'BUKA FILE DOKUMEN PDF',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isCompleted = !_isCompleted;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isCompleted ? 'Materi ditandai Selesai Dibaca! 🎉' : 'Status pengerjaan diperbarui.')),
                      );
                    },
                    icon: Icon(
                      _isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                      color: _isCompleted ? const Color(0xFF4EDEAE) : Colors.white,
                    ),
                    label: Text(
                      _isCompleted ? 'TANDAI BELUM SELESAI' : 'TANDAI SELESAI DIBACA',
                      style: TextStyle(color: _isCompleted ? const Color(0xFF4EDEAE) : Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      side: BorderSide(color: _isCompleted ? const Color(0xFF4EDEAE) : const Color(0xFF334155)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

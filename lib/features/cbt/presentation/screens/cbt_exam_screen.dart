import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/models/exam_model.dart';

class CbtExamScreen extends StatefulWidget {
  final String examId;
  const CbtExamScreen({super.key, required this.examId});

  @override
  State<CbtExamScreen> createState() => _CbtExamScreenState();
}

class _CbtExamScreenState extends State<CbtExamScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoading = true;
  ExamModel? _exam;
  List<ExamQuestionModel> _questions = [];
  int _currentIndex = 0;
  final Map<String, String> _userAnswers = {};
  Timer? _timer;
  int _remainingSeconds = 3600;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchExamDetails();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchExamDetails() async {
    try {
      final examData = await _supabase
          .from('exams')
          .select('*, subjects(name)')
          .eq('id', widget.examId)
          .single();
      
      _exam = ExamModel.fromJson(examData);
      _remainingSeconds = (_exam?.durationMinutes ?? 60) * 60;

      final questionsData = await _supabase
          .from('exam_questions')
          .select('*')
          .eq('exam_id', widget.examId)
          .order('question_number', ascending: true);

      _questions = (questionsData as List)
          .map((q) => ExamQuestionModel.fromJson(q))
          .toList();

      if (_questions.isEmpty) {
        _generateSampleQuestions();
      }

      _startTimer();
      setState(() => _isLoading = false);
    } catch (e) {
      _exam = ExamModel(
        id: widget.examId,
        teacherId: 't1',
        classId: 'c1',
        subjectId: 's1',
        title: 'Ujian CBT Pemrograman Mobile',
        type: 'manual',
        durationMinutes: 45,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        subjectName: 'Pemrograman Flutter',
      );

      _generateSampleQuestions();
      _remainingSeconds = 45 * 60;
      _startTimer();
      setState(() => _isLoading = false);
    }
  }

  void _generateSampleQuestions() {
    _questions = List.generate(
      5,
      (index) => ExamQuestionModel(
        id: 'q_$index',
        examId: widget.examId,
        questionNumber: index + 1,
        questionText: 'Soal No. ${index + 1}: Sebutkan keunggulan State Management Provider pada Flutter.',
        type: index == 4 ? 'essay' : 'multiple_choice',
        optionA: 'Mudah dipahami dan efisien dalam mengelola state',
        optionB: 'Sangat lambat',
        optionC: 'Hanya bekerja di Android',
        optionD: 'Tidak mendukung MultiProvider',
        optionE: 'Dihentikan pengembangannya',
        correctAnswer: 'A',
        points: 20,
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        _submitExam(autoSubmit: true);
      }
    });
  }

  String _formatTimer(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _submitExam({bool autoSubmit = false}) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    double totalScore = 0;
    int totalPoints = 0;

    for (var q in _questions) {
      totalPoints += q.points;
      if (q.type == 'multiple_choice') {
        if (_userAnswers[q.id] == q.correctAnswer) {
          totalScore += q.points;
        }
      } else {
        if ((_userAnswers[q.id] ?? '').isNotEmpty) {
          totalScore += q.points * 0.8;
        }
      }
    }

    final finalScore = (totalPoints > 0) ? (totalScore / totalPoints) * 100 : 0.0;
    final userId = _supabase.auth.currentUser?.id;

    if (userId != null) {
      try {
        await _supabase.from('exam_results').upsert({
          'exam_id': widget.examId,
          'student_id': userId,
          'score': finalScore,
          'status': 'completed',
          'answers_json': _userAnswers,
          'submitted_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {}
    }

    if (!mounted) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.electricBlue : AppColors.electricBlueLight;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.backgroundCardDark : AppColors.backgroundCardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: primaryAccent, size: 28),
            const SizedBox(width: 8),
            Text(autoSubmit ? 'Waktu Habis!' : 'Ujian Selesai'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Jawaban Anda berhasil dikirim.'),
            const SizedBox(height: 12),
            Text(
              'Nilai Sementara: ${finalScore.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryAccent,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('KEMBALI KE DASHBOARD'),
          ),
        ],
      ),
    );
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

    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(_exam?.title ?? 'CBT Exam'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: primaryAccent.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryAccent),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, color: primaryAccent, size: 18),
                const SizedBox(width: 6),
                Text(
                  _formatTimer(_remainingSeconds),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Question Navigation grid
          Container(
            padding: const EdgeInsets.all(12),
            color: cardBg,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_questions.length, (index) {
                  final q = _questions[index];
                  final isAnswered = _userAnswers.containsKey(q.id);
                  final isCurrent = index == _currentIndex;

                  return GestureDetector(
                    onTap: () => setState(() => _currentIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? primaryAccent
                            : isAnswered
                                ? primaryAccent.withAlpha(50)
                                : cardBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCurrent ? primaryAccent : borderCol,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Main Question Card
          Expanded(
            child: SingleChildScrollView(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Soal No. ${_currentIndex + 1} dari ${_questions.length}',
                              style: TextStyle(
                                color: primaryAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Bobot: ${currentQuestion.points} Poin',
                              style: TextStyle(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: borderCol, height: 20),
                        Text(
                          currentQuestion.questionText,
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (currentQuestion.type == 'multiple_choice') ...[
                    _buildOptionTile('A', currentQuestion.optionA, currentQuestion.id, primaryAccent, cardBg, borderCol),
                    _buildOptionTile('B', currentQuestion.optionB, currentQuestion.id, primaryAccent, cardBg, borderCol),
                    _buildOptionTile('C', currentQuestion.optionC, currentQuestion.id, primaryAccent, cardBg, borderCol),
                    _buildOptionTile('D', currentQuestion.optionD, currentQuestion.id, primaryAccent, cardBg, borderCol),
                    _buildOptionTile('E', currentQuestion.optionE, currentQuestion.id, primaryAccent, cardBg, borderCol),
                  ] else ...[
                    const Text('Jawaban Uraian Singkat:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _userAnswers[currentQuestion.id] ?? '',
                      maxLines: 4,
                      onChanged: (val) {
                        setState(() {
                          _userAnswers[currentQuestion.id] = val;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Ketik jawaban Anda di sini...',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Footer Navigation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(top: BorderSide(color: borderCol)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _currentIndex > 0 ? () => setState(() => _currentIndex--) : null,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Sebelumnya'),
                ),
                if (_currentIndex < _questions.length - 1)
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _currentIndex++),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Selanjutnya'),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () => _submitExam(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('SELESAI & KIRIM'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String key, String? optionText, String questionId, Color primaryAccent, Color cardBg, Color borderCol) {
    if (optionText == null || optionText.isEmpty) return const SizedBox.shrink();

    final isSelected = _userAnswers[questionId] == key;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            _userAnswers[questionId] = key;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? primaryAccent.withAlpha(25) : cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryAccent : borderCol,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? primaryAccent : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
                  border: Border.all(color: isSelected ? primaryAccent : borderCol),
                ),
                alignment: Alignment.center,
                child: Text(
                  key,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  optionText,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

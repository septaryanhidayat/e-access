class ExamModel {
  final String id;
  final String teacherId;
  final String classId;
  final String subjectId;
  final String title;
  final String? description;
  final String type; // 'manual' or 'pdf_upload'
  final int durationMinutes;
  final DateTime startTime;
  final DateTime endTime;
  final String? pdfUrl;
  final bool isActive;
  final String? subjectName;

  ExamModel({
    required this.id,
    required this.teacherId,
    required this.classId,
    required this.subjectId,
    required this.title,
    this.description,
    required this.type,
    required this.durationMinutes,
    required this.startTime,
    required this.endTime,
    this.pdfUrl,
    this.isActive = true,
    this.subjectName,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as String,
      teacherId: json['teacher_id'] as String? ?? '',
      classId: json['class_id'] as String? ?? '',
      subjectId: json['subject_id'] as String? ?? '',
      title: json['title'] as String? ?? 'Ujian CBT',
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'manual',
      durationMinutes: json['duration_minutes'] as int? ?? 60,
      startTime: json['start_time'] != null 
          ? DateTime.parse(json['start_time'] as String) 
          : DateTime.now(),
      endTime: json['end_time'] != null 
          ? DateTime.parse(json['end_time'] as String) 
          : DateTime.now().add(const Duration(hours: 2)),
      pdfUrl: json['pdf_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      subjectName: json['subjects']?['name'] as String?,
    );
  }
}

class ExamQuestionModel {
  final String id;
  final String examId;
  final int questionNumber;
  final String questionText;
  final String type; // 'multiple_choice' or 'essay'
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? optionE;
  final String? correctAnswer;
  final int points;

  ExamQuestionModel({
    required this.id,
    required this.examId,
    required this.questionNumber,
    required this.questionText,
    required this.type,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.optionE,
    this.correctAnswer,
    this.points = 10,
  });

  factory ExamQuestionModel.fromJson(Map<String, dynamic> json) {
    return ExamQuestionModel(
      id: json['id'] as String,
      examId: json['exam_id'] as String? ?? '',
      questionNumber: json['question_number'] as int? ?? 1,
      questionText: json['question_text'] as String? ?? '',
      type: json['type'] as String? ?? 'multiple_choice',
      optionA: json['option_a'] as String?,
      optionB: json['option_b'] as String?,
      optionC: json['option_c'] as String?,
      optionD: json['option_d'] as String?,
      optionE: json['option_e'] as String?,
      correctAnswer: json['correct_answer'] as String?,
      points: json['points'] as int? ?? 10,
    );
  }
}

class ExamResultModel {
  final String id;
  final String examId;
  final String studentId;
  final double score;
  final String status;
  final Map<String, dynamic> answersJson;
  final DateTime startedAt;
  final DateTime? submittedAt;

  ExamResultModel({
    required this.id,
    required this.examId,
    required this.studentId,
    required this.score,
    required this.status,
    required this.answersJson,
    required this.startedAt,
    this.submittedAt,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      id: json['id'] as String,
      examId: json['exam_id'] as String? ?? '',
      studentId: json['student_id'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'completed',
      answersJson: (json['answers_json'] as Map<String, dynamic>?) ?? {},
      startedAt: json['started_at'] != null 
          ? DateTime.parse(json['started_at'] as String) 
          : DateTime.now(),
      submittedAt: json['submitted_at'] != null 
          ? DateTime.parse(json['submitted_at'] as String) 
          : null,
    );
  }
}

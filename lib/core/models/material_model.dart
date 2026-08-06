class MaterialModel {
  final String id;
  final String teacherId;
  final String classId;
  final String subjectId;
  final String title;
  final String? description;
  final String type; // 'pdf' or 'video'
  final String fileUrl;
  final String? videoUrl;
  final int estimatedReadMinutes;
  final DateTime createdAt;

  MaterialModel({
    required this.id,
    required this.teacherId,
    required this.classId,
    required this.subjectId,
    required this.title,
    this.description,
    required this.type,
    required this.fileUrl,
    this.videoUrl,
    this.estimatedReadMinutes = 10,
    required this.createdAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as String,
      teacherId: json['teacher_id'] as String? ?? '',
      classId: json['class_id'] as String? ?? '',
      subjectId: json['subject_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'pdf',
      fileUrl: json['file_url'] as String? ?? '',
      videoUrl: json['video_url'] as String?,
      estimatedReadMinutes: json['estimated_read_minutes'] as int? ?? 10,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

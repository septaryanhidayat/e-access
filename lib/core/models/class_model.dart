class ClassModel {
  final String id;
  final String name;
  final int grade;
  final String major;

  ClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.major,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      grade: json['grade'] as int? ?? 10,
      major: json['major'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'major': major,
    };
  }
}

class ClassScheduleModel {
  final String id;
  final String classId;
  final String subjectId;
  final String teacherId;
  final int dayOfWeek; // 1-7
  final String startTime;
  final String endTime;
  final String? className;
  final String? subjectName;

  ClassScheduleModel({
    required this.id,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.className,
    this.subjectName,
  });

  factory ClassScheduleModel.fromJson(Map<String, dynamic> json) {
    return ClassScheduleModel(
      id: json['id'] as String,
      classId: json['class_id'] as String,
      subjectId: json['subject_id'] as String,
      teacherId: json['teacher_id'] as String,
      dayOfWeek: json['day_of_week'] as int? ?? 1,
      startTime: json['start_time'] as String? ?? '08:00',
      endTime: json['end_time'] as String? ?? '09:30',
      className: json['classes']?['name'] as String?,
      subjectName: json['subjects']?['name'] as String?,
    );
  }
}

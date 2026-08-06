class AttendanceModel {
  final String id;
  final String scheduleId;
  final String studentId;
  final String status; // 'hadir', 'izin', 'sakit', 'alpa'
  final String? notes;
  final DateTime timestamp;
  final String? studentName;
  final String? subjectName;

  AttendanceModel({
    required this.id,
    required this.scheduleId,
    required this.studentId,
    required this.status,
    this.notes,
    required this.timestamp,
    this.studentName,
    this.subjectName,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String,
      scheduleId: json['schedule_id'] as String? ?? '',
      studentId: json['student_id'] as String? ?? '',
      status: json['status'] as String? ?? 'hadir',
      notes: json['notes'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      studentName: json['users']?['name'] as String?,
      subjectName: json['class_schedules']?['subjects']?['name'] as String?,
    );
  }
}

class ActivityLogModel {
  final String id;
  final String userId;
  final String? materialId;
  final String actionType; // 'read_pdf', 'watch_video', 'login', 'logout', 'cbt_submit'
  final int durationSeconds;
  final DateTime createdAt;

  ActivityLogModel({
    required this.id,
    required this.userId,
    this.materialId,
    required this.actionType,
    this.durationSeconds = 0,
    required this.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      materialId: json['material_id'] as String?,
      actionType: json['action_type'] as String? ?? 'read_pdf',
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

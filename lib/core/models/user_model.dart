class UserModel {
  final String id;
  final String email;
  final String name;
  final String role; // Super Admin, Admin, Guru, Siswa
  final String? identifier; // NIP / NISN
  final String? phone;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.identifier,
    this.phone,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? 'Pengguna',
      role: json['role'] as String? ?? 'Siswa',
      identifier: json['identifier'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'identifier': identifier,
      'phone': phone,
      'avatar_url': avatarUrl,
    };
  }
}

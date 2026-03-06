// lib/models/user_model.dart

enum UserRole { client, midwife }

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final String? birthday;
  final String? illnesses;
  final String? allergies;
  final String? timeOfPregnancy;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.birthday,
    this.illnesses,
    this.allergies,
    this.timeOfPregnancy,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] == 'midwife' ? UserRole.midwife : UserRole.client,
      birthday: json['birthday'],
      illnesses: json['illnesses'],
      allergies: json['allergies'],
      timeOfPregnancy: json['time_of_pregnancy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role == UserRole.midwife ? 'midwife' : 'client',
      'birthday': birthday,
      'illnesses': illnesses,
      'allergies': allergies,
      'time_of_pregnancy': timeOfPregnancy,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    UserRole? role,
    String? birthday,
    String? illnesses,
    String? allergies,
    String? timeOfPregnancy,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      birthday: birthday ?? this.birthday,
      illnesses: illnesses ?? this.illnesses,
      allergies: allergies ?? this.allergies,
      timeOfPregnancy: timeOfPregnancy ?? this.timeOfPregnancy,
    );
  }
}

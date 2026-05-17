import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role = 'client',
  });

  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [id, name, email, phone, role];
}

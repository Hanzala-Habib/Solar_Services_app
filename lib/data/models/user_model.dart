
class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final bool access;
  final String address;

  UserModel( {
    required this.id,
    required this.address,
    required this.email,
    required this.name,
    required this.role,
    required this.access,

  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'Student',
      access: map['access'] == null ? true : map['access'] as bool,
      address: map['address'] ?? ''
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role,
    'access': access,
    'address':address
  };
}

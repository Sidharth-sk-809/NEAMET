class User {
  final String id;
  final String email;
  final String role; // 'customer' or 'employee'
  final String? name;
  final String? phone;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'customer',
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'phone': phone,
    };
  }
}

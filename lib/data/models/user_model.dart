class User {
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phone;
  final String address;

  User({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
  });

  // Convert User object to Map for database
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  // Convert Map from database to User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      password: map['password'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
    );
  }

  // Create a copy of User with modified fields
  User copyWith({
    String? username,
    String? password,
    String? fullName,
    String? email,
    String? phone,
    String? address,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  @override
  String toString() {
    return 'User(username: $username, fullName: $fullName, email: $email, phone: $phone)';
  }
}

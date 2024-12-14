class User {
  final int? userId;  
  final String username;
  final String email;
  final String password;
  final String? fullName; 
  final DateTime createdAt;  

  // Constructor cho User
  User({
    this.userId,
    required this.username,
    required this.email,
    required this.password,
    this.fullName,
    required this.createdAt,
  });

  // Phương thức để chuyển đổi từ đối tượng JSON (khi lấy dữ liệu từ API hoặc database) thành đối tượng User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      fullName: json['full_name'],
      createdAt: DateTime.parse(json['created_at']), // Chuyển đổi chuỗi ngày giờ thành DateTime
    );
  }

  // Phương thức để chuyển đổi đối tượng User thành JSON (nếu cần gửi dữ liệu lên API)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'password': password,
      'full_name': fullName,
      'created_at': createdAt.toIso8601String(), // Chuyển đổi DateTime thành chuỗi ISO 8601
    };
  }
}

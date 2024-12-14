import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;

  String? get token => _token;
  String? get userId => _userId;

  bool get isAuthenticated => _userId != null; // Kiểm tra xem người dùng đã đăng nhập chưa

  Future<void> login(String email, String password) async {
    try {
      _token = await AuthService().login(email, password);
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString('user_id'); // Lấy userId từ SharedPreferences
      notifyListeners(); // Cập nhật UI khi token và userId thay đổi
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    // Lấy SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id'); // Xóa user_id
    await prefs.remove('token'); // Xóa token nếu lưu trong SharedPreferences
    _token = null;
    _userId = null;
    notifyListeners();
  }

  // Hàm tải lại thông tin đăng nhập nếu đã có sẵn trong SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');
    _token = prefs.getString('token');
    notifyListeners();
  }
}

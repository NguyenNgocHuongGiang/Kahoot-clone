import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkUserLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  return token != null; // Nếu có token, tức là người dùng đã đăng nhập
}

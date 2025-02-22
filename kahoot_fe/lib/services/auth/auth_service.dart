import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kahoot_clone/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      String token = response.body;
      // Decode token để lấy thông tin userId
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Lưu token và userId vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', decodedToken['data']['userId'].toString()); // Lưu userId
      await prefs.setString('token', token); // Lưu token

      return token;
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

  Future<void> register(String fullname, String username, String email, String password) async {
    await http.post(
      Uri.parse('${Constants.BASE_URL}auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'full_name': fullname,
        'username': username,
        'email': email,
        'password': password,
      }),
    );

  }
}

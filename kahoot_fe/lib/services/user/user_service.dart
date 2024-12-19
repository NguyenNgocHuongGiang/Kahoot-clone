import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kahoot_clone/common/constants.dart';

class UserService {
  Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences.');
    }

    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}user/get-user/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

Future<Map<String, dynamic>> updateUser(Map<String, dynamic> updatedData) async {
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('user_id');

  if (userId == null) {
    throw Exception('User ID not found in SharedPreferences.');
  }

  final response = await http.put(
    Uri.parse('${Constants.BASE_URL}user/$userId'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(updatedData),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    final errorResponse = json.decode(response.body);
    throw Exception(errorResponse['message']);
  }
}

}

import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/user/user_service.dart';

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _email = '';
  String _full_name = '';
  String _password = '';
  String _avatar = '';
  String _phone = '';
  bool _isLoading = true;
  String _errorMessage = '';

  String get username => _username;
  String get email => _email;
  String get full_name => _full_name;
  String get password => _password;
  String get avatar => _avatar;
  String get phone => _phone;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  UserProvider() {
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      _isLoading = true;
      notifyListeners();

      final userInfo = await UserService().getUserInfo();
      _username = userInfo['username'] ?? '';
      _email = userInfo['email'] ?? '';
      _full_name = userInfo['full_name'] ?? '';
      _password = userInfo['password'] ?? '';
      _avatar = userInfo['avatar'] ?? '';
      _phone = userInfo['phone'] ?? '';
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Lỗi: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateUserInfo(String username, String email) {
    _username = username;
    _email = email;
    notifyListeners();
  }
}

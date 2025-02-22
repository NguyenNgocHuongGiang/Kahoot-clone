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
  List<dynamic> _users = [];
  List<dynamic> _topUsers = [];

  String get username => _username;
  String get email => _email;
  String get full_name => _full_name;
  String get password => _password;
  String get avatar => _avatar;
  String get phone => _phone;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<dynamic> get users => _users;
  List<dynamic> get topUsers => _topUsers;

  UserProvider() {
    fetchUserInfo();
    updateUserInfo();
    fetchAllUsers();
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

  Future<void> updateUserInfo({
    String? username,
    String? email,
    String? full_name,
    String? password,
    String? phone,
  }) async {
    final Map<String, dynamic> updatedData = {};

    if (username != null) updatedData['username'] = username;
    if (email != null) updatedData['email'] = email;
    if (full_name != null) updatedData['full_name'] = full_name;
    if (password != null) updatedData['password'] = password;
    if (phone != null) updatedData['phone'] = phone;

    if (updatedData.isEmpty) return; // No updates to make

    print(updatedData);
    try {
      // Call the service function here
      final response = await UserService().updateUser(updatedData);

      // Update local state with successful server response
      if (response.containsKey('username')) _username = response['username'];
      if (response.containsKey('email')) _email = response['email'];
      if (response.containsKey('full_name')) _full_name = response['full_name'];
      if (response.containsKey('password')) _password = response['password'];
      if (response.containsKey('phone')) _phone = response['phone'];

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      print('Error updating user info: $e');
      throw e;
    }
  }

  Future<void> updateUserAvatar({
    String? avatar,
  }) async {
    final Map<String, dynamic> updatedData = {};

    if (avatar != null) updatedData['avatar'] = avatar;

    if (updatedData.isEmpty) return; // No updates to make

    try {
      // Call the service function here
      final response = await UserService().updateUser(updatedData);

      print(response);

      // Update local state with successful server response
      if (response.containsKey('avatar')) _avatar = response['avatar'];

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      print('Error updating user info: $e');
      throw e;
    }
  }

  Future<void> fetchAllUsers() async {
    try {
      _isLoading = true;
      notifyListeners();

      final allUsers = await UserService().getAllUsers();
      _users = allUsers;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Lỗi khi lấy danh sách người dùng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopUsers() async {
  try {
    _isLoading = true;
    notifyListeners();

    final allUsers = await UserService().getTopUsers();
    
    if (allUsers.isNotEmpty) {
      _topUsers = allUsers;
    } else {
      _errorMessage = 'Không có top users nào!';
    }

  } catch (e) {
    _errorMessage = 'Lỗi khi lấy top users: $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}

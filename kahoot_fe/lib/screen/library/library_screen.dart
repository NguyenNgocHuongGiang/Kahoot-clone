import 'package:flutter/material.dart';
import 'package:kahoot_clone/providers/auth_provider.dart'; // Import trang Profile
import 'package:kahoot_clone/screen/library/user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:kahoot_clone/common/common.dart';
import 'package:kahoot_clone/components/notification_login_modal.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _currentPage = 'Library'; // Mặc định là Library

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentPage,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0,
        leading: _currentPage != 'Library'
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    _currentPage = 'Library'; // Quay lại Library
                  });
                },
              )
            : null,
        automaticallyImplyLeading: false,
      ),
      body: _getPageContent(),
    );
  }

  // Hàm trả về nội dung tương ứng với từng trang
  Widget _getPageContent() {
    switch (_currentPage) {
      case 'Profile':
        return Profile(onSave: () {
          setState(() {
            _currentPage = 'Library';
          });
        });

      default:
        return _buildLibrary();
    }
  }

  // Hàm xây dựng giao diện Library
  Widget _buildLibrary() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Mục thông tin người dùng
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.deepPurple),
            title: const Text('Profile'),
            onTap: () async {
              final isLoggedIn = await checkUserLoginStatus();
              if (isLoggedIn) {
                setState(() {
                  _currentPage = 'Profile';
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const NotificationLoginModal(
                      message: 'You must login before view profile',
                    );
                  },
                );
              }
            },
          ),
          const Divider(),

          // Mục đăng xuất
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}

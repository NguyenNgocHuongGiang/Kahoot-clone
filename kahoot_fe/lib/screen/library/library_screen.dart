import 'package:flutter/material.dart';
import 'package:kahoot_clone/providers/auth_provider.dart'; // Import trang Profile
import 'package:kahoot_clone/screen/library/my_groups_screen.dart';
import 'package:kahoot_clone/screen/library/my_quizzies_screen.dart';
import 'package:kahoot_clone/screen/library/user_profile_screen.dart';
import 'package:kahoot_clone/screen/library/history_screen.dart'; // Import màn hình History mới
import 'package:provider/provider.dart';
import 'package:kahoot_clone/common/common.dart';
import 'package:kahoot_clone/components/notification_login_modal.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _currentPage = 'Library';

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
    final userId = context.watch<AuthProvider>().userId;
    switch (_currentPage) {
      case 'Profile':
        return userId != null
            ? Profile(
                onSave: () {
                  setState(() {
                    _currentPage = 'Library';
                  });
                },
                userId: userId!,
              )
            : const Center(child: Text('User ID is null'));

      case 'My Quizzies':
        return MyQuizziesScreen(onSave: () {
          setState(() {
            _currentPage = 'Library';
          });
        });

      case 'My Groups':
        return MyGroupsScreen(onSave: () {
          setState(() {
            _currentPage = 'Library';
          });
        });

      case 'History': // Xử lý khi người dùng chọn History
        return const HistoryScreen(); // Trả về màn hình History

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
                // Delay setState to avoid calling it during the build phase
                Future.delayed(Duration.zero, () {
                  setState(() {
                    _currentPage = 'Profile';
                  });
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

          // Mục My Quizzies
          ListTile(
            leading: const Icon(Icons.quiz_outlined, color: Colors.green),
            title: const Text('My Quizzies'),
            onTap: () async {
              final isLoggedIn = await checkUserLoginStatus();
              if (isLoggedIn) {
                // Delay setState to avoid calling it during the build phase
                Future.delayed(Duration.zero, () {
                  setState(() {
                    _currentPage = 'My Quizzies';
                  });
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const NotificationLoginModal(
                      message: 'You must login before view your quizzies',
                    );
                  },
                );
              }
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.group, color: Colors.blue),
            title: const Text('My Groups'),
            onTap: () async {
              final isLoggedIn = await checkUserLoginStatus();
              if (isLoggedIn) {
                Future.delayed(Duration.zero, () {
                  setState(() {
                    _currentPage = 'My Groups';
                  });
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const NotificationLoginModal(
                      message: 'You must login before view your groups',
                    );
                  },
                );
              }
            },
          ),
          const Divider(),

          // Mục History
          ListTile(
            leading: const Icon(Icons.history, color: Colors.orange),
            title: const Text('History'),
            onTap: () async {
              final isLoggedIn = await checkUserLoginStatus();
              if (isLoggedIn) {
                // Delay setState to avoid calling it during the build phase
                Future.delayed(Duration.zero, () {
                  setState(() {
                    _currentPage = 'History'; // Chuyển sang màn hình History
                  });
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const NotificationLoginModal(
                      message: 'You must login before view your history',
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

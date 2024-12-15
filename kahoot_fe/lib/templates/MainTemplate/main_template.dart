import 'package:flutter/material.dart';
import 'package:kahoot_clone/providers/auth_provider.dart';
import 'package:kahoot_clone/view/discovery/discovery_page.dart';
import 'package:kahoot_clone/view/home/homepage.dart';
import 'package:kahoot_clone/view/quiz/create_quiz.dart';
import 'package:kahoot_clone/view/quiz/join_quiz.dart';
import 'package:kahoot_clone/view/user/user.dart';
import 'package:provider/provider.dart';

class MainTemplate extends StatefulWidget {
  const MainTemplate({super.key});

  @override
  State<MainTemplate> createState() => _MainTemplateState();
}

class _MainTemplateState extends State<MainTemplate> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomePage(),
    const DiscoveryPage(),
    const JoinQuizPage(),
    const CreateQuizPage(),
    const UserPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Tải lại thông tin người dùng từ SharedPreferences nếu có
    context.read<AuthProvider>().loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discovery',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/logo.png',
              width: 24.0,
              height: 24.0,
            ),
            label: 'Join',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: authProvider.isAuthenticated
                ? CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                    child: Text(authProvider.userId![0].toUpperCase(), style: const TextStyle(
                      fontSize: 14.0
                    ),), // Hiển thị chữ cái đầu tiên của tên
                  )
                : const Icon(Icons.login), // Biểu tượng mặc định nếu chưa đăng nhập
            label: authProvider.isAuthenticated ? 'User' : 'Library', // Hiển thị tên người dùng hoặc 'Login'
          ),
        ],
      ),
    );
  }
}

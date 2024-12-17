import 'package:flutter/material.dart';
import 'package:kahoot_clone/providers/auth_provider.dart';
import 'package:kahoot_clone/screen/discovery/discovery_screen.dart';
import 'package:kahoot_clone/screen/home/home_screen.dart';
import 'package:kahoot_clone/screen/quiz/create_quiz_screen.dart';
import 'package:kahoot_clone/screen/quiz/join_quiz_screen.dart';
import 'package:kahoot_clone/screen/library/library_screen.dart';
import 'package:provider/provider.dart';

class MainTemplate extends StatefulWidget {
  final int initialIndex; // Thêm tham số để chọn tab khởi tạo
  const MainTemplate({super.key, this.initialIndex = 0});

  @override
  State<MainTemplate> createState() => _MainTemplateState();
}

class _MainTemplateState extends State<MainTemplate> {
  late int _currentIndex;

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
    _currentIndex = widget.initialIndex; // Đặt tab khởi tạo từ tham số
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
                    child: Text(
                      authProvider.userId![0].toUpperCase(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  )
                : const Icon(Icons.local_library_outlined),
            label: authProvider.isAuthenticated ? 'User' : 'Library',
          ),
        ],
      ),
    );
  }
}

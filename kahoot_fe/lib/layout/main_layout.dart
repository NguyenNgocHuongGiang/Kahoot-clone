import 'package:flutter/material.dart';
import 'package:kahoot_clone/providers/auth_provider.dart';
import 'package:kahoot_clone/screen/discovery/discovery_screen.dart';
import 'package:kahoot_clone/screen/home/home_screen.dart';
import 'package:kahoot_clone/screen/quiz/create_quiz_screen.dart';
import 'package:kahoot_clone/screen/quiz/join_quiz_screen.dart';
import 'package:kahoot_clone/screen/library/library_screen.dart';
import 'package:provider/provider.dart';

class MainTemplate extends StatefulWidget {
  final int initialIndex;
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
    const LibraryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    context.read<AuthProvider>().loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 600;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: isWideScreen
              ? AppBar(
                  backgroundColor: Colors.grey[100],
                  centerTitle: true, // Căn giữa title
                  title: const Text('Quiz Fox', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 350.0, vertical: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMenuItem(0, Icons.home, 'Home'),
                          _buildMenuItem(1, Icons.explore, 'Discovery'),
                          _buildMenuItem(2, Icons.play_arrow, 'Join'),
                          _buildMenuItem(3, Icons.create, 'Create'),
                          _buildMenuItem(
                            4,
                            authProvider.isAuthenticated
                                ? Icons.person
                                : Icons.local_library,
                            authProvider.isAuthenticated ? 'User' : 'Library',
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : null,
          body: _tabs[_currentIndex],
          bottomNavigationBar: isWideScreen
              ? null
              : BottomNavigationBar(
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
      },
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      icon:
          Icon(icon, color: _currentIndex == index ? Colors.red : Colors.black),
      label: Text(label,
          style: TextStyle(
              color: _currentIndex == index ? Colors.red : Colors.black)),
    );
  }
}

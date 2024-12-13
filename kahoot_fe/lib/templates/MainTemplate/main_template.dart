import 'package:flutter/material.dart';
import 'package:kahoot_clone/view/discovery/discovery_page.dart';
import 'package:kahoot_clone/view/home/homepage.dart';
import 'package:kahoot_clone/view/quiz/create_quiz.dart';
import 'package:kahoot_clone/view/quiz/join_quiz.dart';
import 'package:kahoot_clone/view/user/user.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Quiz Fox',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }
}

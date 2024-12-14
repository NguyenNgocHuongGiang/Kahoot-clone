import 'package:flutter/material.dart';
import 'package:kahoot_clone/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
        actions: [
          // Nút đăng xuất
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => {
              context.read<AuthProvider>().logout(),
               Navigator.pushReplacementNamed(context, '/')
            }, // Gọi phương thức đăng xuất
          ),
        ],
      ),
      body: const Center(
        child: Text('UserPage tab'),
      ),
    );
  }
}

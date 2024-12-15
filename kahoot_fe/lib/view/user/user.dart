import 'package:flutter/material.dart';
import 'package:kahoot_clone/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Mục thông tin người dùng
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Quiz Fox information'),
              onTap: () {
                // Chuyển sang trang cập nhật thông tin
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateUserInfoPage()),
                );
              },
            ),
            const Divider(), 

            // Mục đăng xuất
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Logout'),
              onTap: () => {
              context.read<AuthProvider>().logout(),
               Navigator.pushReplacementNamed(context, '/')
            }, 
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateUserInfoPage extends StatelessWidget {
  const UpdateUserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật thông tin người dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Chỉnh sửa thông tin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Lưu thông tin cập nhật và quay lại trang trước
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thông tin đã được cập nhật')),
                );
                Navigator.pop(context); // Quay lại trang cũ
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}

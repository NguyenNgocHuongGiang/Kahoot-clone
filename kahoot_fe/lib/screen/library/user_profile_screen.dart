import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:kahoot_clone/providers/user_provider.dart';

class Profile extends StatelessWidget {
  final VoidCallback onSave;

  const Profile({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.errorMessage.isNotEmpty) {
      return Center(child: Text(userProvider.errorMessage));
    }

    final usernameController =
        TextEditingController(text: userProvider.username);
    final emailController = TextEditingController(text: userProvider.email);
    final fullNameController =
        TextEditingController(text: userProvider.full_name);
    final passwordController =
        TextEditingController(text: userProvider.password);
    final phoneController = TextEditingController(text: userProvider.phone);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            
            // Avatar
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedImage != null) {
                  // userProvider.updateAvatar(pickedImage.path); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ảnh đại diện đã được thay đổi')
                        )
                    );
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: userProvider.avatar.isNotEmpty
                    ? NetworkImage(userProvider.avatar)
                    : const NetworkImage('assets/images/default-avatar.jpg')
                        as ImageProvider,
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Fullname 
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Fullname',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email 
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password 
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Username 
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Phone number 
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Save Button
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final updatedData = {
                    'username': usernameController.text,
                    'email': emailController.text,
                    'full_name': fullNameController.text,
                    'password': passwordController.text,
                    'phone': phoneController.text,
                  };

                  // Cập nhật vào provider
                  try {
                    userProvider.updateUserInfo(
                      username: updatedData['username']!,
                      email: updatedData['email']!,
                      full_name: updatedData['full_name']!,
                      password: updatedData['password']!,
                      phone: updatedData['phone']!,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Update successfully')),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: $error')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

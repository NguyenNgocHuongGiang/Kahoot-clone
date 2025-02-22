import 'package:flutter/material.dart';
import 'package:kahoot_clone/layout/auth_layout.dart'; // Giả sử AuthTemplate có trong layout này
import 'package:kahoot_clone/screen/authentication/login_screen.dart';
import 'package:kahoot_clone/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Hàm đăng ký người dùng
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final fullname = _fullNameController.text;
        final username = _usernameController.text;
        final email = _emailController.text;
        final password = _passwordController.text;

        await AuthService().register(fullname, username, email, password);

         Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ); // 
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại. Vui lòng thử lại!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600; // Xác định nếu là web
    double width = MediaQuery.of(context).size.width;

    return AuthTemplate(
      title: 'Create an account',
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            // Full Name input
            SizedBox(
              width: width > 600
                  ? 400
                  : width *
                      0.8, // Đảm bảo chiều rộng vừa phải trên màn hình nhỏ
              child: TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                style: TextStyle(fontSize: 14), // Giảm kích thước font chữ
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12.0), // Giảm khoảng cách giữa các input

            // Username input
            SizedBox(
              width: width > 600
                  ? 400
                  : width *
                      0.8, // Đảm bảo chiều rộng vừa phải trên màn hình nhỏ
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.person_add),
                ),
                style: TextStyle(fontSize: 14), // Giảm kích thước font chữ
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 12.0), // Giảm khoảng cách giữa các input

            // Email input
            SizedBox(
              width: width > 600
                  ? 400
                  : width *
                      0.8, // Đảm bảo chiều rộng vừa phải trên màn hình nhỏ
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                style: TextStyle(fontSize: 14), // Giảm kích thước font chữ
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12.0), // Giảm khoảng cách giữa các input

            // Password input
            SizedBox(
              width: width > 600
                  ? 400
                  : width *
                      0.8, // Đảm bảo chiều rộng vừa phải trên màn hình nhỏ
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                style: TextStyle(fontSize: 14), // Giảm kích thước font chữ
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12.0), // Giảm khoảng cách giữa các input

            // Register button
            SizedBox(
              width: isWeb
                  ? 400
                  : width * 0.8, // Điều chỉnh kích thước button cho web
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Sign up',
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
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account? "),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ); // Quay lại trang đăng nhập
            },
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AuthTemplate extends StatelessWidget {
  final String title; // Tiêu đề cho trang (e.g., "Welcome back!" hoặc "Create an account")
  final Widget content; // Nội dung chính của trang
  final Widget? footer; // Phần footer tùy chọn (e.g., chuyển hướng đến trang khác)

  const AuthTemplate({
    super.key,
    required this.title,
    required this.content,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo và tiêu đề
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: size.width * 0.3,
                    height: size.width * 0.3,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Nội dung chính
              const SizedBox(height: 24.0),
              content,

              // Footer tùy chọn
              if (footer != null) ...[
                const SizedBox(height: 16.0),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

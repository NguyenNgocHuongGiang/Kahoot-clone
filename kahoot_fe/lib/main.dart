import 'package:flutter/material.dart';
import 'package:kahoot_clone/providers/auth_provider.dart';
import 'package:kahoot_clone/providers/quiz_provider.dart';
import 'package:kahoot_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuizProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // tat debug tren goc
      initialRoute: AppRoutes.home, // Đặt màn hình đầu tiên là LoginPage
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

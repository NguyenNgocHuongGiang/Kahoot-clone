import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // tat debug tren goc
      // theme: ThemeData(
      //   primarySwatch: const Color.fromARGB(255, 255, 111, 0),
      // ),
      initialRoute: AppRoutes.login, // Đặt màn hình đầu tiên là LoginPage
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

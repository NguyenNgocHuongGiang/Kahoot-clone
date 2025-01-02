import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:kahoot_clone/providers/auth_provider.dart';
import 'package:kahoot_clone/providers/quiz_provider.dart';
import 'package:kahoot_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()), // Provider cho Quiz
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Provider cho Auth
        ChangeNotifierProvider(create: (_) => UserProvider()), // Provider cho User
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), 
      minTextAdapt: true, 
      splitScreenMode: true, 
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false, 
          initialRoute: AppRoutes.home, 
          onGenerateRoute: AppRoutes.generateRoute, 
          theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity, 
          ),
        );
      },
    );
  }
}

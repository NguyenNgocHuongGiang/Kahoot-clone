import 'package:flutter/material.dart';
import 'package:kahoot_clone/templates/MainTemplate/main_template.dart';
// import 'package:kahoot_clone/view/home/homepage.dart';

class AppRoutes {
  static const String home = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) =>  const MainTemplate());
      // Add other routes here
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

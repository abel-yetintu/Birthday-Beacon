import 'package:birthday_beacon/data/models/birthday.dart';
import 'package:birthday_beacon/ui/screens/add_birthday_screen.dart';
import 'package:birthday_beacon/ui/screens/edit_birthday_screen.dart';
import 'package:birthday_beacon/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case '/addBirthday':
        return MaterialPageRoute(builder: (context) => const AddBirthdayScreen());
      case '/editBirthday':
        if (args is Birthday) {
          return MaterialPageRoute(builder: (context) => EditBirthdayScreen(birthday: args));
        } else {
          return _errorRoute();
        }
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No route found."),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppStartUpErrorScreen extends StatelessWidget {
  final void Function()? onRetry;
  const AppStartUpErrorScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 95, 88, 84),
        body: Center(
            child: Column(
          children: [
            GestureDetector(
              onTap: onRetry,
              child: const FaIcon(
                FontAwesomeIcons.rotateRight,
                color: Color.fromARGB(255, 239, 233, 218),
              ),
            )
          ],
        )),
      ),
    );
  }
}

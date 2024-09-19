import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppStartUpLoadingScreen extends StatelessWidget {
  const AppStartUpLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 95, 88, 84),
        body: Center(
          child: SpinKitPulsingGrid(
            color: Color.fromARGB(255, 239, 233, 218),
          ),
        ),
      ),
    );
  }
}

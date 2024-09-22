import 'package:birthday_beacon/app_start_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    const ProviderScope(
      child: AppStartUp(),
    ),
  );
}

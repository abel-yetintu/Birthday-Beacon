import 'package:birthday_beacon/core/navigation/route_generator.dart';
import 'package:birthday_beacon/providers/theme_notifier.dart';
import 'package:birthday_beacon/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    const ProviderScope(
      child: BirthdayBeacon(),
    ),
  );
}

class BirthdayBeacon extends ConsumerWidget {
  const BirthdayBeacon({super.key});

  @override
  Widget build(BuildContext context, ref) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;
    TextTheme textTheme = GoogleFonts.getTextTheme('Roboto Slab', baseTextTheme);
    AppTheme appTheme = AppTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(themeNotifierProvider),
      theme: appTheme.light(),
      darkTheme: appTheme.dark(),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
    );
  }
}

import 'package:birthday_beacon/core/navigation/route_generator.dart';
import 'package:birthday_beacon/core/theme/app_theme.dart';
import 'package:birthday_beacon/providers/providers.dart';
import 'package:birthday_beacon/providers/theme_notifier.dart';
import 'package:birthday_beacon/ui/screens/app_start_up_error_screen.dart';
import 'package:birthday_beacon/ui/screens/app_start_up_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStartUp extends ConsumerWidget {
  const AppStartUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartUpState = ref.watch(appStartUpProvider);
    return appStartUpState.when(
      skipLoadingOnRefresh: false,
      loading: () => const AppStartUpLoadingScreen(),
      error: (error, stackTrace) => AppStartUpErrorScreen(
        error: error.toString(),
        onRetry: () => ref.invalidate(appStartUpProvider),
      ),
      data: (data) => const BirthdayBeacon(),
    );
  }
}

class BirthdayBeacon extends ConsumerWidget {
  const BirthdayBeacon({super.key});

  @override
  Widget build(BuildContext context, ref) {
    TextTheme textTheme = Theme.of(context).textTheme.apply(fontFamily: 'Roboto Slab');
    AppTheme appTheme = AppTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(themeNotifierProvider),
      theme: appTheme.light(),
      darkTheme: appTheme.dark(),
      navigatorKey: ref.watch(navigatorKeyProvider),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
    );
  }
}

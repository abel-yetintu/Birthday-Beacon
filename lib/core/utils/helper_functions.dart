import 'package:flutter/material.dart';

class HelperFunctions {
  final GlobalKey<NavigatorState> navigatorKey;

  HelperFunctions({required this.navigatorKey});

  int generateBirthdayNotificationId(int birthdayId, int index) {
    return birthdayId * 10 + index;
  }

  void showSnackBar({required String message}) {
    BuildContext context = navigatorKey.currentState!.context;
    ThemeData theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationService({required this.navigatorKey});

  dynamic routeTo(String route, {dynamic arguments}) {
    return navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  dynamic goBack() {
    return navigatorKey.currentState?.pop();
  }
}

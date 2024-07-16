import 'package:chatdo/views/auth/login_view.dart';
import 'package:chatdo/views/auth/register_view.dart';
import 'package:chatdo/views/home/home_view.dart';
import 'package:flutter/material.dart';

class NavigationServices {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navKey => _navKey;
  NavigationServices();

  Map<String, Widget Function(BuildContext context)> routes() {
    return {
      '/login': (context) => const LoginView(),
      '/home': (context) => const HomeView(),
      '/register': (context) => const RegisterView()
    };
  }

  void pushNamed(String routeName) {
    _navKey.currentState?.pushNamed(routeName);
  }

  void pushNamedAndReplace(String routeName) {
    _navKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() => _navKey.currentState?.pop();

  void pushRoute(MaterialPageRoute route) {
    _navKey.currentState?.push(route);
  }
}

import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/setup.dart';
import 'package:chatdo/utils/themes/app_theme.dart';
import 'package:chatdo/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'views/auth/login_view.dart';

void main() async {
  await setUpProject();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late final NavigationServices navService;
  late final AuthServices authService;

  //
  MyApp({super.key}) {
    navService = _getIt.get<NavigationServices>();
    authService = _getIt.get<AuthServices>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navService.navKey,
      title: 'chatdo',
      debugShowCheckedModeBanner: false,
      routes: navService.routes(),
      theme: AppTheme.lightTheme(),
      home: authService.currentUser != null
          ? const HomeView()
          : const LoginView(),
    );
  }
}

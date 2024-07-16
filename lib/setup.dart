import 'package:chatdo/firebase_options.dart';
import 'package:chatdo/services/alert_servivces.dart';
import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/services/storage_services.dart';
import 'package:chatdo/utils/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'dart:developer' as d;

Future<void> setUpProject() async {
  await setupFirebase();
  initServices();
}

Future<void> setupFirebase() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    d.log('firebase initialised successfully');
  } catch (e) {
    Logger().i("$error:$e");
  }
}

void initServices() {
  try {
    GetIt getIt = GetIt.instance;
    getIt.registerSingleton<AuthServices>(AuthServices());
    getIt.registerSingleton<NavigationServices>(NavigationServices());
    getIt.registerSingleton<AlertServices>(AlertServices());
    getIt.registerSingleton<StorageServices>(StorageServices());
    getIt.registerSingleton<DatabaseServices>(DatabaseServices());
    d.log(logMessage);
  } catch (e) {
    Logger().i("$error:$e");
  }
}

double osHeight(BuildContext context) => MediaQuery.of(context).size.height;
double osWidth(BuildContext context) => MediaQuery.of(context).size.width;

String generateChatId({required String uid1, required String uid2}) {
  final List<String> uids = [uid1, uid2];
  uids.sort();
  return uids.fold("", (uid1, uid2) => "$uid1$uid2");
}

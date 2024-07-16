import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/setup.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

class AlertServices {
  final GetIt _getIt = GetIt.instance;
  late final NavigationServices navServices;

  AlertServices() {
    navServices = _getIt.get<NavigationServices>();
  }

  void showToast({
    required String text,
    IconData icon = Icons.info,
    bool showCloseIcon = false,
  }) {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      snackbarDuration: const Duration(milliseconds: 2000),
      builder: (context) => ToastCard(
        leading: Icon(
          icon,
          size: 28,
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        trailing: showCloseIcon
            ? IconButton(
                onPressed: () => navServices.navKey.currentState?.pop(),
                icon: const Icon(Icons.close))
            : null,
      ),
    ).show(navServices.navKey.currentContext!);
  }

  void showLoadingDialog(String loadingText) async {
    try {
      await showDialog(
          barrierDismissible: false,
          context: navServices.navKey.currentContext!,
          builder: (context) {
            return Container(
              width: osWidth(context),
              height: osHeight(context),
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    loadingText,
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  SpinKitWanderingCubes(
                    size: 35,
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                    duration: const Duration(milliseconds: 1000),
                  )
                ],
              ),
            );
          });
    } catch (e) {
      Logger().i(e);
    }
  }

  void closeLoader() {
    try {
      navServices.navKey.currentState?.pop();
    } catch (e) {
      Logger().i('Error while closing dialog: $e');
    }
  }
}

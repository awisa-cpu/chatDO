import 'package:chatdo/services/alert_servivces.dart';
import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/setup.dart';
import 'package:chatdo/utils/constants.dart';
import 'package:chatdo/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../common/widgets/custom_header_texts.dart';
import '../../common/widgets/custom_na_buttons.dart';
import '../../common/widgets/custom_text_form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GetIt _getIt = GetIt.instance;
  late final AuthServices authService;
  late final NavigationServices navService;
  late final AlertServices alertService;
  late final DatabaseServices dbService;
  String? emailField;
  String? passwordField;

  @override
  void initState() {
    super.initState();
    try {
      authService = _getIt.get<AuthServices>();
      navService = _getIt.get<NavigationServices>();
      alertService = _getIt.get<AlertServices>();
      dbService = _getIt.get<DatabaseServices>();
    } catch (e) {
      Logger().i(e);
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildUi(context));
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //text

            const CustomHeaderTexts(
              mainText: 'Welcome to ChatDO!!',
              subText: 'Please sign in with your credentials',
            ),

            const SizedBox(height: 10),
            //form
            _buildLoginForm(),

            //button to go to sign up
            CustomNavButtons(
              onTap: () => navService.pushNamed('/register'),
              mainText: 'Yet to register?',
              hintText: 'Register here',
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      height: osHeight(context) * 0.40,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //email
            CustomTextFormField(
              hintText: "Email",
              validator: (value) {
                if (value != null && emailReg.hasMatch(value)) {
                  return null;
                }

                return 'email is required';
              },
              onSaved: (value) {
                if (value != null) {
                  setState(() {
                    emailField = value;
                  });
                }
              },
            ),

            //password
            CustomTextFormField(
              hintText: "Password",
              validator: (value) {
                if (value != null && passwordReg.hasMatch(value)) {
                  return null;
                }
                return 'Password is required';
              },
              onSaved: (value) {
                setState(() {
                  passwordField = value;
                });
              },
            ),

            //sign in button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loginUser,
                child: const Text('Login'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _loginUser() async {
    try {
      if (_loginFormKey.currentState?.validate() ?? false) {
        alertService.showLoadingDialog('logging in...');
        _loginFormKey.currentState?.save();

        //
        final authResponse = await authService.loginUserWithEmailAndPassword(
          email: emailField!,
          password: passwordField!,
        );

        //
        if (authResponse) {
          dbService.getCurrentUser(authService.currentUser!.uid);
          alertService.closeLoader();
          alertService.showToast(text: 'Logged in successfully');
          navService.pushNamedAndReplace('/home');
        } else {
          throw Exception('Check credentails');
        }
      }
    } catch (e) {
      alertService.closeLoader();
      Logger().i('$error $e');
      alertService.showToast(text: 'Something went wrong, check credentails');
    }
  }
}

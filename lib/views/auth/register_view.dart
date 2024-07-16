import 'dart:io';

import 'package:chatdo/common/widgets/custom_header_texts.dart';
import 'package:chatdo/common/widgets/custom_na_buttons.dart';
import 'package:chatdo/common/widgets/custom_text_form_field.dart';
import 'package:chatdo/models/user_model.dart';
import 'package:chatdo/services/alert_servivces.dart';
import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/services/storage_services.dart';
import 'package:chatdo/setup.dart';
import 'package:chatdo/utils/constants.dart';
import 'package:chatdo/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //
  String? nameField;
  String? emailField;
  String? passwordField;
  File? selectedImage;
  final GetIt _getIt = GetIt.instance;
  late final NavigationServices navService;
  late final AuthServices authServices;
  late final StorageServices storageService;
  late final AlertServices alertService;
  late final DatabaseServices dbService;
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    try {
      navService = _getIt.get<NavigationServices>();
      storageService = _getIt.get<StorageServices>();
      alertService = _getIt.get<AlertServices>();
      authServices = _getIt.get<AuthServices>();
      dbService = _getIt.get<DatabaseServices>();
    } catch (e) {
      Logger().i("$error: $e");
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const CustomHeaderTexts(
                  mainText: 'Welcome to chatDO!',
                  subText: 'Fill in your details to register'),

              //
              _buildRegisterForm(),

              //
              CustomNavButtons(
                mainText: 'Already have an account?',
                hintText: 'Sign In',
                onTap: () => navService.goBack(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      height: osHeight(context) * 0.70,
      child: Form(
        key: _registerKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //pfp
            InkWell(
              enableFeedback: false,
              splashColor: Colors.transparent,
              onTap: () async {
                final File? imageFile =
                    await storageService.pickImageFromGallery();
                if (imageFile != null) {
                  setState(() {
                    selectedImage = imageFile;
                  });
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 65,
                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!)
                    : const NetworkImage(placeholderPfp),
              ),
            ),

            CustomTextFormField(
              hintText: 'Full Name',
              validator: (value) {
                if (value != null && nameReg.hasMatch(value)) {
                  return null;
                }

                return 'name is required';
              },
              onSaved: (name) {
                setState(() {
                  nameField = name;
                });
              },
            ),

            //email
            CustomTextFormField(
              hintText: "Email",
              validator: (value) {
                if (value != null && emailReg.hasMatch(value)) {
                  return null;
                }

                return 'email is required';
              },
              onSaved: (email) {
                if (email != null) {
                  setState(() {
                    emailField = email;
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
              onSaved: (password) {
                setState(() {
                  passwordField = password;
                });
              },
            ),

            //
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Register'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    try {
      if ((_registerKey.currentState?.validate() ?? false) &&
          selectedImage != null) {
        alertService.showLoadingDialog('Registration in progress...');
        _registerKey.currentState?.save();

        //first regsiter the user
        final bool response = await authServices.registerUser(
          email: emailField!,
          password: passwordField!,
        );

        if (response) {
          //after successful regsitration, upload the image
          final String? downloadUrl = await storageService.uploadUserPfp(
            file: selectedImage!,
            currentUserId: authServices.currentUser!.uid,
          );

          if (downloadUrl != null) {
            //then save user details to firebase
            final UserModel newuser = UserModel(
              uid: authServices.currentUser!.uid,
              name: nameField!,
              pfp: downloadUrl,
              email: emailField!,
            );
            await dbService.createUser(newuser);
            alertService.closeLoader();
            alertService.showToast(text: 'Registration completed successfully');
            navService.pushNamedAndReplace('/home');
          } else {
            Exception('Error while uploading user profile picture');
          }
        } else {
          throw Exception('Error with registration');
        }
      } else {
        alertService.showToast(
            text: 'Ensure to select image and fill all entries');
      }
    } catch (e) {
      alertService.closeLoader();
      Logger().i("$error: $e");
      alertService.showToast(text: "An error occured while registering");
    }
  }
}

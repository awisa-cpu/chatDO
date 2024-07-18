import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

class AuthServices {
  AuthServices() {
    firebaseAuth.authStateChanges().listen(_updateUserState);
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get currentUser => _user;
  final bool authenticatedLocally = false;

  ///login a user
  Future<bool> loginUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredentail = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredentail.user != null) {
        _user = userCredentail.user;
        return true;
      }
    } catch (e) {
      rethrow;
    }

    return false;
  }

  ///lo gout a user
  Future<void> logoutUser() async {
    try {
      if (_user != null) {
        await firebaseAuth.signOut();
        _user = null;
      }
    } catch (e) {
      rethrow;
    }
  }

  void _updateUserState(User? user) => _user = user;

  //register a user
  Future<bool> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      rethrow;
    }
    return false;
  }

  Future<bool> signInWithBiometrics() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canCheckBio = await auth.canCheckBiometrics;
      if (canCheckBio) {
        final bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to login in to the app',
          options: const AuthenticationOptions(
            biometricOnly: false,
          ),
        );

        if (authenticated) {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('Biometrics not supported');
      }
    } catch (e) {
      Logger().i("$e");
    }

    return false;
  }
}

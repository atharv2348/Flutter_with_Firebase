import 'package:firebase_auth/firebase_auth.dart';

class BackEnd {
  static final auth = FirebaseAuth.instance;

  static Future<void> CreateUser(
      {required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  static Future<UserCredential?> SignInUser(
      {required String email, required String password}) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

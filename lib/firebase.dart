import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'global.dart';
import 'classes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {}
    if (_auth.currentUser == null) return false;
    account.id = _auth.currentUser?.uid;
    account.email = _auth.currentUser?.email;
    return true;
  }

  Future<bool> registerEmailPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {}
    if (_auth.currentUser == null) return false;
    account.id = _auth.currentUser?.uid;
    account.email = _auth.currentUser?.email;
    return true;
  }

  Future<bool> resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
    return true;
  }

  void sign() {
    if (_auth.currentUser != null) {
      account.id = _auth.currentUser!.uid;
      account.email = _auth.currentUser!.email;
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

  bool checkSign() {
    return _auth.currentUser != null;
  }

  String? getId() {
    return _auth.currentUser?.uid;
  }

// Stream<User> get currentUser {
//   return _auth.authStateChanges().map((User user) => user != null ? user : null);
// }
}
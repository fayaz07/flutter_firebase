import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseProvider with ChangeNotifier {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseUser currentUser;

  /// Initializes [FirebaseUser] user and returns login status
  static Future<bool> instantiate() async {
    currentUser = await auth.currentUser();
    if (currentUser == null || currentUser.uid == null) {
      return false;
    }
    return true;
  }
}

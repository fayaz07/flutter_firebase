import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/data_models/result.dart';
import 'package:flutter_firebase/providers/firebase.dart';

class AuthProvider with ChangeNotifier {
  bool _showTypeWriter = true;

  /// Logs in user with the provided email and password
  /// then returns if the user has verified his email
  Future<Result<bool>> login({String email, String password}) async {
    try {
      AuthResult authResult = await FirebaseProvider.auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (authResult.user.uid == null) {
        return Result.fail(
            message: "Something has gone wrong, please try later");
      }
      FirebaseProvider.currentUser = authResult.user;
      return Result.success(data: FirebaseProvider.currentUser.isEmailVerified);
    } catch (err) {
      debugPrint(err.toString());
      return Result.exception(message: err.toString());
    }
  }

  /// Registers the user with the provided email and password
  Future<Result<bool>> register({String email, String password}) async {
    try {
      AuthResult authResult = await FirebaseProvider.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (authResult.user.uid == null) {
        return Result.fail(
            message: "Something has gone wrong, please try later");
      }
      FirebaseProvider.currentUser = authResult.user;
      return Result.success(data: FirebaseProvider.currentUser.isEmailVerified);
    } catch (err) {
      debugPrint(err.toString());
      return Result.exception(message: err.toString());
    }
  }

  bool get showTypeWriter => _showTypeWriter;

  set showTypeWriter(bool value) {
    _showTypeWriter = value;
    notifyListeners();
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class FirebasePhoneAuth {

  static var firebaseAuth;

  static var _authCredential, actualCode, phone, status;

  FirebasePhoneAuth(String phoneNumber) {
    phone = phoneNumber;
    instantiate();
  }

  instantiate() async {
    firebaseAuth = await FirebaseAuth.instance;
  }

  static startAuth(){
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  static final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    actualCode = verificationId;
    setState(() {
      print('Code sent to $phone');
      status = "\nEnter the code sent to " + phone;
    });
  };

  static final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    actualCode = verificationId;
    setState(() {
      status = "\nAuto retrieval time out";
    });
  };

  static final PhoneVerificationFailed verificationFailed =
      (AuthException authException) {
    setState(() {
      status = '${authException.message}';

      print("Error message: " + status);
      if (authException.message.contains('not authorized'))
        status = 'Something has gone wrong, please try later';
      else if (authException.message.contains('Network'))
        status = 'Please check your internet connection and try again';
      else
        status = 'Something has gone wrong, please try later';
    });
  };


  static final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential auth) {
    setState(() {
      status = 'Auto retrieving verification code';
    });
    //_authCredential = auth;

    firebaseAuth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        setState(() {
          status = 'Authentication successful';
        });
        onAuthenticationSuccessful();
      } else {
        setState(() {
          status = 'Invalid code/invalid authentication';
        });
      }
    }).catchError((error) {
      setState(() {
        status = 'Something has gone wrong, please try later';
      });
    });
  };


  static void signInWithPhoneNumber(String smsCode) async {
    _authCredential = await PhoneAuthProvider.getCredential(
        verificationId: actualCode, smsCode: smsCode);
    firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
      setState(() {
        status = 'Something has gone wrong, please try later';
      });
    }).then((FirebaseUser user) async {
      setState(() {
        status = 'Authentication successful';
      });
      onAuthenticationSuccessful();
    });
  }

  static onAuthenticationSuccessful(){

  }

  static setState(Function f){

  }


}
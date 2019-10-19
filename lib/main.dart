import './firebase/auth/phone_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhoneAuth(),
      debugShowCheckedModeBanner: false,
    );
  }
}

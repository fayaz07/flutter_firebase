import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/countries.dart';
import 'package:flutter_firebase/providers/email__and_oauth.dart';
import 'package:flutter_firebase/providers/phone_auth.dart';
import 'package:flutter_firebase/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(FireApp());

class FireApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PhoneAuthDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        home: SplashScreen(),
//        debugShowCheckedModeBanner: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/countries.dart';
import 'package:flutter_firebase/providers/phone_auth.dart';
import 'package:provider/provider.dart';

import 'firebase/auth/phone_auth/get_phone.dart';

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
      ],
      child: MaterialApp(
        home: PhoneAuthGetPhone(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

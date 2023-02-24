import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/countries.dart';
import 'package:flutter_firebase/ui/screens/auth/select_country/SelectCountryScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const FireApp());

class FireApp extends StatelessWidget {
  const FireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountryProvider(),
        ),
      ],
      child: const MaterialApp(
        home: SelectCountryScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

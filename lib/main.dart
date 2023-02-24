import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/countries_provider.dart';
import 'package:flutter_firebase/ui/screens/auth/select_country/select_country_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const FireApp());

class FireApp extends StatelessWidget {
  const FireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountriesProvider()..loadCountriesFromJSON(),
          lazy: true,
        ),
      ],
      child: const MaterialApp(
        home: SelectCountryScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

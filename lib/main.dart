import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/countries.dart';
import 'package:flutter_firebase/providers/phone_auth.dart';
<<<<<<< Updated upstream
import 'package:provider/provider.dart';

=======
import 'package:flutter_firebase/settings.dart';
import 'package:flutter_firebase/task.dart';
import 'package:provider/provider.dart';

import 'Searchinstant.dart';
import 'chat/lets_text.dart';
import 'firebase/auth/auth.dart';
>>>>>>> Stashed changes
import 'firebase/auth/phone_auth/get_phone.dart';

void main() => runApp(FireApp());

class FireApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
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
=======
    return Consumer<PhoneAuthDataProvider>(
      builder: (_, auth, __) {
        FireBase.auth
            .currentUser()
            .then((value) => {if (value == null) {}})
            .catchError();
        if (FireBase.auth.currentUser() != null)
          return LetsChat();
        else {
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
      },
    );
  }
}*/
void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => CountryProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PhoneAuthDataProvider(),
      ),
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Who\'s Calling',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/task': (BuildContext context) => TaskPage(title: 'Task'),
          '/home': (BuildContext context) => BottomNavBar(),
          '/login': (BuildContext context) => PhoneAuthGetPhone(),
          '/search': (BuildContext context) => MySearchPage(),
          '/profile': (BuildContext context)  =>Settings(),
        });
>>>>>>> Stashed changes
  }
}

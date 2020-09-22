import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase/auth/auth.dart';
import 'home.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FireBase.auth
        .currentUser()
        .then((currentUser) => {
              if (currentUser == null)
              //Todo : add real users and try search
                {Navigator.pushReplacementNamed(context, "/login")
                  }
              else
                {
                  Navigator.pushReplacementNamed(context, "/home")

                  /*
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        title: result["fname"] + "'s Tasks",
                                        uid: currentUser.uid,
                                      ))))
                      .catchError((err) => print(err))*/
                }
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey,Colors.lightBlueAccent
                    ],
                    begin: Alignment.centerRight,
                    end: new Alignment(-1.0, -1.0),
                  ),
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 85.0,
                      child:  Image.asset(('assets/logoWhos.png'),
                        fit: BoxFit.cover,
                        height: 165.0,
                        width: 165.0,
                      ),

                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),

                    Text(
                      'WhosCalling!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontFamily:'Courgette'
                      ),
                    )
                  ]
              )
            ]
        )
    );
  }
}

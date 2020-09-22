import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/const.dart';
import 'package:flutter_firebase/providers/countries.dart';
import 'package:flutter_firebase/providers/phone_auth.dart';
import 'package:flutter_firebase/settings.dart';
import 'package:flutter_firebase/utils/constants.dart';
import 'package:flutter_firebase/utils/widgets.dart';
import 'package:flutter_firebase/widget/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter_firebase/home.dart";
import 'BottomNav.dart';
import 'firebase/auth/auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);
  final Color cardBackgroundColor = Colors.grey;
  final String logo = Assets.logoWhos;
  final String appName = "Welcome ";
  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  double _height, _width, _fixedPadding;
  final scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  final FirebaseAuth firebaseAuth = FireBase.auth;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;


  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();
    FireBase.auth.currentUser().then((currentUser) => {
          if (currentUser == null)
            {isLoggedIn == false}
          else
            {isLoggedIn == true}
        });
    if (isLoggedIn) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    FirebaseUser firebaseUser = (await FireBase.auth.currentUser());
    // how to get vars from providers :
    /*print("${Provider
        .of<PhoneAuthDataProvider>(context, listen: false)
        .phone}");
    print("___________________________________");
    print("${Provider
        .of<CountryProvider>(context, listen: false)
        .selectedCountry.toString()}");
      */
    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': "",
          'searchKey':"",
          'photoUrl': "",
          "phone":
              Provider.of<PhoneAuthDataProvider>(context, listen: false).phone,

          "country": json.decode(
              Provider.of<CountryProvider>(context, listen: false)
                  .selectedCountry
                  .toString()),
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        });
        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', "");
        await prefs.setString('searchKey', "");
        await prefs.setString('photoUrl', "");
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
        await prefs.setString('searchKey', documents[0]['searchKey']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>Settings()),
      );
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );

  }
  Widget _getBody() => Card(
    color: widget.cardBackgroundColor,
    elevation: 2.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: SizedBox(
      height: _height * 8 / 10,
      width: _width * 8 / 10,
      child: _getColumnBody(),
  ),
  );
  Widget _getColumnBody() => Column(
    children: <Widget>[
      //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
      Padding(
        padding: EdgeInsets.all(_fixedPadding),
        child: PhoneAuthWidgets.getLogo(
            logoPath: widget.logo, height: _height * 0.2),
      ),

      // AppName:
      Text(widget.appName,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w700)),

      SizedBox(height: 50.0),

      //  Info text
      Row(
        children: <Widget>[
          SizedBox(width: 16.0),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(

                       text:'Your authentication was completed successfully press continue to start and create a personalized profile',

                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.7,

                      )),

                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 16.0),
        ],
      ),

      SizedBox(height: 16.0),


      SizedBox(height: 32.0),

      RaisedButton(
        elevation: 16.0,
        onPressed: handleSignIn,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Continue',
            style: TextStyle(
                color: widget.cardBackgroundColor, fontSize: 18.0),
          ),
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)),
      )
    ],
  );
}

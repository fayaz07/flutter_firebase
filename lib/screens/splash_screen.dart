import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/firebase.dart';
import 'package:flutter_firebase/screens/firebase/auth/email/signup.dart';
import 'package:flutter_firebase/screens/home.dart';
import 'package:flutter_firebase/utils/navigation.dart';
import 'package:flutter_firebase/utils/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> _scaleAnimation;
  AnimationController _animationController;
  MaterialType _type = MaterialType.circle;

  @override
  void initState() {
    _animationController = AnimationController(
        debugLabel: 'splash-screen-animation-controller',
        duration: Duration(milliseconds: 800),
        vsync: this);
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _initSession();
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          /// circular scale
          ScaleTransition(
            scale: _scaleAnimation,
            alignment: Alignment.center,
            child: Material(
              type: _type,
              color: Color(0xffFFCB2B),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),

          /// Logo
          Logo(),
        ],
      ),
    );
  }

  _initSession() async {
    bool isLoggedIn = await FirebaseProvider.instantiate();
    _animationController.forward();

    _scaleAnimation.addListener(() {
      if (_scaleAnimation.value > 0.95) {
        if (_type == MaterialType.circle)
          setState(() {
            _type = MaterialType.canvas;
          });
        if (_animationController.isCompleted) {
          Navigator.of(context).pushReplacement(
              AppNavigation.route(isLoggedIn ? Home() : SignUpScreen()));
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

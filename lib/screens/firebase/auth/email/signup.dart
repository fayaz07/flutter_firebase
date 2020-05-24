import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/email__and_oauth.dart';
import 'package:flutter_firebase/screens/firebase/auth/phone_auth/get_phone.dart';
import 'package:flutter_firebase/utils/constants.dart';
import 'package:flutter_firebase/utils/navigation.dart';
import 'package:flutter_firebase/utils/widgets.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        home: SignUpScreen(),
      ),
    ));

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  Animation _typeWriterAnim;
  Animation<double> _fadeAnim;
  AnimationController _typeWriterAnimController, _fadeAnimController;

  final String _message = "Hey! Welcome to my app ${Constants.appName}. "
      "This will contain all the Firebase features implemented in a clean way. "
      "Thank you for installing the application.";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _typeWriterAnimController = AnimationController(
        debugLabel: 'signup-screen-animation-controller',
        vsync: this,
        duration: Duration(seconds: 6));
    _typeWriterAnim = StepTween(begin: 0, end: _message.length)
        .animate(_typeWriterAnimController);

    _fadeAnimController = AnimationController(
        debugLabel: 'signup-screen-animation-controller-2',
        vsync: this,
        duration: Duration(milliseconds: 1000));
    _fadeAnim = Tween(begin: 0.00, end: 1.0).animate(
        CurvedAnimation(parent: _fadeAnimController, curve: Curves.easeInCirc));

    super.initState();
  }

  double _height;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        _typeWriterAnimController.forward();
      } catch (err) {
        throw err;
      }
    });

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: SafeArea(child: _getBody(authProvider)),
    );
  }

  Widget _getBody(AuthProvider authProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Logo(),
            Text(
              Constants.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 32.0),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: authProvider.showTypeWriter
                  ? _getTypewriterMessage(authProvider)
                  : _getSignUpSectionAnimBuilder(),
            ),
            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  /// This embeds the signup section Column in an [AnimatedBuilder]
  /// Which will be a translation anim incl Fade in
  Widget _getSignUpSectionAnimBuilder() {
    return AnimatedBuilder(
      animation: _fadeAnim,
      builder: (context, child) => Opacity(
        opacity: (_fadeAnim.value + 0.2) > 1.0 ? 1.0 : (_fadeAnim.value + 0.2),
        child: Transform(
          transform: Matrix4.translationValues(
              0.0, -_height * _fadeAnim.value * .12, 0.0),
          child: _getSignUpSection(),
        ),
      ),
    );
  }

  /// Returns a column, which has
  ///  - A message
  ///  - Email field
  ///  - Password field
  ///  - Login & Signup buttons
  ///  - Forgot password button
  ///  - Social sign-in buttons
  Widget _getSignUpSection() => Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _height * .15),
            Text(
              'Get started with your email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.0),
            AppTextFormField(
              label: 'Email',
              color: Colors.white,
            ),
            AppTextFormField(
              label: 'Password',
              color: Colors.white,
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RoundBorderedButton(
                  onPressed: () {},
                  text: 'SIGN UP',
                ),
                RoundBorderedButton(
                  backgroundColor: Colors.indigoAccent,
                  onPressed: () {},
                  text: 'LOGIN',
                ),
              ],
            ),
            SizedBox(height: 16.0),
            FlatButton(
              onPressed: forgotPassword,
              child: Text(
                'Forgot Password? Click here to reset',
                style: TextStyle(
                    color: Colors.white, decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 16.0),
            _getSocialButtons(),
          ],
        ),
      );

  /// Returns a column of widgets
  ///  - Animating typewriter text-message
  ///  - After the typewriter animation, a button will fade in
  Widget _getTypewriterMessage(AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedBuilder(
        animation: _typeWriterAnim,
        builder: (BuildContext context, Widget child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 48.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _message.substring(0, _typeWriterAnim.value),
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 48.0),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                child: _typeWriterAnim.isCompleted
                    ? RoundBorderedButton(
                        onPressed: () {
                          authProvider.showTypeWriter = false;
                          _fadeAnimController.forward();
                        },
                        text: 'TAKE ME IN',
                      )
                    : SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Returns a row of buttons
  /// This generally embeds an asset into an [InkWell] widget,
  /// which is then exported as SocialButton
  Row _getSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Spacer(flex: 1),
        SizedBox(width: 16.0),
        SocialButton(
          onPressed: loginWithGoogle,
          asset: 'assets/images/google.png',
        ),
        SizedBox(width: 16.0),
        SocialButton(
          onPressed: loginWithFB,
          asset: 'assets/images/facebook.png',
        ),
        SizedBox(width: 16.0),
        SocialButton(
          onPressed: loginWithPhone,
          asset: 'assets/images/message.png',
        ),
        Spacer(flex: 1),
      ],
    );
  }

  @override
  void dispose() {
    _fadeAnimController.dispose();
    _typeWriterAnimController.dispose();
    super.dispose();
  }

  /// Code that involves logging in with Google
  void loginWithGoogle() {}

  /// Code that involves logging in with Facebook
  void loginWithFB() {}

  /// Taking the user to login with phone screen
  void loginWithPhone() {
    Navigator.of(context)
        .pushReplacement(AppNavigation.route(PhoneAuthGetPhone()));
  }

  void forgotPassword() {}
}

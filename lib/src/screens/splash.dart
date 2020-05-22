import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    super.initState();
    Future.microtask(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('user')) {
        Navigator.pushNamed(context, '/dashboard');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(child: Image.asset('assets/logo.png'), margin: EdgeInsets.only(left: 24, right: 24),),
      ),
    );
  }
}
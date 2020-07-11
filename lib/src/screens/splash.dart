import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';

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
      await Provider.of<DashModel>(context, listen: false).getLanguages();
      Locale locale = Localizations.localeOf(context);
      if (!prefs.containsKey('language')) {
        prefs.setInt('language', locale.languageCode == 'lv' ? 0 : locale.languageCode == 'en' ? 1 : locale.languageCode == 'ru' ? 2 : 0);
        Provider.of<DashModel>(context, listen: false).updateSelectedLanguage(prefs.getInt('language'));
      }
      if (prefs.containsKey('userExists') && prefs.getBool('userExists')) {
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
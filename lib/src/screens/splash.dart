import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/networking.dart';
import 'package:webnams_app_v3/src/resources/translations.dart';
import 'package:webnams_app_v3/src/screens/announcements.dart';

import 'dashboard.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool loading = false;
  bool retry = false;
  Widget body = Center(
    child: Container(
      child: Image.asset('assets/logo.png'),
      margin: EdgeInsets.only(left: 24, right: 24),
    ),
  );
  SplashState state = SplashState.loading;
  SplashState loggedInState;
  int selectedIndex = 0;

  @override
  initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard(selectedIndex: int.parse(message["selected_index"]))));
        print(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        if (context.read<DashModel>().dash.token != null) {
          Navigator.pushNamed(context, "/dashboard");
        }
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      SharedPreferences prefs;
      SharedPreferences.getInstance().then((value) {
        prefs = value;
        prefs.setString("device_id", token).then((value) => print(prefs.getString("device_id")));
      });
    });
    Future.microtask(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool success = await getData();
      if (success) {
        if (prefs.containsKey('userExists') && prefs.getBool('userExists')) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(selectedIndex: 0)));
        } else {
          Navigator.pushNamed(context, '/login');
        }
      }
    });
  }

  Future<void> retryData() async {
    bool success = await getData(true);
    if (success) {
      if (loggedInState == SplashState.loggedIn) {
        Navigator.pushNamed(context, "/dashboard");
      } else if (loggedInState == SplashState.notLoggedIn) {
        Navigator.pushNamed(context, "/login");
      }
    }
  }

  Future<bool> getData([retry = false]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Locale locale = Localizations.localeOf(context);
      if (!prefs.containsKey('language')) {
        prefs.setInt(
            'language',
            locale.languageCode == 'lv'
                ? 0
                : locale.languageCode == 'en'
                    ? 1
                    : locale.languageCode == 'ru' ? 2 : 0);
        Provider.of<DashModel>(context, listen: false)
            .updateSelectedLanguage(prefs.getInt('language'));
      }
      await Provider.of<DashModel>(context, listen: false).getLanguages();
      await Provider.of<DashModel>(context, listen: false).getTranslations();
      if (retry) {
        if (prefs.containsKey('userExists') && prefs.getBool('userExists')) {
          setState(() {
            loggedInState = SplashState.loggedIn;
          });
        } else {
          setState(() {
            loggedInState = SplashState.notLoggedIn;
          });
        }
      }
      return true;
    } on TimeoutException catch (_) {
      setState(() {
        state = SplashState.timeout;
      });
      return false;
    } on NoInternetException catch (_) {
      setState(() {
        state = SplashState.noNet;
      });
      return false;
    } catch (e, stack) {
      print(stack);
      setState(() {
        state = SplashState.timeout;
      });
      return false;
    }
  }

  Widget build(BuildContext context) {
    if (state == SplashState.loading) {
      setState(() {
        body = Center(
          child: Container(
            child: Image.asset('assets/logo.png'),
            margin: EdgeInsets.only(left: 24, right: 24),
          ),
        );
      });
    }
    if (state == SplashState.noNet) {
      Map<String, String> modalTranslations = hardcodedTranslation(
          Provider.of<DashModel>(context).dash.language ?? 0, "internet_loss");
      setState(() {
        body = Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 52.0),
                  child: Container(
                      width: 170, child: Image.asset("assets/network.png")),
                ),
                Text(
                  modalTranslations["title"],
                  textAlign: TextAlign.center,
                ),
                FlatButton(
                  child: Text(
                    modalTranslations["button"],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  onPressed: () async {
                    await retryData();
                  },
                ),
              ],
            ),
          ),
        );
      });
    }
    if (state == SplashState.timeout) {
      Map<String, String> modalTranslations = hardcodedTranslation(
          Provider.of<DashModel>(context).dash.language ?? 0, "timeout");
      setState(() {
        body = Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 52.0),
                  child: Container(width: 170, child: Image.asset("assets/network.png")),
                ),
                Text(
                  modalTranslations["title"],
                  textAlign: TextAlign.center,
                ),
                FlatButton(
                  child: Text(
                    modalTranslations["button"],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  onPressed: () async => await retryData(),
                ),
              ],
            ),
          ),
        );
      });
    }
    return Scaffold(body: body);
  }
}

enum SplashState { loggedIn, notLoggedIn, timeout, noNet, loading }

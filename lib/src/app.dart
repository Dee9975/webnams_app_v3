import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/user/user_model.dart';
import 'package:webnams_app_v3/src/screens/announcement_details.dart';
import 'package:webnams_app_v3/src/screens/announcements.dart';
import 'package:webnams_app_v3/src/screens/bill.dart';
import 'package:webnams_app_v3/src/screens/login.dart';
import 'package:webnams_app_v3/src/screens/meters_camera.dart';
import 'package:webnams_app_v3/src/screens/password.dart';
import 'package:webnams_app_v3/src/screens/pdf_view.dart';
import 'package:webnams_app_v3/src/screens/picker.dart';
import 'package:webnams_app_v3/src/screens/settings.dart';
import 'package:webnams_app_v3/src/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/screens/hosts.dart';
import 'package:webnams_app_v3/src/screens/dashboard.dart';
import 'package:webnams_app_v3/src/screens/languages.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity/connectivity.dart';

class App extends StatefulWidget {
  final CameraDescription camera;
  const App({Key key, this.camera}) : super(key: key);

  @override
  AppState createState() => AppState(camera);
}

class AppState extends State<App> {
  final CameraDescription camera;
  AppState(this.camera);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new UserData(),
        ),
        ChangeNotifierProvider(
          create: (_) => new DashModel(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            Locale("lv", "LV"),
            Locale("en", "EN"),
            Locale("ru", "RU")
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.black,
            backgroundColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Manrope',
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => Splash(),
            '/login': (context) => Login(),
            '/hosts': (context) => Hosts(),
            '/dashboard': (context) => Dashboard(),
            '/languages': (context) => Languages(),
            '/password': (context) => Password(),
            '/bill': (context) => Bill(),
            '/pdf': (context) => PdfView(),
            '/settings': (context) => Settings(),
            '/meter_picker': (context) => MeterPicker(),
            '/announcements': (context) => Announcements(),
            '/announcement_details': (context) => AnnouncementDetails(),
            '/meters_camera': (context) => MetersCamera(camera: camera)
          },
        ),
      ),
    );
  }
}

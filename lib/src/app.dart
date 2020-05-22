import 'package:flutter/material.dart';
import 'package:webnams_app_v3/src/models/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/user_model.dart';
import 'package:webnams_app_v3/src/screens/bill.dart';
import 'package:webnams_app_v3/src/screens/login.dart';
import 'package:webnams_app_v3/src/screens/password.dart';
import 'package:webnams_app_v3/src/screens/pdf_view.dart';
import 'package:webnams_app_v3/src/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/screens/hosts.dart';
import 'package:webnams_app_v3/src/screens/dashboard.dart';
import 'package:webnams_app_v3/src/widgets/languages.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
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
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.black,
            backgroundColor: Colors.white,
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
          },
        ),
      ),
    );
  }
}

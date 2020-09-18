import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webnams_app_v3/src/resources/my_flutter_app_icons.dart';
import 'package:webnams_app_v3/src/screens/bills.dart';
import 'package:webnams_app_v3/src/screens/sliver_home.dart';
import 'package:webnams_app_v3/src/screens/sliver_meters.dart';
import 'package:webnams_app_v3/src/widgets/top_bar.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:supercharged/supercharged.dart';

import 'more.dart';

class Dashboard extends StatefulWidget {
  final int selectedIndex;
  Dashboard({Key key, @required this.selectedIndex}) : super(key: key);

  DashboardState createState() => DashboardState(selectedIndex: selectedIndex);
}

class DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  int selectedIndex;
  DashboardState({@required this.selectedIndex});
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (state) {
      case AppLifecycleState.resumed:
        if (prefs.getBool("userExists")) {
          DashModel dashModel = context.read<DashModel>();
          DateTime compare = DateTime.parse(prefs.getString("refresh-date"));
          if (DateTime.now().compareTo(compare) > 0) {
            await context.read<DashModel>().getUser();
          }
        }
        break;
      case AppLifecycleState.inactive:
        // print("app in inactive");
        break;
      case AppLifecycleState.paused:
        // print("app in paused");
        break;
      case AppLifecycleState.detached:
        // print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashState = Provider.of<DashModel>(context);
    List<Widget> _widgetOptions = <Widget>[
      SliverHome(),
      Bills(),
      SliverMeters(),
      More(),
    ];
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: TopBar(),
        body: Container(
          child: _widgetOptions
              .elementAt(selectedIndex),
        ),
        bottomNavigationBar: IgnorePointer(
          ignoring: Provider.of<DashModel>(context).isLoading,
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  !dashState.isLoading
                      ? dashState.getTranslation(code: 'mob_app_home')
                      : '',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.rekins),
                title: Text(
                  !dashState.isLoading
                      ? dashState.getTranslation(code: 'mob_app_bills')
                      : '',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.skait),
                title: Text(
                  !dashState.isLoading
                      ? dashState.getTranslation(code: 'mob_app_meters')
                      : '',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.menu),
                title: Text(
                  !dashState.isLoading
                      ? dashState.getTranslation(code: 'mob_app_more_meters')
                      : '',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
            currentIndex: selectedIndex,
            onTap: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            selectedItemColor: Colors.blueAccent,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.grey[400],
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

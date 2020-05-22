import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/my_flutter_app_icons.dart';
import 'package:webnams_app_v3/src/screens/bills.dart';
import 'package:webnams_app_v3/src/screens/home.dart';
import 'package:webnams_app_v3/src/screens/meters.dart';
import 'package:webnams_app_v3/src/widgets/more.dart';
import 'package:webnams_app_v3/src/widgets/top_bar.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Home(),
      Bills(),
      Meters(),
      More(),
    ];
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: TopBar(),
        body: Container(
          child: _widgetOptions
              .elementAt(Provider.of<DashModel>(context).dash.selectedIndex),
        ),
        bottomNavigationBar: IgnorePointer(
          ignoring: Provider.of<DashModel>(context).isLoading,
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Sākums'),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.rekins),
                title: Text('Rēķini'),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.skait),
                title: Text('Skaitītāji'),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.menu),
                title: Text('Vairāk'),
              ),
            ],
            currentIndex: Provider.of<DashModel>(context).dash.selectedIndex,
            onTap: (int index) {
              Provider.of<DashModel>(context, listen: false)
                  .updateSelectedIndex(index);
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

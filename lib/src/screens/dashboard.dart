import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/resources/my_flutter_app_icons.dart';
import 'package:webnams_app_v3/src/screens/bills.dart';
import 'package:webnams_app_v3/src/screens/sliver_home.dart';
import 'package:webnams_app_v3/src/screens/sliver_meters.dart';
import 'package:webnams_app_v3/src/widgets/top_bar.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';

import 'more.dart';

class Dashboard extends StatelessWidget {
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
              .elementAt(Provider.of<DashModel>(context).dash.selectedIndex),
        ),
        bottomNavigationBar: IgnorePointer(
          ignoring: Provider.of<DashModel>(context).isLoading,
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(!dashState.isLoading ? dashState.getTranslation(code: 'mob_app_home') : '', style: TextStyle(fontWeight: FontWeight.w600),),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.rekins),
                title: Text(!dashState.isLoading ? dashState.getTranslation(code: 'mob_app_bills') : '', style: TextStyle(fontWeight: FontWeight.w600),),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.skait),
                title: Text(!dashState.isLoading ? dashState.getTranslation(code: 'mob_app_meters') : '', style: TextStyle(fontWeight: FontWeight.w600),),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.menu),
                title: Text(!dashState.isLoading ? dashState.getTranslation(code: 'mob_app_more_meters') : '', style: TextStyle(fontWeight: FontWeight.w600),),
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

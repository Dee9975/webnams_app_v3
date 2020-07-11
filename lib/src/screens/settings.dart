import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashState = Provider.of<DashModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dashState.getTranslation(code: 'mob_app_menu_settings'),
          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: RaisedButton(
                    child: Text(
                  dashState.getTranslation(code: 'mob_app_menu_logout'),
                  style: TextStyle(fontSize: 16.0, color: hexToColor('#ff1303')),
                  ),
                  onPressed: () async {
                      await Provider.of<DashModel>(context, listen: false).logOut();
                      Navigator.pushNamed(context, '/login');
                  },
                  color: hexToColor('#e5edf3'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

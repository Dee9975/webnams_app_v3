import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

class Languages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> langs = [
      Container(
        child: ListTile(
          leading: Text('English'),
          trailing: Provider.of<DashModel>(context).dash.language == 'en'
              ? Icon(
                  Icons.check_circle,
                  color: Colors.blueAccent,
                )
              : Icon(Icons.arrow_right),
          onTap: () {
            Provider.of<DashModel>(context, listen: false)
                .updateSelectedLanguage('en');
          },
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: hexToColor('#d6dde3')),
          ),
        ),
      ),
      Container(
        child: ListTile(
          leading: Text('Latviski'),
          trailing: Provider.of<DashModel>(context).dash.language == 'lv'
              ? Icon(
                  Icons.check_circle,
                  color: Colors.blueAccent,
                )
              : Icon(Icons.arrow_right),
          onTap: () {
            Provider.of<DashModel>(context, listen: false)
                .updateSelectedLanguage('lv');
          },
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: hexToColor('#d6dde3')),
          ),
        ),
      ),
      Container(
        child: ListTile(
          leading: Text('Russki'),
          trailing: Provider.of<DashModel>(context).dash.language == 'ru'
              ? Icon(
                  Icons.check_circle,
                  color: Colors.blueAccent,
                )
              : Icon(Icons.arrow_right),
          onTap: () {
            Provider.of<DashModel>(context, listen: false)
                .updateSelectedLanguage('ru');
          },
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: hexToColor('#d6dde3')),
            bottom: BorderSide(color: hexToColor('#d6dde3')),
          ),
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Valoda'),
        elevation: 0,
      ),
      body: ListView(
        children: langs,
      ),
    );
  }
}

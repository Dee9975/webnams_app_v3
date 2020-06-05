import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

class Languages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DashModel dashModel = Provider.of<DashModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(dashModel.getTranslation(code: 'mob_app_menu_languages')),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: dashModel.langs.rows,
        itemBuilder: (context, int index) {
          return GestureDetector(
            onTap: () => Provider.of<DashModel>(context, listen: false)
                .updateSelectedLanguage(index),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: index == 0
                      ? BorderSide(color: hexToColor('#d6dde3'))
                      : BorderSide(width: 0, color: hexToColor('#d6dde3')),
                  bottom: BorderSide(color: hexToColor('#d6dde3')),
                ),
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 4.0, bottom: 4.0, right: 12.0),
                        child: Image.asset(
                          'assets/${dashModel.langs.data[index].code.toLowerCase()}.png',
                          width: 32.0,
                        ),
                      ),
                      Text(
                        dashModel.dash.language == 0
                            ? dashModel.langs.data[index].names.lv
                            : dashModel.dash.language == 1
                                ? dashModel.langs.data[index].names.en
                                : dashModel.langs.data[index].names.ru,
                        style: TextStyle(
                            fontSize: 16.0, color: hexToColor('#222e42')),
                      )
                    ],
                  ),
                  Provider.of<DashModel>(context).dash.language == index
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.blueAccent,
                          ),
                        )
                      : Offstage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

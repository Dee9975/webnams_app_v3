import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/widgets/info_box.dart';
import 'package:webnams_app_v3/src/widgets/notification_switch.dart';

import 'feedback.dart';

class More extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashModel = Provider.of<DashModel>(context);
    List<Widget> _moreOptions = [
      InfoBox(
        text: Text(
            dashModel.getTranslation(code: 'mob_app_announcements'),
            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
        ),
        onPressed: () => Navigator.pushNamed(context, '/announcements'),
      )
    ];
    List<Widget> _options = [
//      InfoBox(
//        text: Text(
//          'Majas lieta',
//          style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
//          ),
//        onPressed: () => print('aptaujas'),
//      ),
//      InfoBox(
//        text: Text(
//      'Atskaites',
//      style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
//      ),
//        onPressed: () => print('aptaujas'),
//      ),
//      InfoBox(
//        text: Text(
//            'Saziņa',
//            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
//        ),
//        onPressed: () => print('aptaujas'),
//      ),
//      InfoBox(
//        text: Text(
//            'Adreses',
//            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
//        ),
//        onPressed: () => print('aptaujas'),
//      ),
      InfoBox(
        text: Text(
            dashModel.getTranslation(code: "mob_app_profile"),
            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
        ),
        onPressed: () => Navigator.pushNamed(context, '/settings'),
      ),
//      InfoBox(
//        text: Text(
//            'Dokumenti',
//            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
//        ),
//        onPressed: () => print('aptaujas'),
//      ),
//      InfoBox(
//        text: Text(
//            'Aptaujas',
//            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
//        ),
//        onPressed: () => print('aptaujas'),
//      ),
      InfoBox(
        text: Text(
            dashModel.getTranslation(code: 'mob_app_menu_languages'),
            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
        ),
        onPressed: () => Navigator.pushNamed(context, '/languages'),
      ),
      InfoBox(
        text: Text(
            dashModel.getTranslation(code: 'mob_app_feedback'),
            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
        ),
        onPressed: () =>  Navigator.push(context, MaterialPageRoute(
            builder: (context) => FeedbackScreen(anonymous: false,)
        )),
      ),
      NotificationSwitch()
    ];
    
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 24.0),
            child: Text(
              dashModel.getTranslation(code: 'mob_app_more_title'),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
              _moreOptions
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 24.0),
            child: Text(
              dashModel.getTranslation(code: 'mob_app_menu_settings'),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
              _options
          ),
        ),
      ],
    );
  }
}
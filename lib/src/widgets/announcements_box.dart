import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/announcements/announcements.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class AnnouncementsBox extends StatelessWidget {
  final AnnouncementData data;
  AnnouncementsBox(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 2.0),
                blurRadius: 1.0,
                spreadRadius: -1.0,
                color: _kKeyUmbraOpacity),
            BoxShadow(
                offset: Offset(0.0, 1.0),
                blurRadius: 1.0,
                spreadRadius: 0.0,
                color: _kKeyPenumbraOpacity),
            BoxShadow(
                offset: Offset(0.0, 1.0),
                blurRadius: 3.0,
                spreadRadius: 0.0,
                color: _kAmbientShadowOpacity),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.album,
                  color: hexToColor('#8d96a4'),
                  size: 16,
                ),
                Text(
                  Provider.of<DashModel>(context).getTranslation(code: 'mob_app_announcement'),
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: hexToColor('#8d96a4')),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 7.0),
            child: Text(data.title, style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 16.0),
            child: Text(Provider.of<DashModel>(context).getTranslation(code: 'mob_app_read_more'), style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: hexToColor('#23a0ff'))),
          )
        ],
      ),
    );
  }
}
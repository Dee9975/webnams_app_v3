import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/widgets/info_box.dart';

class More extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashModel = Provider.of<DashModel>(context);
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
      InfoBox(
        text: Text(
            'Paziņojumi',
            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
        ),
        onPressed: () => Navigator.pushNamed(context, '/announcements'),
      ),
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
            'Uzstādījumi',
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
            'Valodas',
            style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42'),)
        ),
        onPressed: () => Navigator.pushNamed(context, '/languages'),
      ),
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
              _options
          ),
        )
      ],
    );
  }
}
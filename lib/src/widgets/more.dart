import 'package:flutter/material.dart';
import 'package:webnams_app_v3/src/widgets/info_box.dart';

class More extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> _options = [
      InfoBox(
        text: 'Majas lieta',
        onPressed: () => print('aptaujas'),
      ),
      InfoBox(
        text: 'Atskaites',
        onPressed: () => print('aptaujas'),
      ),
      InfoBox(
        text: 'Paziņojumi',
        onPressed: () => print('aptaujas'),
      ),
      InfoBox(
        text: 'Saziņa',
        onPressed: () => print('aptaujas'),
      ),
      InfoBox(
        text: 'Adreses',
        onPressed: () => print('aptaujas'),
      ),
      InfoBox(
        text: 'Uzstādījumi',
        onPressed: () => print('aptaujas'),
      ),
      InfoBox(
        text: 'Dokumenti',
        onPressed: () => print('aptaujas'),
      ),
      InfoBox(
        text: 'Aptaujas',
        onPressed: () => print('aptaujas'),
      ),
      InfoBox(
        text: 'Valoda',
        onPressed: () => Navigator.pushNamed(context, '/languages'),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 24.0),
          child: Text(
            'Vairāk',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: _options,
        ),
      ],
    );
  }
}

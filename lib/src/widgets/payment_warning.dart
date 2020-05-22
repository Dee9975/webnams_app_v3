import 'package:flutter/material.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

class PaymentWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration:
            BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: hexToColor('#ff1303'), shape: BoxShape.circle),
        ),
        Text(
          '!',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ],
    );
  }
}

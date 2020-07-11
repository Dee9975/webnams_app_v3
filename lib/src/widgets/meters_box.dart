import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/resources/my_flutter_app_icons.dart';
import 'package:webnams_app_v3/src/screens/picker.dart';

import 'meters_modal.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class MetersBox extends StatelessWidget {
  final MeterData data;
  const MetersBox(this.data);
  @override
  Widget build(BuildContext context) {
    final dashState = Provider.of<DashModel>(context);

    void updateSelectedMeter(MeterData meter) {
      Provider.of<DashModel>(context, listen: false).updateSelectedMeter(meter);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8.0),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    MyFlutterApp.skait,
                    color: hexToColor('#8d96a4'),
                  ),
                  Text(
                    data.type,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: hexToColor('#8d96a4')),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    dashState.getTranslation(code: 'mob_app_number'),
                    style: TextStyle(
                        color: hexToColor('#8d96a4'), fontSize: 16.0),
                  ),
                  Text(
                    data.number ?? '',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: hexToColor('#222e42')),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    dashState.getTranslation(code: 'mob_app_expire'),
                    style: TextStyle(
                        color: hexToColor('#8d96a4'), fontSize: 16.0),
                  ),
                  Text(
                    data.lastReading['to'],
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: hexToColor('#222e42')),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    dashState.getTranslation(code: 'mob_app_last'),
                    style: TextStyle(
                        color: hexToColor('#8d96a4'), fontSize: 16.0),
                  ),
                  Text(
                    '${data.lastReading['value']}',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: hexToColor('#222e42')),
                  ),
                ],
              ),
              !data.hideWeb
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: ButtonTheme(
                        height: 40.0,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        buttonColor: hexToColor('#23a0ff'),
                        child: RaisedButton(
                          child: Text(
                            dashState.getTranslation(code: 'mob_app_input'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            updateSelectedMeter(data);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MeterPicker(
                                          selectedMeter: data,
                                        )));
                          },
                          // onPressed: _isButtonDisabled ? null : _updateEmail,
                        ),
                      ),
                    )
                  : Offstage(),
            ],
          ),
        ),
      ),
    );
  }
}

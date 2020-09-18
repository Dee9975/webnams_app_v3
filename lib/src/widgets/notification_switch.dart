import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class NotificationSwitch extends StatefulWidget {
  NotificationSwitch({Key key}) : super(key: key);

  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  bool value = false;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey("notifications") &&
          prefs.getBool("notifications")) {
        setState(() {
          value = true;
        });
      } else {
        prefs.setBool("notifications", false);
        value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> updateValue(bool val) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (await Provider.of<DashModel>(context, listen: false)
          .updateDeviceId(prefs.getString("device_id"), val)) {
        await prefs.setBool("notifications", val);
        setState(() {
          value = val;
        });
      }
    }

    DashModel dashModel = Provider.of<DashModel>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dashModel.getTranslation(code: "mob_app_firebase"),
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Switch(
                activeColor: Colors.blue,
                value: value,
                onChanged: updateValue,
              )
            ],
          ),
        ),
      ),
    );
  }
}

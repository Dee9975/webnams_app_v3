import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/user/user_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

class PasswordReset extends StatefulWidget {
  PasswordReset({Key key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    emailController.text = Provider.of<UserData>(context, listen: false).user.email;
    emailController.addListener(() {
      print(emailController.text);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text("Aizmirsi paroli?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text(Provider.of<DashModel>(context).getTranslation(code: "mob_app_email_placeholder"), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide(
                        color: !Provider.of<UserData>(context).hasError
                            ? hexToColor('#23a0ff')
                            : hexToColor('#ff1303'),
                        width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide:
                    BorderSide(color: hexToColor('#ff1303'), width: 1.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                          color: !Provider.of<UserData>(context).hasError
                              ? hexToColor('#d6dde3')
                              : hexToColor('#ff1303'))),
                  contentPadding: EdgeInsets.zero,
                  focusColor: hexToColor('#23a0ff'),
                ),
                controller: emailController,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
            child: ButtonTheme(
              height: 48.0,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              buttonColor: hexToColor('#23a0ff'),
              child: RaisedButton(
                child: Text(
                  Provider.of<DashModel>(context).getTranslation(code: 'mob_app_send'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  if (await Provider.of<UserData>(context, listen: false).resetPassword(emailController.text)) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(Provider.of<UserData>(context, listen: false).success),
                      backgroundColor: Colors.lightGreen,
                    ));
                  } else {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(Provider.of<UserData>(context, listen: false).error),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
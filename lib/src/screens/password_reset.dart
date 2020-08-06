import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';

class PasswordReset extends StatefulWidget {
  PasswordReset({Key key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    emailController.text = Provider.of<DashModel>(context, listen: false).user.email;
    emailController.addListener(() {
      print(emailController.text);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Aizmirsi paroli?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
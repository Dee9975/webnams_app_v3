import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/user/user_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:supercharged/supercharged.dart';

class Password extends StatefulWidget {
  const Password({Key key}) : super(key: key);

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  FocusNode _focus = new FocusNode();
  bool _dummyState = true;
  bool _loading = false;
  final passwordController = TextEditingController();
  @override
  void dispose() {
    _focus.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    passwordController.addListener(_listenToPassword);
    super.initState();
  }

  void _listenToPassword() {
    setState(() {
      _dummyState = !_dummyState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashState = Provider.of<DashModel>(context);

    void updatePassword(String password) async {
      setState(() {
        _loading = true;
      });
      await Provider.of<UserData>(context, listen: false)
          .updatePassword(password);
      await dashState.newGetUser();
      if (dashState.hasError) {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text(dashState.error?? "Error tings innit"),
          );
        });
      }
      if (dashState.hasError) {
        Provider.of<UserData>(context, listen: false).updateError(true, dashState.error);
        setState(() {
          _loading = false;
        });
        return;
      }
      setState(() {
        _loading = false;
      });
      if (!Provider.of<UserData>(context, listen: false).hasError) {
        Navigator.pushNamed(context, '/dashboard');
      }
    }

    if (!_loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            Provider.of<UserData>(context).user.hostName,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 16.0),
              child: Text(
                dashState.getTranslation(code: 'mob_app_password_app_title'),
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                dashState.getTranslation(code: 'mob_app_password_app_subtitle'),
                style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42')),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
              child: Container(
                height: 48.0,
                child: TextField(
                  focusNode: _focus,
                  textAlign: TextAlign.center,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: !_focus.hasPrimaryFocus
                        ? dashState.getTranslation(
                            code: 'mob_app_password_placeholder')
                        : '',
//                  errorText: Provider.of<UserData>(context).hasError
//                      ? Provider.of<UserData>(context).error
//                      : null,
                    errorStyle: TextStyle(),
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
                  style: TextStyle(
                      height: 1,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: hexToColor('#b1b1b1')),
                ),
              ),
            ),
            Provider.of<UserData>(context).hasError
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      Provider.of<UserData>(context).error,
                      style: TextStyle(color: hexToColor('#ff1303')),
                    ),
                  ))
                : Offstage(),
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
                    dashState.getTranslation(code: 'mob_app_password_button'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    updatePassword(passwordController.text);
                  },
                  // onPressed: _isButtonDisabled ? null : _updateEmail,
                ),
              ),
            ),
//            GestureDetector(
//              onTap: () {
//
//              },
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Center(child: Text("Aizmirsi paroli?", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: "#23a0ff".toColor()),)),
//              ),
//            )
          ],
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

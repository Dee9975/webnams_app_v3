import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/user/user_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FocusNode _focus = new FocusNode();
  final emailController = TextEditingController();
  bool _isButtonDisabled;

  @override
  void dispose() {
    emailController.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_setEmail);
    _isButtonDisabled = true;
  }

  _setEmail() {
    if (EmailValidator.validate(emailController.text)) {
      setState(() {
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }
  }

  void _updateEmail() async {
    await Provider.of<UserData>(context, listen: false)
        .updateEmail(emailController.text);
    if (!Provider.of<UserData>(context, listen: false).hasError) {
      Navigator.pushNamed(context, '/hosts');
    }
  }
  @override
  Widget build(BuildContext context) {
    DashModel dashModel = Provider.of<DashModel>(context);
    if (!dashModel.isLoading) {
      return Scaffold(
//        bottomNavigationBar: BottomAppBar(
//          elevation: 0,
//          child: Container(
//          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              ClipOval(
//                child: FlatButton(
//                  onPressed: () {
//
//                  },
//                  child: Image.asset('assets/lv.png', height: 48.0,),
//                ),
//              ),
//              FlatButton(
//                onPressed: () {
//
//                },
//                child: Image.asset('assets/en.png', height: 48.0,),
//              ),
//              FlatButton(
//                onPressed: () {
//
//                },
//                child: Image.asset('assets/ru.png', height: 48.0,),
//              ),
//            ],
//          ),
//          ),
//        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ButtonTheme(
              buttonColor: Colors.white,
              height: 48.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  side: BorderSide(width: 0.5)),
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Provider.of<DashModel>(context).dash.language == 0
                        ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        'assets/lv.png',
                        width: 32,
                        height: 32,
                      ),
                    )
                        : Provider.of<DashModel>(context).dash.language == 2
                        ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        'assets/ru.png',
                        width: 32,
                        height: 32,
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        'assets/en.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                    Provider.of<DashModel>(context).dash.language == 0
                        ? Text(
                      Provider.of<DashModel>(context)
                          .langs
                          .data[0]
                          .names
                          .lv,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: hexToColor('#b1b1b1')),
                    )
                        : Provider.of<DashModel>(context).dash.language == 2
                        ? Text(
                      Provider.of<DashModel>(context)
                          .langs
                          .data[2]
                          .names
                          .ru,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: hexToColor('#b1b1b1')),
                    )
                        : Text(
                      Provider.of<DashModel>(context)
                          .langs
                          .data[1]
                          .names
                          .en,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: hexToColor('#b1b1b1')),
                    ),
                  ],
                ),
                onPressed: () => Navigator.pushNamed(context, '/languages'),
              ),
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/logo.png'),
                  width: 200,
                ),
                SizedBox(
                  height: 42,
                ),
                Image(
                  image: AssetImage('assets/login_image.png'),
                  width: 256,
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
                  child: Container(
                    height: 48.0,
                    child: TextField(
                      focusNode: _focus,
                      textAlign: TextAlign.center,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: !_focus.hasPrimaryFocus ? dashModel.getTranslation(code: 'mob_app_email_placeholder') : '',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(
                              color: hexToColor('#23a0ff'), width: 1.0),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(color: hexToColor('#d6dde3'))),
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
                    ? Text(
                  Provider.of<UserData>(context).error ?? 'Error',
                  style: TextStyle(color: Colors.red),
                )
                    : Offstage(),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: ButtonTheme(
                    height: 48.0,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    buttonColor: hexToColor('#23a0ff'),
                    child: RaisedButton(
                      child: Text(
                        dashModel.getTranslation(code: 'mob_app_email_button'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: _isButtonDisabled ? null : _updateEmail,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}

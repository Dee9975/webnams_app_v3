import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/user_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  bool _isButtonDisabled;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    emailController.addListener(_setEmail);
    _isButtonDisabled = true;
  }

  _setEmail() {
    if (emailController.text.contains('@')) {
      setState(() {
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }
  }

  void _updateEmail() {
    Provider.of<UserData>(context, listen: false)
        .updateEmail(emailController.text);
    Provider.of<UserData>(context, listen: false).getHosts();
    Navigator.pushNamed(context, '/hosts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
                child: Container(
                  height: 48.0,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(color: hexToColor('#23a0ff'), width: 1.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(color: hexToColor('#d6dde3'))
                        ),
                        contentPadding: EdgeInsets.zero,
                        focusColor: hexToColor('#23a0ff'),
                      ),
                      style: TextStyle(
                        height: 1,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: hexToColor('#b1b1b1')
                      ),
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
                    child: Text('Tālāk', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),),
                    onPressed: _isButtonDisabled ? null : _updateEmail,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

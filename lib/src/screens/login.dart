import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/user/user_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:supercharged/supercharged.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
        .updateEmail(emailController.text.trim());
    if (!Provider.of<UserData>(context, listen: false).hasError) {
      Navigator.pushNamed(context, '/hosts');
    }
  }

  @override
  Widget build(BuildContext context) {
    DashModel dashModel = Provider.of<DashModel>(context);

    if (!dashModel.isLoading) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
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
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 32.0),
                    child: Container(
                      height: 48.0,
                      child: TextField(
                        textCapitalization: TextCapitalization.none,
                        focusNode: _focus,
                        textAlign: TextAlign.center,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: !_focus.hasPrimaryFocus
                              ? dashModel.getTranslation(
                                  code: 'mob_app_email_placeholder')
                              : '',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(
                                color: hexToColor('#23a0ff'), width: 1.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide:
                                  BorderSide(color: hexToColor('#d6dde3'))),
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
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0),
                    child: Row(
                      children: [
                        ButtonTheme(
                          height: 48.0,
                          minWidth: MediaQuery.of(context).size.width - 104,
//                          minWidth: MediaQuery.of(context).size.width - 36,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          buttonColor: hexToColor('#23a0ff'),
                          child: RaisedButton(
                            child: Text(
                              dashModel.getTranslation(
                                  code: 'mob_app_email_button'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: _isButtonDisabled ? null : _updateEmail,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ButtonTheme(
                            height: 48.0,
                            minWidth: 64,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            buttonColor: hexToColor('#23a0ff'),
                            child: RaisedButton(
                              child: Image.asset("assets/qrcode-scan.png", width: 25,),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      String text = Provider.of<DashModel>(context, listen: false).getTranslation(code: "mob_app_qr_instruction");
                                      String bold = text.allBetween("<b>", "</b>");
                                      text = text
                                          .replaceAll("<b>", "\n")
                                          .replaceAll("</b>", "");
                                      List<String> split = text.split(bold);
                                      Widget content = RichText(
                                        text: TextSpan(
                                            text: split[0],
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: "Manrope"),
                                            children: <TextSpan>[
                                              TextSpan(text: bold, style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: split[1]),
                                            ]
                                        ),

                                      );
                                      return AlertDialog(
                                        content: content,
                                        actions: [
                                          FlatButton(
                                            child: Text(Provider.of<DashModel>(context, listen: false).getTranslation(code: "mob_app_cancel")),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          FlatButton(
                                            onPressed: () async {
                                              var options = ScanOptions(
                                                strings: {
                                                  "cancel": Provider.of<DashModel>(context, listen: false)
                                                      .getTranslation(code: "mob_app_cancel")
                                                },
                                              );
                                              ScanResult result =
                                              await BarcodeScanner.scan(options: options);
                                              if (result.type == ResultType.Barcode) {
                                                if (await Provider.of<UserData>(context, listen: false)
                                                    .loginBarcode(result.rawContent)) {
                                                  await Provider.of<DashModel>(context, listen: false)
                                                      .newGetUser();
                                                  Navigator.pushNamed(context, "/dashboard");
                                                } else {
                                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    behavior: SnackBarBehavior.floating,
                                                    content: Text(Provider.of<UserData>(context, listen: false).qrError),
                                                    backgroundColor: Colors.redAccent,
                                                  ));
                                                  Navigator.pop(context);
                                                }
                                              }
                                            },
                                            child: Text(Provider.of<DashModel>(context, listen: false).getTranslation(code: "mob_app_qr_scan")),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:http/http.dart' as http;
import 'package:webnams_app_v3/src/resources/networking.dart';

class FeedbackScreen extends StatefulWidget {
  final bool anonymous;
  FeedbackScreen({Key key, this.anonymous = false}) : super(key: key);

  @override
  _FeedbackState createState() => _FeedbackState(anonymous: anonymous);
}

class _FeedbackState extends State<FeedbackScreen> {
  final bool anonymous;
  NetworkProvider networkProvider;
  _FeedbackState({this.anonymous}) : assert(anonymous != null);
  final TextEditingController feedbackController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String feedback = "";
  int charCount = 0;
  String error = "";
  bool active = true;
  @override
  void initState() {
    super.initState();
    feedbackController.addListener(feedbackListener);
  }

  void feedbackListener() {
    setState(() {
      feedback = feedbackController.text?? "";
      charCount = feedback.trim().length;
    });
  }

  @override
  Widget build(BuildContext context) {
    DashModel dashState = Provider.of<DashModel>(context);
    Future<void> sendFeedback() async {
      if (feedback == "") {
        setState(() {
          active = false;
          error = "The input field can't be empty!";
        });
        return;
      }
      if (charCount < 10) {
        setState(() {
          active = false;
          error = "Must input more than 10 characters";
        });
        return;
      }
      setState(() {
        active = false;
      });
      if (await Provider.of<DashModel>(context, listen: false).sendFeedback(feedback)) {
        feedbackController.text = "";
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(Provider.of<DashModel>(context, listen: false).success),
        ));
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(Provider.of<DashModel>(context, listen: false).error),
        ));
      }
      setState(() {
        active = true;
      });
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            dashState.getTranslation(code: "mob_app_feedback"),
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      dashState.getTranslation(code:"mob_app_enter_message"),
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: feedbackController,
                      keyboardType: TextInputType.multiline,
                      minLines: 8,
                      maxLines: null,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0, color: Colors.blueAccent)
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0, color: Colors.black12)
                        ),
                        hintText: dashState.getTranslation(code: "mob_app_enter_message")
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: IgnorePointer(
                        ignoring: !active,
                        child: ButtonTheme(
                          height: 48.0,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          buttonColor: hexToColor('#23a0ff'),
                          child: RaisedButton(
                            child: Text(
                              dashState.getTranslation(
                                  code: 'mob_app_send'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async => await sendFeedback()
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

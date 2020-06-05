import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/resources/decimal.dart';

class MetersModal extends StatefulWidget {
  final MeterData data;
  const MetersModal({Key key, this.data}) : super(key: key);
  @override
  _MetersModalState createState() => _MetersModalState();
}

class _MetersModalState extends State<MetersModal> {
  void clearText() {
    setState(() {
      readingController.text = '';
    });
  }
  final TextEditingController readingController = TextEditingController();
  bool _shouldIgnore;
  @override
  void dispose() {
    readingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    readingController.addListener(_checkReading);
    _shouldIgnore = true;
  }

  _checkReading() {
    if (readingController.text.isNotEmpty) {
      double reading = double.parse(readingController.text);
      var multiplier = Provider.of<DashModel>(context, listen: false)
          .selectedMeter
          .multiplier;
      if (reading <=
          Provider.of<DashModel>(context, listen: false)
              .selectedMeter
              .lastReading['value']) {
        Provider.of<DashModel>(context, listen: false).updateWarning(
            'The selected reading is lower than the last reading');
        setState(() {
          _shouldIgnore = true;
        });
      } else {
        Provider.of<DashModel>(context, listen: false).updateWarning('');
        double spending = (reading -
                Provider.of<DashModel>(context, listen: false)
                    .selectedMeter
                    .lastReading['value']) *
            multiplier;
        Provider.of<DashModel>(context, listen: false).updateSpending(spending);
        if (Provider.of<DashModel>(context, listen: false)
                .selectedMeter
                .avgReading
                .isNotEmpty &&
            spending >
                Provider.of<DashModel>(context, listen: false)
                    .selectedMeter
                    .avgReading['value']) {
          Provider.of<DashModel>(context, listen: false)
              .updateWarning('The spending higher than average.');
          setState(() {
            _shouldIgnore = true;
          });
        }
        if (spending >
            Provider.of<DashModel>(context, listen: false)
                .selectedMeter
                .limit) {
          Provider.of<DashModel>(context, listen: false)
              .updateWarning('Exceeded the spending limit');
        }
      }
    } else {
      Provider.of<DashModel>(context, listen: false).updateWarning('');
      setState(() {
        _shouldIgnore = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(0.0),
        content: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 16.0),
                  child: Text(
                    'Ievadīt datus',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 16.0),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(color: hexToColor('#d6dde3')),
                    bottom: BorderSide(color: hexToColor('#d6dde3')),
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('Jaunais rādījums'),
                      ),
                      Container(
                        width: 120,
                        height: 40,
                        child: TextField(
                          maxLength: Provider.of<DashModel>(context).maxLength +
                              (Provider.of<DashModel>(context)
                                          .selectedMeter
                                          .signsAfter !=
                                      0
                                  ? 1
                                  : 0),
                          maxLengthEnforced: true,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          controller: readingController,
                          inputFormatters: [
                            DecimalTextInputFormatter(
                                decimalRange: Provider.of<DashModel>(context)
                                    .selectedMeter
                                    .signsAfter,
                                before: Provider.of<DashModel>(context)
                                    .selectedMeter
                                    .signsBefore)
                          ],
                          decoration: InputDecoration(
                              counterText: "",
                              contentPadding: EdgeInsets.only(bottom: 13),
                              border: InputBorder.none,
                              hintText: '00.000'),
                        ),
                      )
                    ],
                  ),
                ),
                Provider.of<DashModel>(context).warning.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Text(
                          Provider.of<DashModel>(context).warning,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
                  child: ButtonTheme(
                    height: 40.0,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    buttonColor: hexToColor('#e5edf3'),
                    child: RaisedButton(
                      elevation: 0,
                      child: Text(
                        'Ielēgt zibspuldzi',
                        style: TextStyle(
                            color: hexToColor('#3e4a5e'),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async {},
                      // onPressed: _isButtonDisabled ? null : _updateEmail,
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: _shouldIgnore,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0),
                    child: ButtonTheme(
                      height: 40.0,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      buttonColor: hexToColor('#23a0ff'),
                      child: RaisedButton(
                        elevation: 0,
                        child: Text(
                          'Saglabāt',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () async {},
                        // onPressed: _isButtonDisabled ? null : _updateEmail,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 24.0),
                  child: ButtonTheme(
                    height: 40.0,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    buttonColor: hexToColor('#e5edf3'),
                    child: RaisedButton(
                      elevation: 0,
                      child: Text(
                        'Atcelt',
                        style: TextStyle(
                            color: hexToColor('#3e4a5e'),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      // onPressed: _isButtonDisabled ? null : _updateEmail,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

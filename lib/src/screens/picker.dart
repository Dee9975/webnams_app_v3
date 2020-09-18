import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:torch_compat/torch_compat.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/resources/db_provider.dart';

class MeterPicker extends StatefulWidget {
  final MeterData selectedMeter;
  const MeterPicker({Key key, this.selectedMeter}) : super(key: key);

  @override
  _MeterPickerState createState() => _MeterPickerState(selectedMeter);
}

class _MeterPickerState extends State<MeterPicker> with WidgetsBindingObserver {
  final MeterData selectedMeter;
  _MeterPickerState(this.selectedMeter);

  int currentValue = 0;
  Map<int, int> afterData = {};
  Map<int, int> data = {};
  bool _shouldIgnore = false;
  String warning;
  double spending;
  bool loading = false;
  bool flash;
  Icon flashIcon = Icon(
    Icons.flash_on,
    color: hexToColor('#23A0FF'),
  );

  final DbProvider dbProvider = DbProvider.instance;

  num result;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    int before = selectedMeter.signsBefore;
    int after = selectedMeter.signsAfter;
    var predicted = selectedMeter.readingPrediction;
    flash = false;

    for (int i = 0; i < before; i++) {
      setState(() {
        data.putIfAbsent(i, () => 0);
      });
    }
    if (after > 0) {
      for (int i = 0; i < after; i++) {
        setState(() {
          afterData.putIfAbsent(i, () => 0);
        });
      }
    }
    // check if reading prediction exists
    if (predicted != null) {
      // convert the prediction into a string for manipulating it
      String pred = predicted.toString();
      // check if the prediction is a decimal
      if (pred.contains('.')) {
        // split the number by the decimal point
        List<String> splitPred = pred.split('.');
        // if the length of the before decimal count is equal to the length of the predicted before count update the whole first half
        if (splitPred[0].length == before) {
          for (int i = 0; i < before; i++) {
            setState(() {
              data.update(i, (value) => int.parse(splitPred[0][i]));
            });
          }
          // if the length of the predicted value's before count is smaller than the given count
          // fill in the missing space with 0's
        } else if (splitPred[0].length < before) {
          //difference between the before count and the prediction's first half's length
          int difference = before - splitPred[0].length;
          // the index of the string that's about to be inserted
          int stringIndex = 0;
          for (int i = 0; i < before; i++) {
            if (i < difference) {
              continue;
            } else {
              setState(() {
                data.update(i, (value) {
                  return int.parse(splitPred[0][stringIndex]);
                });
              });
              stringIndex++;
            }
          }
        }

        if (after > 0) {
          if (splitPred[1] != null) {
            if (splitPred[1].length == after) {
              for (int i = 0; i < after; i++) {
                setState(() {
                  afterData.update(i, (value) => int.parse(splitPred[1][i]));
                });
              }
            } else if (splitPred[1].length < after) {
              int difference = after - splitPred[1].length;
              int stringIndex = 0;
              for (int i = 0; i < after; i++) {
                if (i < difference) {
                  continue;
                } else {
                  setState(() {
                    afterData.update(
                        i, (value) => int.parse(splitPred[1][stringIndex]));
                  });
                  stringIndex++;
                }
              }
            }
          }
        }
      } else {
        if (pred.length < before) {
          int difference = before - pred.length;
          int stringIndex = 0;
          for (int i = 0; i < before; i++) {
            if (i < difference) {
              continue;
            } else {
              setState(() {
                data.update(i, (value) => int.parse(pred[stringIndex]));
              });
              stringIndex++;
            }
          }
        }
      }
    }
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    bool hasTorch = await TorchCompat.hasTorch;
    if (hasTorch) {
      if (state == AppLifecycleState.paused) {
        await TorchCompat.turnOff();
      } else if (state == AppLifecycleState.resumed && flash) {
        await TorchCompat.turnOn();
        setState(() {
          flashIcon = Icon(
            Icons.flash_off,
            color: hexToColor('#23A0FF'),
          );
        });
      }
    }
  }

  Widget build(BuildContext context) {
    DashModel dashState = Provider.of<DashModel>(context);

    List<Widget> pickers = [];
    String result = '';
    num parsedResult;

    Map<String, String> translations = {
      'mob_app_reading_too_low':
          dashState.getTranslation(code: 'mob_app_reading_too_low'),
      'mob_app_consumption_ower_average':
          dashState.getTranslation(code: 'mob_app_consumption_ower_average'),
      'mob_app_consumption_too_big':
          dashState.getTranslation(code: 'mob_app_consumption_too_big'),
    };

    Future<void> updateFlash() async {
      bool hasTorch = await TorchCompat.hasTorch;
      setState(() {
        flash = !flash;
      });
      if (hasTorch) {
        if (flash) {
          await TorchCompat.turnOn();
          setState(() {
            flashIcon = Icon(
              Icons.flash_off,
              color: hexToColor('#23A0FF'),
            );
          });
        } else {
          await TorchCompat.turnOff();
          setState(() {
            flashIcon = Icon(
              Icons.flash_on,
              color: hexToColor('#23A0FF'),
            );
          });
        }
      }
    }

    void _checkReading(String result) {
      if (result != null) {
        double reading = double.parse(result);
        var multiplier = selectedMeter.multiplier;
        if (selectedMeter.lastReading != null &&
            selectedMeter.lastReading['value'] != 0 &&
            selectedMeter.lastReading != null &&
            selectedMeter.lastReading['value'] != 0) {
          if ((selectedMeter.lastReading['value'] +
                      (selectedMeter.avgReading['value'] * 2)) >
                  double.parse(selectedMeter.lastReading['string_value']) &&
              reading < selectedMeter.lastReading['value']) {
            setState(() {
              warning = translations['mob_app_reading_too_low'];
              _shouldIgnore = true;
            });
          } else {
            double sp =
                (reading - selectedMeter.lastReading['value']) * multiplier;
            setState(() {
              spending = sp;
              _shouldIgnore = false;
            });
            if (selectedMeter.avgReading.isNotEmpty &&
                spending > selectedMeter.avgReading['value']) {
              setState(() {
                warning = translations['mob_app_consumption_ower_average'];
              });
            }
            if (spending > selectedMeter.limit) {
              setState(() {
                warning = translations['mob_app_consumption_too_big'];
                _shouldIgnore = false;
              });
            } else {
              setState(() {
                warning = '';
              });
            }
          }
        } else {
          setState(() {
            _shouldIgnore = false;
            warning = '';
          });
        }
      } else {
        setState(() {
          warning = '';
          _shouldIgnore = true;
        });
      }
    }

    void generateResult() {
      setState(() {
        data.forEach((key, value) {
          result += value.toString();
        });
        if (selectedMeter.signsAfter > 0) {
          result += '.';
          afterData.forEach((key, value) {
            result += value.toString();
          });
        }
      });
    }

    for (int i = 0; i < data.length; i++) {
      setState(() {
        pickers.add(
          NumberPicker.integer(
              highlightSelectedValue: true,
              infiniteLoop: true,
              listViewWidth: 30,
              index: i,
              count: data.length + afterData.length,
              initialValue: data[i],
              minValue: 0,
              maxValue: 9,
              onChanged: (newVal) {
                setState(() {
                  data.update(i, (value) {
                    return newVal;
                  });
                });
              }),
        );
      });
    }

    if (selectedMeter.signsAfter > 0) {
      setState(() {
        pickers.add(Text(
          ',',
          style: TextStyle(fontSize: 36),
        ));
      });
      for (int i = 0; i < afterData.length; i++) {
        setState(() {
          pickers.add(
            NumberPicker.integer(
                highlightSelectedValue: true,
                infiniteLoop: true,
                listViewWidth: 30,
                index: i + 1 + data.length,
                count: selectedMeter.signsBefore + selectedMeter.signsAfter,
                initialValue: afterData[i],
                minValue: 0,
                maxValue: 9,
                onChanged: (newVal) {
                  setState(() {
                    afterData.update(i, (value) {
                      return newVal;
                    });
                  });
                }),
          );
        });
      }
    }

    generateResult();
    _checkReading(result);

    return !loading ? WillPopScope(
      onWillPop: () async {
        if (await TorchCompat.hasTorch) {
          await TorchCompat.turnOff();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            dashState.getTranslation(code: 'mob_app_input_title'),
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(dashState.getTranslation(code: 'mob_app_last')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  selectedMeter.lastReading['string_value'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                        border: Border.symmetric(
                            vertical: BorderSide(color: Colors.red))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pickers,
                  ),
                ]),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dashState.selectedImage != null
                  ? Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 96,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: FractionalOffset(0.5, 0.25),
                                image: FileImage(File(dashState.selectedImage.path))
                              )
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            right: -20.0,
                            child: FlatButton(
                              onPressed: () async {
                                dashState.updateSelectedImage(
                                    image: null, delete: true);
                              },
                              child: Container(
                                width: 33,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0)),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Offstage(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  warning ?? '',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: ButtonTheme(
                      height: 40.0,
                      minWidth: MediaQuery.of(context).size.width - 106,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      buttonColor: hexToColor('#e5edf3'),
                      child: RaisedButton(
                        elevation: 0,
                        child: Text(
                          dashState.getTranslation(code: 'mob_app_open_camera'),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          Navigator.pushNamed(context, '/meters_camera');
                        },
                        // onPressed: _isButtonDisabled ? null : _updateEmail,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, right: 16.0, bottom: 8.0),
                    child: ButtonTheme(
                      height: 40.0,
                      minWidth: 65,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      buttonColor: hexToColor('#e5edf3'),
                      child: RaisedButton(
                        elevation: 0,
                        child: flashIcon,
                        onPressed: () async {
                          updateFlash();
                        },
                        // onPressed: _isButtonDisabled ? null : _updateEmail,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: IgnorePointer(
                  ignoring: _shouldIgnore,
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
                        dashState.getTranslation(code: 'mob_app_save'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async {
                        if (selectedMeter.signsAfter > 0) {
                          await dashState.sendReading(double.parse(result));
                        } else {
                          await dashState.sendReading(int.parse(result));
                        }
                        setState(() {
                          loading = true;
                        });
                        await dashState.refreshMeters();
                        await dashState.refreshHome();
                        setState(() {
                          loading = false;
                        });
                        if (await TorchCompat.hasTorch) {
                          await TorchCompat.turnOff();
                        }
                        Navigator.pop(context);
                      },
                      // onPressed: _isButtonDisabled ? null : _updateEmail,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
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
                      dashState.getTranslation(code: 'mob_app_cancel'),
                      style: TextStyle(
                          color: hexToColor('#3e4a5e'),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      if (await TorchCompat.hasTorch) {
                        await TorchCompat.turnOff();
                      }
                      Navigator.pop(context);
                    },
                    // onPressed: _isButtonDisabled ? null : _updateEmail,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ) : Scaffold(body: Center(child: CircularProgressIndicator(),),);
  }
}
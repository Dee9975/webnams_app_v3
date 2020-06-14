import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';

class MeterPicker extends StatefulWidget {
  const MeterPicker({Key key}) : super(key: key);

  @override
  _MeterPickerState createState() => _MeterPickerState();
}

class _MeterPickerState extends State<MeterPicker> {
  Map<int, int> data = {};
  Map<int, int> afterData = {};

  Widget build(BuildContext context) {
    DashModel dashState = Provider.of<DashModel>(context);
    MeterData meter = dashState.meters.data[0];
    List<Widget> pickers = [];

    String generateResult() {
      String res = '';

      data.forEach((key, value) {
        res += value.toString();
      });
      if (meter.signsAfter > 0) {
        res += ',';

      }
      return res;
    }
    for (int i = 0; i <= meter.signsBefore; i++) {
      setState(() {
        data.putIfAbsent(i, () => 0);
      });
      pickers.add(
        NumberPicker.integer(
            highlightSelectedValue: true,
            infiniteLoop: true,
            listViewWidth: 30,
            initialValue: 0,
            minValue: 0,
            maxValue: 9,
            onChanged: (newVal) {
              setState(() {
                data.update(i, (value) => newVal);
              });
            }),
      );
    }
    if (meter.signsAfter > 0) {
      pickers.add(Text(
        ',',
        style: TextStyle(fontSize: 36),
      ));
      for (int i = 0; i <= meter.signsAfter; i++) {
        pickers.add(
          NumberPicker.integer(
              infiniteLoop: true,
              listViewWidth: 30,
              initialValue: 0,
              minValue: 0,
              maxValue: 9,
              onChanged: (newVal) {}),
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Meters test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(generateResult(), style: TextStyle(fontSize: 24),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: pickers,
            ),
          ],
        ),
      ),
    );
  }
}
// valdiku 36

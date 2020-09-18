import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webnams_app_v3/src/models/bills/data.dart' as BarcodeData;

class BarcodeScreen extends StatefulWidget {
  final BarcodeData.Barcode data;
  BarcodeScreen({Key key, @required this.data}) : super(key: key);

  @override
  _BarcodeScreenState createState() => _BarcodeScreenState(data: data);
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  final BarcodeData.Barcode data;
  _BarcodeScreenState({@required this.data});
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String buildBarcode(Barcode bc, String data,
        {String filename, double width, double height, double fontHeight}) {
      return bc.toSvg(data, fontHeight: 5);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(data.name),
        ),
        body: Center(
          child: Container(
            width: 410,
              height: 160,
              child: SvgPicture.string(
            buildBarcode(Barcode.code128(), data.data),
            allowDrawingOutsideViewBox: true,
                fit: BoxFit.fill,
          )),
        ));
  }
}

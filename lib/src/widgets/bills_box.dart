import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/bills/data.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/resources/my_flutter_app_icons.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class BillsBox extends StatelessWidget {
  final BillsData data;

  BillsBox(this.data) : assert(data != null);
  @override
  Widget build(BuildContext context) {
    final dashState = Provider.of<DashModel>(context);
    if (data.amountUnpayd <= 0) {
      return Offstage();
    }
    return GestureDetector(
      onTap: () {
        Provider.of<DashModel>(context, listen: false).updateSelectedBill(data);
        Navigator.pushNamed(context, '/bill');
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.0, 2.0),
                  blurRadius: 1.0,
                  spreadRadius: -1.0,
                  color: _kKeyUmbraOpacity),
              BoxShadow(
                  offset: Offset(0.0, 1.0),
                  blurRadius: 1.0,
                  spreadRadius: 0.0,
                  color: _kKeyPenumbraOpacity),
              BoxShadow(
                  offset: Offset(0.0, 1.0),
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                  color: _kAmbientShadowOpacity),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 10.0),
                  child: Icon(
                    MyFlutterApp.rekins,
                    color: hexToColor('#8d96a4'),
                    size: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: data.amountUnpayd <= 0
                      ? Text(
                          dashState.getTranslation(code: 'mob_app_paid'),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: hexToColor('#8d96a4')),
                        )
                      : Text(
                          dashState.getTranslation(code: 'mob_app_unpaid'),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: hexToColor('#8d96a4')),
                        ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${dashState.getTranslation(code: 'mob_app_bill_nr')}: ${data.iD}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${data.amountToPay} €',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Text(
                '${dashState.getTranslation(code: 'mob_app_due')}: ${data.date}',
                style: TextStyle(
                    fontSize: 16.0,
                    color: data.amountUnpayd <= 0
                        ? hexToColor('#8d96a4')
                        : hexToColor('#ff1303')),
              ),
            )
          ],
        ),
      ),
    );
  }
}

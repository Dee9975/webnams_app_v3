import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

class Bill extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final dashState = Provider.of<DashModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${dashState.getTranslation(code: 'mob_app_no')} ${Provider.of<DashModel>(context).selectedBill.number}',
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: hexToColor('#030303')),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          dashState.debugError != null ? Text(dashState.debugError) : Offstage(),
          Padding(
            padding: const EdgeInsets.only(left: 19.0, top: 24.0),
            child: Text(
              '${dashState.getTranslation(code: 'mob_app_no')} ${Provider.of<DashModel>(context).selectedBill.number}',
              style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: hexToColor('#222e42')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 6.0),
            child: Text(
              '${dashState.getTranslation(code: 'mob_app_client_code')} ${Provider.of<DashModel>(context).selectedAddress.personId}',
              style: TextStyle(fontSize: 14.0, color: hexToColor('#8d96a4')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dashState.getTranslation(code: 'mob_app_bill_amount'), style: TextStyle(fontSize: 16.0),),
                Text(
                  '${Provider.of<DashModel>(context).selectedBill.amountToPay} €',
                  style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dashState.getTranslation(code: 'mob_app_due'), style: TextStyle(fontSize: 16.0),),
                Text(
                  '${Provider.of<DashModel>(context).selectedBill.date}',
                  style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Provider.of<DashModel>(context).selectedBill.files.invoice != null ?
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
            child: ButtonTheme(
              height: 48.0,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              buttonColor: hexToColor('#23a0ff'),
              child: RaisedButton(
                child: Text(dashState.getTranslation(code: 'mob_app_download'), style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),),
                onPressed: () async {
//                  await Provider.of<DashModel>(context, listen: false).downloadPdf();
                  Navigator.pushNamed(context, '/pdf');
                },
              ),
            ),
          ) : Offstage()
        ],
      ),
    );
  }
}

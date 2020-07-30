import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      body: BillBody(),
    );
  }
}

class BillBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashState = Provider.of<DashModel>(context);
    void copyToClipboard() {
      ClipboardManager.copyToClipBoard(
          Provider.of<DashModel>(context,
              listen: false)
              .selectedBill
              .number)
          .then((value) {
        final snackbar = SnackBar(
          content: Text(dashState.getTranslation(code: "mob_app_copied")),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        dashState.debugError != null
            ? Text(dashState.debugError)
            : Offstage(),
        Row(
          children: [
            GestureDetector(
              onTap: copyToClipboard,
              child: Padding(
                padding: const EdgeInsets.only(left: 19.0, top: 24.0),
                child: Text(
                  '${dashState.getTranslation(code: 'mob_app_no')} ${Provider.of<DashModel>(context).selectedBill.number}',
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                      color: hexToColor('#222e42')),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Container(
                child: ButtonTheme(
                  minWidth: 24,
                  child: FlatButton(
                      onPressed: copyToClipboard,
                      child: Icon(Icons.content_copy)),
                ),
              ),
            )
          ],
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
              Text(
                dashState.getTranslation(code: 'mob_app_address'),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${Provider.of<DashModel>(context).selectedAddress.addressName}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                dashState.getTranslation(code: 'mob_app_period'),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${Provider.of<DashModel>(context).selectedBill.billPeriod}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                dashState.getTranslation(code: 'mob_app_bill_created'),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${Provider.of<DashModel>(context).selectedBill.createDate}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                dashState.getTranslation(code: 'mob_app_counted'),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${Provider.of<DashModel>(context).selectedBill.amountCalculated} €',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                dashState.getTranslation(code: 'mob_app_amount'),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${Provider.of<DashModel>(context).selectedBill.amountToPay} €',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                dashState.getTranslation(code: 'mob_app_due'),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${Provider.of<DashModel>(context).selectedBill.date}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
//          Padding(
//            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Text("Datums", style: TextStyle(fontSize: 16.0),),
//                Text(
//                  DateFormat.yMMMM("lv_LV").format(DateTime.parse(Provider.of<DashModel>(context).selectedBill.billDate)),
//                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
//                ),
//              ],
//            ),
//          ),

        Provider.of<DashModel>(context).selectedBill.files.invoice != null
            ? Padding(
          padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
          child: ButtonTheme(
            height: 48.0,
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            buttonColor: hexToColor('#23a0ff'),
            child: RaisedButton(
              child: Text(
                dashState.getTranslation(code: 'mob_app_download'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () async {
//                  await Provider.of<DashModel>(context, listen: false).downloadPdf();
                Navigator.pushNamed(context, '/pdf');
              },
            ),
          ),
        )
            : Offstage(),
      ],
    );
  }
}

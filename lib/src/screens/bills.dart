import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/resources/my_flutter_app_icons.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class Bills extends StatefulWidget {
  const Bills({Key key}) : super(key: key);
  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  bool add = false;
  bool loading = false;
  Future<void> updateSelectedBill(int index) async {
    setState(() {
      loading = true;
      add = true;
    });
    Provider.of<DashModel>(context, listen: false)
        .updateSelectedBill(
        Provider.of<DashModel>(context, listen: false)
            .bills
            .data[index])
        .then((value) {
          setState(() {
            loading = false;
          });
          Navigator.pushNamed(context, '/bill');
    });
  }
  @override
  Widget build(BuildContext context) {
    final dashState = Provider.of<DashModel>(context);
    if (loading || dashState.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (dashState.bills.data.isEmpty) {
      return Center(
        child: Text(dashState.bills.message),
      );
    }
    return ListView.builder(
      itemCount: Provider.of<DashModel>(context).bills.rows,
      itemBuilder: (context, int index) {
        if (Provider.of<DashModel>(context).bills.data[index].type == 5) {
          return Offstage();
        }
        return GestureDetector(
          onTap: () async {
            await updateSelectedBill(index);
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
                      child: Provider.of<DashModel>(context)
                                  .bills
                                  .data[index]
                                  .amountUnpayd <=
                              0
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
                        '${dashState.getTranslation(code: 'mob_app_bill_nr')}: ${Provider.of<DashModel>(context).bills.data[index].number}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        '${Provider.of<DashModel>(context).bills.data[index].amountToPay} €',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Text(
                    '${dashState.getTranslation(code: 'mob_app_due')}: ${Provider.of<DashModel>(context).bills.data[index].date}',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Provider.of<DashModel>(context)
                                    .bills
                                    .data[index]
                                    .amountUnpayd <=
                                0
                            ? hexToColor('#8d96a4')
                            : hexToColor('#ff1303')),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/bills/data.dart';
import 'package:webnams_app_v3/src/models/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/widgets/bills_box.dart';
import 'package:webnams_app_v3/src/widgets/meters_box.dart';
import 'package:webnams_app_v3/src/widgets/payment_warning.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: hexToColor('#23a0ff'),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, left: 24.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: PaymentWarning(),
                        ),
                        Text(
                          '20,00 €',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      'Esošais atlikums',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, bottom: 24.0, top: 16.0),
                    child: Text(
                      'Visi rēķini apmaksāti!',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 11,
                right: 0,
                child: Container(
                    height: 92, child: Image.asset('assets/card_houses.png')),
              )
            ],
          ),
        ),
        !Provider.of<DashModel>(context).isLoading
            ? Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 8.0),
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: Provider.of<DashModel>(context).homeList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      if (Provider.of<DashModel>(context).homeList[index]
                          is BillsData) {
                        return BillsBox(
                            Provider.of<DashModel>(context).homeList[index]);
                      } else if (Provider.of<DashModel>(context).homeList[index] is MeterData) {
                        return MetersBox(Provider.of<DashModel>(context).homeList[index]);
                      }
                      return null;
                    },
                  ),
                ),
              )
            : Expanded(
                // 1st use Expanded
                child: Center(
                    child:
                        CircularProgressIndicator()), // 2nd wrap your widget in Center
              ),
//        RaisedButton(
//          onPressed: () => (Navigator.pushNamed(context, '/login')),
//          child: Text('Atgriezties uz login'),
//        ),
      ],
    );
  }
}

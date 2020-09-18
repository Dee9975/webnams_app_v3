import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/meter_history_data.dart';
import 'package:supercharged/supercharged.dart';
import 'package:webnams_app_v3/src/resources/my_flutter_app_icons.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); //

class MeterHistory extends StatefulWidget {
  const MeterHistory({Key key}) : super(key: key);

  @override
  _MeterHistoryState createState() => _MeterHistoryState();
}

class _MeterHistoryState extends State<MeterHistory> {
  TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController();
    nameController.addListener(() {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MeterHistoryData dashState = Provider.of<DashModel>(context).history;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(MyFlutterApp.skait, color: dashState.data[0].color.toColor(),),
            ),
            Text(
              dashState.data[0].type.length > 13 ? "${dashState.data[0].type.substring(0, 12)}..." : dashState.data[0].type,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Icon(Icons.edit, size: 17.0,),
            onPressed: () {
              nameController.text = Provider.of<DashModel>(context, listen: false).history.data[0].type;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(Provider.of<DashModel>(context, listen: false).getTranslation(code: "mob_app_meters_name_placeholder")),
                    contentPadding: EdgeInsets.zero,
                    content: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                height: 48.0,
                                child: TextField(
                                  controller: nameController,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(60)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(60),
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent))),
                                  autofocus: true,
                                ),
                              ),
                              !Provider.of<DashModel>(context).isLoading ? Container(
                                height: 170,
                                width: 300,
                                margin: EdgeInsets.only(top: 16.0),
                                child: ListView.builder(
                                  itemBuilder: (context, int index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: index == 0
                                              ? BorderSide(color: '#d6dde3'.toColor())
                                              : BorderSide(
                                              width: 0, color: '#d6dde3'.toColor()),
                                          bottom:
                                          BorderSide(color: '#d6dde3'.toColor()),
                                        ),
                                      ),
                                      child: Center(
                                          child: FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                nameController.text = Provider.of<DashModel>(
                                                    context,
                                                    listen: false)
                                                    .history
                                                    .data[0]
                                                    .nameSuggestions[index];
                                                FocusScope.of(context).unfocus();
                                              });
                                            },
                                            child: Text(Provider.of<DashModel>(
                                                context,
                                                listen: false)
                                                .history
                                                .data[0]
                                                .nameSuggestions[index]),
                                          )),
                                    );
                                  },
                                  shrinkWrap: true,
                                  itemCount: Provider.of<DashModel>(context,
                                      listen: false)
                                      .history
                                      .data[0]
                                      .nameSuggestions
                                      .length,
                                ),
                              ) : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                                child: ButtonTheme(
                                  height: 48.0,
                                  minWidth: double.infinity,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  buttonColor: '#23a0ff'.toColor(),
                                  child: RaisedButton(
                                    child: Text(
                                      "Rename",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () async {
                                      if (await Provider.of<DashModel>(context,
                                          listen: false)
                                          .renameMeter(nameController.text)) {
                                        await Provider.of<DashModel>(context,
                                            listen: false)
                                            .refreshMeters();
                                        await Provider.of<DashModel>(context,
                                            listen: false)
                                            .getHistory(Provider.of<DashModel>(context, listen: false).history.data[0].iD);
                                        Navigator.pop(context);
                                      }
                                    },
                                    // onPressed: _isButtonDisabled ? null : _updateEmail,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });},
          )
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 24.0),
            child: Text(
              Provider.of<DashModel>(context)
                  .getTranslation(code: "mob_app_meter_data"),
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          )),
          SliverToBoxAdapter(
              child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, bottom: 24.0, right: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Provider.of<DashModel>(context)
                          .getTranslation(code: "mob_app_number"),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dashState.data[0].number,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Provider.of<DashModel>(context)
                          .getTranslation(code: "mob_app_meter_mounted"),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dashState.data[0].installed,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Provider.of<DashModel>(context)
                          .getTranslation(code: "mob_app_meter_next_check"),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dashState.data[0].nextCheck ?? "",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          )),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 24.0),
            child: Text(
              Provider.of<DashModel>(context)
                  .getTranslation(code: "mob_app_meter_history"),
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            dashState.data[0].readings[index].date,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Provider.of<DashModel>(context)
                                  .getTranslation(code: "mob_app_reading"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Text(
                              "${dashState.data[0].readings[index].stringValue}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                Provider.of<DashModel>(context)
                                    .getTranslation(code: "mob_app_spending"),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0)),
                            Text(
                              "${dashState.data[0].readings[index].pater}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
                childCount: Provider.of<DashModel>(context)
                    .history
                    .data[0]
                    .readings
                    .length),
          ),
        ],
      ),
    );
  }
}

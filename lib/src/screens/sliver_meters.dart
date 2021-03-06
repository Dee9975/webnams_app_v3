import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:torch_compat/torch_compat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/resources/my_flutter_app_icons.dart';
import 'package:webnams_app_v3/src/resources/translations.dart';
import 'package:webnams_app_v3/src/screens/meter_history.dart';
import 'package:webnams_app_v3/src/screens/picker.dart';
import "package:supercharged/supercharged.dart";

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class SliverMeters extends StatefulWidget {
  const SliverMeters({Key key}) : super(key: key);
  @override
  _SliverMetersState createState() => _SliverMetersState();
}

class _SliverMetersState extends State<SliverMeters>
    with WidgetsBindingObserver {
  bool _flash = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    bool hasTorch = await TorchCompat.hasTorch;
    if (hasTorch) {
      if (state == AppLifecycleState.paused) {
        await TorchCompat.turnOff();
      } else if (state == AppLifecycleState.resumed && _flash) {
        await TorchCompat.turnOn();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> updateHistory(int id) async {
      if (await Provider.of<DashModel>(context, listen: false).getHistory(id)) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => MeterHistory()
        ));
      }
    }
    Future<void> updateSelectedMeter(MeterData meter) async {
      await Provider.of<DashModel>(context, listen: false)
          .updateSelectedMeter(meter);
    }

    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool isTablet = shortestSide > 600;
    final dashState = Provider.of<DashModel>(context);

    Future<void> refreshMeters() async {
      await Provider.of<DashModel>(context, listen: false).refreshMeters();
      if (Provider.of<DashModel>(context, listen: false).hasError) {
        Map<String, String> modalTranslations = hardcodedTranslation(
            Provider.of<DashModel>(context, listen: false).dash.language ?? 0,
            Provider.of<DashModel>(context, listen: false).errorType ??
                "timeout");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(modalTranslations["title"]),
                content: Text(Provider.of<DashModel>(context).error ?? "Error"),
                actions: [
                  FlatButton(
                    onPressed: () async {
                      await refreshMeters();
                      Navigator.pop(context);
                    },
                    child: Text(modalTranslations["button"]),
                  ),
                ],
              );
            });
      }
    }

    Color setColor(String type) {
      switch(type) {
        case "Karstā ūdens skaitītājs":
          return Colors.red;
          break;
        case "Aukstā ūdens skaitītājs":
          return Colors.blue;
          break;
        case "Elektroenerģijas skaitītājs":
          return Colors.yellow;
          break;
        default:
          return Colors.grey;
      }
    }

    if (Provider.of<DashModel>(context).hasError) {
      Map<String, String> modalTranslations = hardcodedTranslation(
          Provider.of<DashModel>(context).dash.language ?? 0,
          Provider.of<DashModel>(context).errorType ?? "timeout");
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                modalTranslations["subtitle"],
                textAlign: TextAlign.center,
              ),
              FlatButton(
                child: Text(
                  modalTranslations["button"],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                onPressed: () async {
                  await refreshMeters();
                },
              ),
            ],
          ),
        ),
      );
    }
    Widget buildGrid() {
      if (!Provider.of<DashModel>(context).isLoading &&
          !Provider.of<DashModel>(context).hasError) {
        return RefreshIndicator(
          onRefresh: () async => refreshMeters(),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 24.0),
                  child: Text(
                    dashState.getTranslation(code: 'mob_app_meters_title'),
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
                  width: double.infinity,
                  height: 40,
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        left: 16.0,
                        child: Text(
                          dashState.getTranslation(code: 'mob_app_type_input'),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Positioned(
                        right: 8.0,
                        child: Icon(Icons.arrow_drop_down),
                      )
                    ],
                  ),
                ),
              ),
              SliverStaggeredGrid.countBuilder(
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                itemBuilder: (context, int index) {
                  Color dateColor =
                      DateTime.parse(dashState.meters.data[index].nextCheck)
                                  .compareTo(DateTime.now()) >
                              0
                          ? Colors.red
                          : hexToColor("#222e42");
                  return Container(
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
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                MyFlutterApp.skait,
                                color: hexToColor('#8d96a4'),
                              ),
                              Text(
                                Provider.of<DashModel>(context)
                                    .meters
                                    .data[index]
                                    .type,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: hexToColor('#8d96a4')),
                              )
                            ],
                          ),
//                        Padding(
//                          padding: const EdgeInsets.only(top: 7.0),
//                          child: Text(
//                            Provider.of<DashModel>(context)
//                                .meters
//                                .data[index]
//                                .type,
//                            style: TextStyle(
//                                fontSize: 16.0, color: hexToColor('#222e42')),
//                          ),
//                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                dashState.getTranslation(
                                    code: 'mob_app_number'),
                                style: TextStyle(
                                    color: hexToColor('#8d96a4'),
                                    fontSize: 16.0),
                              ),
                              Text(
                                Provider.of<DashModel>(context)
                                    .meters
                                    .data[index]
                                    .number,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: hexToColor('#222e42')),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                dashState.getTranslation(
                                    code: 'mob_app_expire'),
                                style: TextStyle(
                                    color: hexToColor('#8d96a4'),
                                    fontSize: 16.0),
                              ),
                              Text(
                                Provider.of<DashModel>(context)
                                    .meters
                                    .data[index]
                                    .nextCheck,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: dateColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                dashState.getTranslation(code: 'mob_app_last'),
                                style: TextStyle(
                                    color: hexToColor('#8d96a4'),
                                    fontSize: 16.0),
                              ),
                              Text(
                                '${Provider.of<DashModel>(context).meters.data[index].lastReading['string_value']}',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: hexToColor('#222e42')),
                              ),
                            ],
                          ),
                          Provider.of<DashModel>(context)
                                      .meters
                                      .data[index]
                                      .currentReading !=
                                  0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      dashState.getTranslation(
                                          code: 'mob_app_reading'),
                                      style: TextStyle(
                                          color: hexToColor('#8d96a4'),
                                          fontSize: 16.0),
                                    ),
                                    Text(
                                      '${Provider.of<DashModel>(context).meters.data[index].currentReading}',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: hexToColor('#222e42')),
                                    ),
                                  ],
                                )
                              : Offstage(),
                          Provider.of<DashModel>(context)
                                      .meters
                                      .data[index]
                                      .currentConsumption !=
                                  0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      dashState.getTranslation(
                                          code: 'mob_app_spending'),
                                      style: TextStyle(
                                          color: hexToColor('#8d96a4'),
                                          fontSize: 16.0),
                                    ),
                                    Text(
                                      '${Provider.of<DashModel>(context).meters.data[index].currentConsumption}',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: hexToColor('#09cb64')),
                                    ),
                                  ],
                                )
                              : Offstage(),
                          Provider.of<DashModel>(context)
                                      .meters
                                      .data[index]
                                      .editable &&
                                  !Provider.of<DashModel>(context)
                                      .meters
                                      .data[index]
                                      .hideWeb
                              ? Provider.of<DashModel>(context)
                                          .meters
                                          .data[index]
                                          .currentConsumption ==
                                      0
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 8.0),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        heightFactor: 1.8,
                                        child: ButtonTheme(
                                          height: 40.0,
                                          minWidth: double.infinity,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          buttonColor: hexToColor('#23a0ff'),
                                          child: RaisedButton(
                                            child: Text(
                                              dashState.getTranslation(
                                                  code: 'mob_app_input'),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            onPressed: () async {
                                              await updateSelectedMeter(
                                                  Provider.of<DashModel>(
                                                          context,
                                                          listen: false)
                                                      .meters
                                                      .data[index]);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              MeterPicker(
                                                                selectedMeter:
                                                                    dashState
                                                                        .meters
                                                                        .data[index],
                                                              )));
                                            },
                                            // onPressed: _isButtonDisabled ? null : _updateEmail,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 8.0),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        heightFactor: 1,
                                        child: ButtonTheme(
                                          height: 40.0,
                                          minWidth: double.infinity,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          buttonColor: hexToColor('#23a0ff'),
                                          child: RaisedButton(
                                            child: Text(
                                              dashState.getTranslation(
                                                  code: 'mob_app_edit'),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            onPressed: () async {
                                              await updateSelectedMeter(
                                                  Provider.of<DashModel>(
                                                          context,
                                                          listen: false)
                                                      .meters
                                                      .data[index]);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              MeterPicker(
                                                                selectedMeter:
                                                                    dashState
                                                                        .meters
                                                                        .data[index],
                                                              )));
                                            },
                                            // onPressed: _isButtonDisabled ? null : _updateEmail,
                                          ),
                                        ),
                                      ),
                                    )
                              : Offstage(),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: Provider.of<DashModel>(context).meters.rows,
                crossAxisCount: 2,
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    }

    Widget buildList() {
      if (!Provider.of<DashModel>(context).isLoading) {
        return RefreshIndicator(
          onRefresh: () async => refreshMeters(),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 24.0, bottom: 24.0),
                  child: Text(
                    dashState.getTranslation(code: 'mob_app_meters_title'),
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, int index) {
                  DateFormat format = new DateFormat("d.m.y");
                  Color dateColor = dashState.meters.data[index].nextCheck != ""
                      ? format
                                  .parse(dashState.meters.data[index].nextCheck)
                                  .compareTo(DateTime.now()) <
                              0
                          ? Colors.red
                          : hexToColor("#222e42")
                      : hexToColor("#222e42");
                  Color dateLabelColor = dashState
                              .meters.data[index].nextCheck !=
                          ""
                      ? format
                                  .parse(dashState.meters.data[index].nextCheck)
                                  .compareTo(DateTime.now()) <
                              0
                          ? Colors.red
                          : hexToColor("#8d96a4")
                      : hexToColor("#8d96a4");
                  return GestureDetector(
                    onTap: () async {
                      await updateHistory(Provider.of<DashModel>(context, listen:false).meters.data[index].id);
                    },
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
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  MyFlutterApp.skait,
                                  color: Provider.of<DashModel>(context).meters.data[index].color.toColor(),
                                ),
                                Text(
                                  Provider.of<DashModel>(context)
                                      .meters
                                      .data[index]
                                      .type,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: hexToColor('#8d96a4')),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  dashState.getTranslation(
                                      code: 'mob_app_number'),
                                  style: TextStyle(
                                      color: hexToColor('#8d96a4'),
                                      fontSize: 16.0),
                                ),
                                Text(
                                  Provider.of<DashModel>(context)
                                      .meters
                                      .data[index]
                                      .number,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: hexToColor('#222e42')),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  dashState.getTranslation(
                                      code: 'mob_app_expire'),
                                  style: TextStyle(
                                      color: dateLabelColor, fontSize: 16.0),
                                ),
                                Text(
                                  Provider.of<DashModel>(context)
                                      .meters
                                      .data[index]
                                      .nextCheck,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: dateColor),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  dashState.getTranslation(code: 'mob_app_last'),
                                  style: TextStyle(
                                      color: hexToColor('#8d96a4'),
                                      fontSize: 16.0),
                                ),
                                Text(
                                  '${Provider.of<DashModel>(context).meters.data[index].lastReading['string_value']}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: hexToColor('#222e42')),
                                ),
                              ],
                            ),
                            Provider.of<DashModel>(context)
                                        .meters
                                        .data[index]
                                        .currentReading !=
                                    0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        dashState.getTranslation(
                                            code: 'mob_app_reading'),
                                        style: TextStyle(
                                            color: hexToColor('#8d96a4'),
                                            fontSize: 16.0),
                                      ),
                                      Text(
                                        '${Provider.of<DashModel>(context).meters.data[index].currentReading}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: hexToColor('#222e42')),
                                      ),
                                    ],
                                  )
                                : Offstage(),
                            Provider.of<DashModel>(context)
                                        .meters
                                        .data[index]
                                        .currentConsumption !=
                                    0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        dashState.getTranslation(
                                            code: 'mob_app_spending'),
                                        style: TextStyle(
                                            color: hexToColor('#8d96a4'),
                                            fontSize: 16.0),
                                      ),
                                      Text(
                                        '${Provider.of<DashModel>(context).meters.data[index].currentConsumption}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: hexToColor('#09cb64')),
                                      ),
                                    ],
                                  )
                                : Offstage(),
                            Provider.of<DashModel>(context)
                                        .meters
                                        .data[index]
                                        .editable &&
                                    !Provider.of<DashModel>(context)
                                        .meters
                                        .data[index]
                                        .hideWeb
                                ? Provider.of<DashModel>(context)
                                            .meters
                                            .data[index]
                                            .currentConsumption ==
                                        0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 8.0),
                                        child: Center(
                                          child: ButtonTheme(
                                            height: 40.0,
                                            minWidth: isTablet
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .shortestSide /
                                                    2
                                                : double.infinity,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            buttonColor: hexToColor('#23a0ff'),
                                            child: RaisedButton(
                                              child: Text(
                                                dashState.getTranslation(
                                                    code: 'mob_app_input'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              onPressed: () async {
                                                await updateSelectedMeter(
                                                    Provider.of<DashModel>(
                                                            context,
                                                            listen: false)
                                                        .meters
                                                        .data[index]);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                MeterPicker(
                                                                  selectedMeter:
                                                                      dashState
                                                                          .meters
                                                                          .data[index],
                                                                )));
                                                ;
                                              },
                                              // onPressed: _isButtonDisabled ? null : _updateEmail,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 8.0),
                                        child: Center(
                                          child: ButtonTheme(
                                            height: 40.0,
                                            minWidth: isTablet
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .shortestSide /
                                                    2
                                                : double.infinity,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            buttonColor: hexToColor('#23a0ff'),
                                            child: RaisedButton(
                                              child: Text(
                                                dashState.getTranslation(
                                                    code: 'mob_app_edit'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              onPressed: () async {
                                                await updateSelectedMeter(
                                                    Provider.of<DashModel>(
                                                            context,
                                                            listen: false)
                                                        .meters
                                                        .data[index]);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                MeterPicker(
                                                                  selectedMeter:
                                                                      dashState
                                                                          .meters
                                                                          .data[index],
                                                                )));
                                              },
                                              // onPressed: _isButtonDisabled ? null : _updateEmail,
                                            ),
                                          ),
                                        ),
                                      )
                                : Offstage(),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: Provider.of<DashModel>(context).meters.rows),
              )
            ],
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    }

    if (isTablet) {
      return buildGrid();
    }
    return buildList();
  }
}

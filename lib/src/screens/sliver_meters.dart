import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:torch_compat/torch_compat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/resources/decimal.dart';
import 'package:webnams_app_v3/src/resources/my_flutter_app_icons.dart';

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
  final TextEditingController readingController = TextEditingController();
  bool _shouldIgnore;
  bool _flash = false;
  String _flashText;
  FocusNode _focusNode = new FocusNode();

  @override
  void dispose() {
    readingController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    readingController.addListener(_checkReading);
    _shouldIgnore = true;
  }

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

  _checkReading() {
    DashModel dashState = Provider.of(context, listen: false);

    if (readingController.text.isNotEmpty) {
      double reading = double.parse(readingController.text);
      var multiplier = dashState.selectedMeter.multiplier;
      if (reading <= dashState.selectedMeter.lastReading['value']) {
        dashState.updateWarning(
            dashState.getTranslation(code: 'mob_app_reading_too_low'));
        setState(() {
          _shouldIgnore = true;
        });
      } else {
        dashState.updateWarning('');
        double spending =
            (reading - dashState.selectedMeter.lastReading['value']) *
                multiplier;
        dashState.updateSpending(spending);
        _shouldIgnore = false;
        if (dashState.selectedMeter.avgReading.isNotEmpty &&
            spending > dashState.selectedMeter.avgReading['value']) {
          dashState.updateWarning(dashState.getTranslation(
              code: 'mob_app_consumption_ower_average'));
        }
        if (spending > dashState.selectedMeter.limit) {
          dashState.updateWarning(
              dashState.getTranslation(code: 'mob_app_consumption_too_big'));
          _shouldIgnore = true;
        }
      }
    } else {
      dashState.updateWarning('');
      _shouldIgnore = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    void updateSelectedMeter(MeterData meter) {
      Provider.of<DashModel>(context, listen: false).updateSelectedMeter(meter);
    }

    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool isTablet = shortestSide > 600;
    final dashState = Provider.of<DashModel>(context);

    Future<void> updateFlash() async {
      bool hasTorch = await TorchCompat.hasTorch;
      setState(() {
        _flash = !_flash;
      });
      if (hasTorch) {
        if (_flash) {
          await TorchCompat.turnOn();
          Provider.of<DashModel>(context, listen: false).getFlashText(_flash);
        } else {
          await TorchCompat.turnOff();
          Provider.of<DashModel>(context, listen: false).getFlashText(_flash);
        }
      }
    }

    Future<void> updateReading(var reading) async {
      if (reading != null) {
        bool res = await Provider.of<DashModel>(context, listen: false)
            .sendReading(reading);
        if (res) {
          setState(() {
            _flash = false;
          });
          if (await TorchCompat.hasTorch) {
            await TorchCompat.turnOff();
            dashState.getFlashText(false);
          }
          await dashState.refreshMeters();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Rādījums nodots!'),
            backgroundColor: hexToColor('#09cb64'),
          ));
          Navigator.pop(context);
        }
      }
    }

    Future<void> _metersDialog() async {
      String setPlaceholder() {
        MeterData state =
            Provider.of<DashModel>(context, listen: false).selectedMeter;
        String val = '';
        if (state.signsBefore != null && state.signsBefore > 0) {
          for (int i = 0; i < state.signsBefore; i++) {
            val += '0';
          }
        }
        if (state.signsAfter != null && state.signsAfter > 0) {
          val += '.';
          for (int i = 0; i < state.signsAfter; i++) {
            val += '0';
          }
        }
        return val;
      }

      setState(() {
        readingController.text = '';
      });
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(0.0),
                content: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0, left: 16.0),
                          child: Text(
                            dashState.getTranslation(
                                code: 'mob_app_input_title'),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(color: hexToColor('#d6dde3')),
                            bottom: BorderSide(color: hexToColor('#d6dde3')),
                          )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(dashState.getTranslation(
                                    code: 'mob_app_new_input')),
                              ),
                              Container(
                                width: 120,
                                height: 40,
                                child: TextField(
                                  focusNode: _focusNode,
                                  maxLength: Provider.of<DashModel>(context)
                                          .maxLength +
                                      (Provider.of<DashModel>(context)
                                                  .selectedMeter
                                                  .signsAfter !=
                                              0
                                          ? 1
                                          : 0),
                                  maxLengthEnforced: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  controller: readingController,
                                  inputFormatters: [
                                    DecimalTextInputFormatter(
                                        decimalRange:
                                            Provider.of<DashModel>(context)
                                                .selectedMeter
                                                .signsAfter,
                                        before: Provider.of<DashModel>(context)
                                            .selectedMeter
                                            .signsBefore)
                                  ],
                                  decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding:
                                          EdgeInsets.only(bottom: 13),
                                      border: InputBorder.none,
                                      hintText: _focusNode.hasPrimaryFocus
                                          ? ''
                                          : setPlaceholder()),
                                ),
                              )
                            ],
                          ),
                        ),
                        Provider.of<DashModel>(context).warning.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: Text(
                                  Provider.of<DashModel>(context).warning,
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 24.0),
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
                                dashState.flashText == null
                                    ? 'Test'
                                    : dashState.flashText,
                                style: TextStyle(
                                    color: hexToColor('#3e4a5e'),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                await updateFlash();
                              },
                              // onPressed: _isButtonDisabled ? null : _updateEmail,
                            ),
                          ),
                        ),
                        IgnorePointer(
                          ignoring: _shouldIgnore,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 8.0),
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
                                  dashState.getTranslation(
                                      code: 'mob_app_save'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () async {
                                  await updateReading(readingController.text);
                                },
                                // onPressed: _isButtonDisabled ? null : _updateEmail,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 24.0),
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
                                dashState.getTranslation(
                                    code: 'mob_app_cancel'),
                                style: TextStyle(
                                    color: hexToColor('#3e4a5e'),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _flash = false;
                                });
                                if (await TorchCompat.hasTorch) {
                                  await TorchCompat.turnOff();
                                  dashState.getFlashText(false);
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
                ));
          });
    }

    Widget buildGrid() {
      if (!Provider.of<DashModel>(context).isLoading) {
        return RefreshIndicator(
          onRefresh: () async =>
              Provider.of<DashModel>(context, listen: false).refreshMeters(),
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
                                    .lastReading['to'],
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
                                              updateSelectedMeter(
                                                  Provider.of<DashModel>(
                                                          context,
                                                          listen: false)
                                                      .meters
                                                      .data[index]);
                                              _metersDialog();
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
                                              updateSelectedMeter(
                                                  Provider.of<DashModel>(
                                                          context,
                                                          listen: false)
                                                      .meters
                                                      .data[index]);
                                              _metersDialog();
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
                }, itemCount: Provider.of<DashModel>(context).meters.rows, crossAxisCount: 2,),
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
          onRefresh: () async =>
              await Provider.of<DashModel>(context, listen: false)
                  .refreshMeters(),
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
              SliverList(
                delegate: SliverChildBuilderDelegate((context, int index) {
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
                                    .lastReading['to'],
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
                                              updateSelectedMeter(
                                                  Provider.of<DashModel>(
                                                          context,
                                                          listen: false)
                                                      .meters
                                                      .data[index]);
                                              _metersDialog();
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
                                              updateSelectedMeter(
                                                  Provider.of<DashModel>(
                                                          context,
                                                          listen: false)
                                                      .meters
                                                      .data[index]);
                                              _metersDialog();
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

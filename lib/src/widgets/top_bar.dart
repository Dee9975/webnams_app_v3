import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  TopBar() : preferredSize = Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = new ScrollController();
    final dashState = Provider.of<DashModel>(context);
    Future<void> _addressesDialog() async {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 16.0),
                      child: Text(
                        dashState.getTranslation(code: 'mob_app_accounts_title'),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16.0),
                      height: 190,
                      child: RefreshIndicator(
                        onRefresh: () => Provider.of<DashModel>(context, listen: false).getAddresses(refresh: true),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              Provider.of<DashModel>(context, listen: false)
                                  .addresses
                                  .data
                                  .length,
                          itemBuilder: (context, int index) {
                            return Container(
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: index == 0
                                      ? BorderSide(color: hexToColor('#d6dde3'))
                                      : BorderSide(
                                          width: 0, color: hexToColor('#d6dde3')),
                                  bottom:
                                      BorderSide(color: hexToColor('#d6dde3')),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  Provider.of<DashModel>(context, listen: false)
                                      .addresses
                                      .data[index]
                                      .addressName,
                                  style: TextStyle(
                                      fontSize: 16, color: hexToColor('#222e42')),
                                ),
                                trailing: Text(
                                  '${Provider.of<DashModel>(context, listen: false).addresses.data[index].personId}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: hexToColor('#222e42')),
                                ),
                                onTap: () {
                                  Provider.of<DashModel>(context, listen: false)
                                      .updateSelectedAddress(
                                          Provider.of<DashModel>(context,
                                                  listen: false)
                                              .addresses
                                              .data[index]);
                                  Navigator.of(context).pop();
                                },
                                dense: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
//                    Padding(
//                      padding: const EdgeInsets.only(
//                          left: 16.0, right: 16.0, top: 18.0),
//                      child: ButtonTheme(
//                        height: 40.0,
//                        minWidth: double.infinity,
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(24.0),
//                        ),
//                        buttonColor: hexToColor('#23a0ff'),
//                        child: RaisedButton(
//                          elevation: 0,
//                          child: Text(
//                            dashState.getTranslation(code: 'mob_app_add_button'),
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.w600),
//                          ),
//                          onPressed: () async {},
//                          // onPressed: _isButtonDisabled ? null : _updateEmail,
//                        ),
//                      ),
//                    ),
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
                            dashState.getTranslation(code: 'mob_app_close'),
                            style: TextStyle(
                                color: hexToColor('#3e4a5e'),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          // onPressed: _isButtonDisabled ? null : _updateEmail,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
          });
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            IgnorePointer(
              ignoring: Provider.of<DashModel>(context).isLoading == true
                  ? true
                  : false,
              child: GestureDetector(
                onTap: _addressesDialog,
                child: Container(
                  margin: EdgeInsets.only(left: 8.0),
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
//                  width: MediaQuery.of(context).size.width - 64,
                width: MediaQuery.of(context).size.width - 16,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        child: Icon(
                          Icons.home,
                          color: hexToColor('#BDC4CA'),
                        ),
                        left: 8,
                      ),
                      Positioned(
                        child: Text(
                          Provider.of<DashModel>(context).selectedAddress != null
                              ? Provider.of<DashModel>(context)
                                          .selectedAddress
                                          .addressName
                                          .length >
                                      30
                                  ? '${Provider.of<DashModel>(context).selectedAddress.addressName.substring(0, 29)}...'
                                  : Provider.of<DashModel>(context)
                                      .selectedAddress
                                      .addressName
                              : 'Loading',
                          style: TextStyle(
                              fontSize: 16, color: hexToColor('#222e42')),
                        ),
                        // height: 16,
                        left: 48,
                      ),
                      Positioned(
                        right: 8,
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: hexToColor('#BDC4CA'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
//            Container(
//              margin: EdgeInsets.only(left: 8.0),
//              width: 40,
//              height: 40,
//              child: ButtonTheme(
//                buttonColor: Colors.white,
//                child: RaisedButton(
//                  padding: EdgeInsets.all(0),
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(10)),
//                  child: Container(
//                      width: 24.0,
//                      height: 24.0,
//                      child: Center(
//                        child: Image.asset(
//                          'assets/add.png',
//                          width: 24,
//                          height: 24,
//                        ),
//                      )),
//                  onPressed: () {},
//                ),
//              ),
//            )
          ],
        ),
      ),
    );
  }
}

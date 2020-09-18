import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/announcements/announcements.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/resources/translations.dart';
import 'package:webnams_app_v3/src/widgets/announcements_box.dart';
import 'package:webnams_app_v3/src/widgets/meters_box.dart';
import 'package:webnams_app_v3/src/widgets/payment_warning.dart';
import 'package:supercharged/supercharged.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class SliverHome extends StatefulWidget {
  const SliverHome({Key key}) : super(key: key);

  @override
  SliverHomeState createState() => SliverHomeState();
}

class SliverHomeState extends State<SliverHome> with WidgetsBindingObserver {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       if (context.read<DashModel>().dashboardBox.data.autoRefresh.compareTo(DateTime.now().millisecondsSinceEpoch) > 0) {
  //         await context.read<DashModel>().refreshHome();
  //         LoadNotification(refresh: true)..dispatch(context);
  //       }
  //       break;
  //     case AppLifecycleState.inactive:
  //       print("app in inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       print("app in paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       print("app in detached");
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Future<void> updateSelectedAnnouncement(AnnouncementData data) async {
      await Provider.of<DashModel>(context, listen: false)
          .updateSelectedAnnouncement(data);
      Navigator.pushNamed(context, '/announcement_details');
    }

    Future<void> refreshHome() async {
      await Provider.of<DashModel>(context, listen: false).refreshHome();
      if (Provider.of<DashModel>(context, listen: false).hasError) {
        Map<String, String> modalTranslations = hardcodedTranslation(
            Provider.of<DashModel>(context, listen: false).dash.language ?? 0,
            Provider.of<DashModel>(context, listen: false).errorType ?? "timeout");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(modalTranslations["title"]),
                content: Text(Provider.of<DashModel>(context).error ?? "Error"),
                actions: [
                  FlatButton(
                    onPressed: () async {
                      await refreshHome();
                      Navigator.pop(context);
                    },
                    child: Text(modalTranslations["button"]),
                  ),
                ],
              );
            });
      }
    }

    if (Provider.of<DashModel>(context).isLoading &&
        !Provider.of<DashModel>(context).hasError) {
      return Center(
        child: CircularProgressIndicator(),
      );
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
                  await refreshHome();
                },
              ),
            ],
          ),
        ),
      );
    }

    if (Provider.of<DashModel>(context).dashboardBox == null && !Provider.of<DashModel>(context).isLoading) {
      return Center(
        child: Text("Missing items"),
      );
    }
    return NotificationListener<LoadNotification>(
      onNotification: (notification) {
        print(notification);
        context.read<DashModel>().refreshHome();
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async => await refreshHome(),
        child: CustomScrollView(
          slivers: <Widget>[
            Provider.of<DashModel>(context).dashboardBox.data != null
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
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
                                  padding: const EdgeInsets.only(
                                      top: 24.0, left: 24.0),
                                  child: Row(
                                    children: <Widget>[
                                      Provider.of<DashModel>(context)
                                                  .dashboardBox
                                                  .data
                                                  .balance
                                                  .typeId ==
                                              3
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: PaymentWarning(),
                                            )
                                          : Offstage(),
                                      Text(
                                        Provider.of<DashModel>(context)
                                                    .dashboardBox
                                                    .data
                                                    .balance
                                                    .typeId !=
                                                1
                                            ? Provider.of<DashModel>(context)
                                                .dashboardBox
                                                .data
                                                .balance
                                                .amount
                                            : Provider.of<DashModel>(context)
                                                .dashboardBox
                                                .data
                                                .balance
                                                .type,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 48,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Provider.of<DashModel>(context)
                                            .dashboardBox
                                            .data
                                            .balance
                                            .typeId !=
                                        1
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 24.0),
                                        child: Text(
                                          Provider.of<DashModel>(context)
                                              .dashboardBox
                                              .data
                                              .balance
                                              .type,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Offstage(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24.0, bottom: 24.0, top: 16.0),
                                  child: Text(
                                    Provider.of<DashModel>(context)
                                            .dashboardBox
                                            .data
                                            .balance
                                            .msg ??
                                        '',
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
                                  height: 92,
                                  child: Image.asset('assets/card_houses.png')),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverOffstage(),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, int index) {
                if (Provider.of<DashModel>(context)
                        .dashboardBox
                        .data
                        .announcements !=
                    null) {
                  return GestureDetector(
                    onTap: () async => await updateSelectedAnnouncement(
                        Provider.of<DashModel>(context, listen: false)
                            .dashboardBox
                            .data
                            .announcements[index]),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.album,
                                  color: hexToColor('#8d96a4'),
                                  size: 16,
                                ),
                                Text(
                                  Provider.of<DashModel>(context).getTranslation(
                                      code: 'mob_app_announcement'),
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      color: hexToColor('#8d96a4')),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 8.0, top: 7.0),
                            child: Text(
                              Provider.of<DashModel>(context)
                                  .dashboardBox
                                  .data
                                  .announcements[index]
                                  .title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 8.0, bottom: 16.0),
                            child: Text(
                                Provider.of<DashModel>(context)
                                    .getTranslation(code: 'mob_app_read_more'),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: hexToColor('#23a0ff'))),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Offstage();
                }
              },
                  childCount: Provider.of<DashModel>(context)
                              .dashboardBox
                              .data
                              .announcements !=
                          null
                      ? Provider.of<DashModel>(context)
                          .dashboardBox
                          .data
                          .announcements
                          .length
                      : 0),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, int index) {
                if (Provider.of<DashModel>(context).dashboardBox.data.meters !=
                    null) {
                  return MetersBox(Provider.of<DashModel>(context)
                      .dashboardBox
                      .data
                      .meters[index]);
                }
                return Offstage();
              },
                  childCount:
                      Provider.of<DashModel>(context).dashboardBox.data.meters !=
                              null
                          ? Provider.of<DashModel>(context)
                              .dashboardBox
                              .data
                              .meters
                              .length
                          : 0),
            )
          ],
        ),
      ),
    );
  }
}

class LoadNotification extends Notification {
  final bool refresh;
  const LoadNotification({this.refresh});
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/announcements/announcements.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/widgets/announcements_box.dart';
import 'package:webnams_app_v3/src/widgets/meters_box.dart';
import 'package:webnams_app_v3/src/widgets/payment_warning.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class SliverHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> updateSelectedAnnouncement(AnnouncementData data) async {
      await Provider.of<DashModel>(context, listen: false)
          .updateSelectedAnnouncement(data);
      Navigator.pushNamed(context, '/announcement_details');
    }

    if (Provider.of<DashModel>(context).isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: () =>
          Provider.of<DashModel>(context, listen: false).refreshHome(),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
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
                          padding: const EdgeInsets.only(top: 24.0, left: 24.0),
                          child: Row(
                            children: <Widget>[
                              Provider.of<DashModel>(context)
                                          .dashboardBox
                                          .data
                                          .balance
                                          .typeId ==
                                      3
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
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
                                padding: const EdgeInsets.only(left: 24.0),
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
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, int index) {
              if (Provider.of<DashModel>(context)
                      .dashboardBox
                      .data
                      .announcements !=
                  null) {
                return GestureDetector(
                  onTap: () async => await updateSelectedAnnouncement(Provider.of<DashModel>(context, listen: false)
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
                                Provider.of<DashModel>(context).getTranslation(code: 'mob_app_announcement'),
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: hexToColor('#8d96a4')),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 7.0),
                          child: Text(Provider.of<DashModel>(context)
                              .dashboardBox
                              .data
                              .announcements[index].title, style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 16.0),
                          child: Text(Provider.of<DashModel>(context).getTranslation(code: 'mob_app_read_more'), style: TextStyle(
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
    );
  }
}

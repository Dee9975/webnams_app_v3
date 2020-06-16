import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/widgets/announcements_box.dart';
import 'package:webnams_app_v3/src/widgets/meters_box.dart';
import 'package:webnams_app_v3/src/widgets/payment_warning.dart';

class SliverHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                return AnnouncementsBox(Provider.of<DashModel>(context)
                    .dashboardBox
                    .data
                    .announcements[index]);
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

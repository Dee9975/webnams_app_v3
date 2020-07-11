import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';

class AnnouncementDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DashModel dashModel = Provider.of<DashModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(dashModel.selectedAnnouncement.created,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                  child: Text(
                dashModel.selectedAnnouncement.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: HtmlWidget(
                dashModel.selectedAnnouncement.message,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';

class AnnouncementDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DashModel dashModel = Provider.of<DashModel>(context);
    print(dashModel.selectedAnnouncement.message);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(dashModel.selectedAnnouncement.created,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: HtmlWidget(
          dashModel.selectedAnnouncement.message,
          bodyPadding: EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}

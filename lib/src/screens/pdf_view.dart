import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/dashboard_model.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class PdfView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text('Nr. ${Provider.of<DashModel>(context).selectedBill.iD}', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.file(
                    'Invoice',
                    Provider.of<DashModel>(context, listen: false)
                        .selectedBill
                        .files
                        .invoice
                        .name,
                    Provider.of<DashModel>(context, listen: false)
                        .shareData
                        .buffer
                        .asUint8List(),
                    'application/pdf');
              },
            ),
          ],
        ),
        path: Provider.of<DashModel>(context).pdf.path);
  }
}

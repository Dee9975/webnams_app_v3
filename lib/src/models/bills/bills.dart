import 'package:webnams_app_v3/src/models/bills/data.dart';

class Bills {
  int rows;
  int rowsTotal;
  int page;
  int pages;
  List<BillsData> data;
  String message;

  Bills({this.rows, this.rowsTotal, this.page, this.pages, this.data, this.message});

  Bills.fromJson(Map<String, dynamic> json) {
    rows = json['rows'];
    rowsTotal = json['rows_total'];
    page = json['page'];
    pages = json['pages'];
    json['message'] != null ? message = json['message'] : message = null;
    if (json['data'] != null) {
      data = new List<BillsData>();
      json['data'].forEach((v) {
        data.add(new BillsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rows'] = this.rows;
    data['rows_total'] = this.rowsTotal;
    data['page'] = this.page;
    data['pages'] = this.pages;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
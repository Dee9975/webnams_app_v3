import 'package:webnams_app_v3/src/models/announcements/announcements.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashAnnouncements.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:supercharged/supercharged.dart';

class DashBoardBox {
  int rows;
  int rowsTotal;
  int page;
  int pages;
  DashBoxData data;

  DashBoardBox({this.rows, this.rowsTotal, this.page, this.pages, this.data});

  DashBoardBox.fromJson(Map<String, dynamic> json) {
    rows = json['rows'];
    rowsTotal = json['rows_total'];
    page = json['page'];
    pages = json['pages'];
    data = json['data'] != null ? new DashBoxData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rows'] = this.rows;
    data['rows_total'] = this.rowsTotal;
    data['page'] = this.page;
    data['pages'] = this.pages;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DashBoxData {
  Balance balance;
  List<MeterData> meters;
  List<AnnouncementData> announcements;
  AutoRefresh autoRefresh;
  DashBoxData({this.balance, this.meters, this.announcements, this.autoRefresh});

  DashBoxData.fromJson(Map<String, dynamic> json) {
    balance = json['balance'] != null ? Balance.fromJson(json['balance']) : null;
    autoRefresh = AutoRefresh.fromJson(json["auto-refresh"]);
    if (json['meters'] != null) {
      meters = new List<MeterData>();
      json['meters'].forEach((v) => meters.add(MeterData.fromJson(v)));
    }
    if (json['announcements'] != null) {
      announcements = new List<AnnouncementData>();
      json['announcements'].forEach((v) => announcements.add(AnnouncementData.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = balance;
    return data;
  }
}

class Balance {
  String msg;
  String amount;
  String type;
  int typeId;

  Balance({this.msg, this.amount, this.type, this.typeId});

  Balance.fromJson(Map<String, dynamic> json) {
    msg = json['msg']?? '';
    amount = json['amount']?? '';
    type = json['type']?? '';
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['type_id'] = this.typeId;
    return data;
  }
}

class AutoRefresh {
  int value;
  String unit;

  AutoRefresh({this.value, this.unit});

  AutoRefresh.fromJson(Map<String, dynamic> json) {
    value = json["value"];
    unit = json["units"];
  }
}


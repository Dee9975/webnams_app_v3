class HostModel {
  int rows;
  int rowsTotal;
  int page;
  int pages;
  HostData data;

  HostModel({this.rows, this.rowsTotal, this.page, this.pages, this.data});

  HostModel.fromJson(Map<String, dynamic> json) {
    rows = json['rows'];
    rowsTotal = json['rows_total'];
    page = json['page'];
    pages = json['pages'];
    data = json['data'] != null ? new HostData.fromJson(json['data']) : null;
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

class HostData {
  List<HostList> hosts;

  HostData({this.hosts});

  HostData.fromJson(Map<String, dynamic> json) {
    if (json['hosts'] != null) {
      hosts = new List<HostList>();
      json['hosts'].forEach((v) {
        hosts.add(new HostList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hosts != null) {
      data['hosts'] = this.hosts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HostList {
  String hostId;
  String hostName;

  HostList({this.hostId, this.hostName});

  HostList.fromJson(Map<String, dynamic> json) {
    hostId = json['host_id'];
    hostName = json['host_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['host_id'] = this.hostId;
    data['host_name'] = this.hostName;
    return data;
  }
}
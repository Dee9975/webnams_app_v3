class Announcements {
  int rows;
  int rowsTotal;
  int page;
  int pages;
  String message;
  List<AnnouncementData> data;

  Announcements({this.rows, this.rowsTotal, this.page, this.pages, this.data, this.message});

  Announcements.fromJson(Map<String, dynamic> json) {
    rows = json['rows'];
    rowsTotal = json['rows_total'];
    page = json['page'];
    pages = json['pages'];
    message = json['message']?? '';
    if (json['data'] != null) {
      data = new List<AnnouncementData>();
      json['data'].forEach((v) {
        data.add(new AnnouncementData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rows'] = this.rows;
    data['rows_total'] = this.rowsTotal;
    data['page'] = this.page;
    data['pages'] = this.pages;
    data['message'] = this.message?? '';
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnnouncementData {
  int id;
  String title;
  String message;
  bool unread;
  String created;

  AnnouncementData({this.id, this.title, this.message, this.unread, this.created});

  AnnouncementData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    unread = json['unread']?? false;
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['message'] = this.message;
    data['unread'] = this.unread;
    data['created'] = this.created;
    return data;
  }
}

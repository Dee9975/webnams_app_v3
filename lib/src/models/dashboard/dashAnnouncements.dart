class AnnouncementsDash {
  List<AData> announcements;

  AnnouncementsDash({this.announcements});

  AnnouncementsDash.fromJson(Map<String, dynamic> json) {
    if (json['announcements'] != null) {
      announcements = new List<AData>();
      json['announcements'].forEach((v) {
        announcements.add(new AData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.announcements != null) {
      data['announcements'] =
          this.announcements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AData {
  int id;
  String title;
  String created;

  AData({this.id, this.title, this.created});

  AData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['created'] = this.created;
    return data;
  }
}

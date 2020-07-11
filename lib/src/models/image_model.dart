class ImageModel {
  int id;
  int meterId;
  String path;

  ImageModel({this.path, this.id, this.meterId});

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    meterId = json["meter_id"];
    path = json["path"];
  }
}
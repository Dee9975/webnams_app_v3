class MeterData {
  int id;
  int addressId;
  String type;
  String number;
  String installed;
  int signsBefore;
  int signsAfter;
  var multiplier;
  String nextCheck;
  bool hideWeb;
  var currentReading;
  var currentConsumption;
  bool editable;
  Map<String, dynamic> lastReading;
  Map<String, dynamic> avgReading;
  var limit;

  MeterData(
      {this.id,
      this.addressId,
      this.type,
      this.number,
      this.installed,
      this.signsBefore,
      this.signsAfter,
      this.multiplier,
      this.nextCheck,
      this.hideWeb,
      this.editable,
      this.lastReading,
      this.avgReading,
      this.limit,
      this.currentConsumption,
      this.currentReading});

  MeterData.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    addressId = json['address_ID'];
    type = json['type'];
    number = json['number'];
    installed = json['installed'];
    signsBefore = json['signs_before'];
    signsAfter = json['signs_after'];
    multiplier = json['multiplier'];
    nextCheck = json['next_check'];
    hideWeb = json['hide_web'];
    editable = json['editable'];
    lastReading = json['last_reading'];
    avgReading = json['avg_reading'];
    limit = json['limit'];
    currentConsumption = json['current_consumption'];
    currentReading = json['current_reading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['address_ID'] = this.addressId;
    data['type'] = this.type;
    data['number'] = this.number;
    data['installed'] = this.installed;
    data['signs_before'] = this.signsBefore;
    data['signs_after'] = this.signsAfter;
    data['multiplier'] = this.multiplier;
    data['next_check'] = this.nextCheck;
    data['hide_web'] = this.hideWeb;
    data['last_reading'] = this.lastReading;
    data['avg_reading'] = this.avgReading;
    data['limit'] = this.limit;
    data['current_consumption'] = this.currentConsumption;
    data['current_reading'] = this.currentReading;
    return data;
  }
}

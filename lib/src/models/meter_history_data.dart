/// rows : 1
/// rows_total : 1
/// page : 1
/// pages : 0
/// data : [{"ID":1047,"address_ID":478,"type":"Aukstā ūdens skaitītājs","number":"asdasdasd","signs_before":5,"signs_after":3,"installed":"01.01.2019","next_check":"01.01.2023","readings":[{"value":2250,"string_value":"02250.000","pater":0.75,"date":"01.02.2020","source":"Nodots WEBā"},{"value":1500,"string_value":"01500.000","pater":0.5,"date":"01.12.2019","source":"Ievadīts"},{"value":1000,"string_value":"01000.000","pater":0,"date":"01.11.2019","source":"Ievadīts"}]}]

class MeterHistoryData {
  int _rows;
  int _rowsTotal;
  int _page;
  int _pages;
  List<Data> _data;

  int get rows => _rows;
  int get rowsTotal => _rowsTotal;
  int get page => _page;
  int get pages => _pages;
  List<Data> get data => _data;

  MeterHistoryData({
      int rows, 
      int rowsTotal, 
      int page, 
      int pages, 
      List<Data> data}){
    _rows = rows;
    _rowsTotal = rowsTotal;
    _page = page;
    _pages = pages;
    _data = data;
}

  MeterHistoryData.fromJson(dynamic json) {
    _rows = json["rows"];
    _rowsTotal = json["rowsTotal"];
    _page = json["page"];
    _pages = json["pages"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["rows"] = _rows;
    map["rowsTotal"] = _rowsTotal;
    map["page"] = _page;
    map["pages"] = _pages;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// ID : 1047
/// address_ID : 478
/// type : "Aukstā ūdens skaitītājs"
/// number : "asdasdasd"
/// signs_before : 5
/// signs_after : 3
/// installed : "01.01.2019"
/// next_check : "01.01.2023"
/// readings : [{"value":2250,"string_value":"02250.000","pater":0.75,"date":"01.02.2020","source":"Nodots WEBā"},{"value":1500,"string_value":"01500.000","pater":0.5,"date":"01.12.2019","source":"Ievadīts"},{"value":1000,"string_value":"01000.000","pater":0,"date":"01.11.2019","source":"Ievadīts"}]

class Data {
  int _iD;
  int _addressID;
  String _type;
  String _number;
  int _signsBefore;
  int _signsAfter;
  String _installed;
  String _nextCheck;
  List<Readings> _readings;
  List<dynamic> _nameSuggestions;
  String _color;

  int get iD => _iD;
  int get addressID => _addressID;
  String get type => _type;
  String get number => _number;
  int get signsBefore => _signsBefore;
  int get signsAfter => _signsAfter;
  String get installed => _installed;
  String get nextCheck => _nextCheck;
  List<Readings> get readings => _readings;
  List<dynamic> get nameSuggestions => _nameSuggestions;
  String get color => _color;

  Data({
      int iD, 
      int addressID, 
      String type, 
      String number, 
      int signsBefore, 
      int signsAfter, 
      String installed, 
      String nextCheck, 
      List<Readings> readings,
      List<dynamic> nameSuggestions,
  String color}){
    _iD = iD;
    _addressID = addressID;
    _type = type;
    _number = number;
    _signsBefore = signsBefore;
    _signsAfter = signsAfter;
    _installed = installed;
    _nextCheck = nextCheck;
    _readings = readings;
    _nameSuggestions = nameSuggestions;
    _color = color;
}

  Data.fromJson(dynamic json) {
    _iD = json["ID"];
    _addressID = json["address_ID"];
    _type = json["type"];
    _number = json["number"];
    _signsBefore = json["signs_before"];
    _signsAfter = json["signs_after"];
    _installed = json["installed"];
    _nextCheck = json["next_check"];
    _nameSuggestions = json["name_suggestions"];
    _color = json["color"];
    if (json["readings"] != null) {
      _readings = [];
      json["readings"].forEach((v) {
        _readings.add(Readings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ID"] = _iD;
    map["addressID"] = _addressID;
    map["type"] = _type;
    map["number"] = _number;
    map["signsBefore"] = _signsBefore;
    map["signsAfter"] = _signsAfter;
    map["installed"] = _installed;
    map["nextCheck"] = _nextCheck;
    if (_readings != null) {
      map["readings"] = _readings.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// value : 2250
/// string_value : "02250.000"
/// pater : 0.75
/// date : "01.02.2020"
/// source : "Nodots WEBā"

class Readings {
  dynamic _value;
  String _stringValue;
  dynamic _pater;
  String _date;
  String _source;

  dynamic get value => _value;
  String get stringValue => _stringValue;
  dynamic get pater => _pater;
  String get date => _date;
  String get source => _source;

  Readings({
      dynamic value,
      String stringValue, 
      dynamic pater,
      String date, 
      String source}){
    _value = value;
    _stringValue = stringValue;
    _pater = pater;
    _date = date;
    _source = source;
}

  Readings.fromJson(dynamic json) {
    _value = json["value"];
    _stringValue = json["string_value"];
    _pater = json["pater"];
    _date = json["date"];
    _source = json["source"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["value"] = _value;
    map["string_value"] = _stringValue;
    map["pater"] = _pater;
    map["date"] = _date;
    map["source"] = _source;
    return map;
  }

}
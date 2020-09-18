/// rows : 5
/// rows_total : 5
/// page : 1
/// pages : 0
/// data : [{"ID":1047,"address_ID":478,"type":"Aukstā ūdens skaitītājs","number":"asdasdasd","signs_before":5,"signs_after":3,"installed":"01.01.2019","next_check":"01.01.2023","readings":[{"value":2250,"string_value":"02250.000","pater":0.75,"date":"01.02.2020","source":"Nodots WEBā"},{"value":1500,"string_value":"01500.000","pater":0.5,"date":"01.12.2019","source":"Ievadīts"},{"value":1000,"string_value":"01000.000","pater":0,"date":"01.11.2019","source":"Ievadīts"}]},{"ID":659,"address_ID":478,"type":"Aukstā ūdens skaitītājs","number":"61106888","signs_before":5,"signs_after":1,"installed":"01.05.2008","next_check":"01.05.2012","readings":[{"value":10,"string_value":"00010.0","pater":1.9,"date":"01.02.2020","source":"Nodots WEBā"},{"value":8.1,"string_value":"00008.1","pater":0.6,"date":"01.12.2008","source":"Ievadīts"},{"value":7.5,"string_value":"00007.5","pater":0,"date":"01.11.2008","source":"Ievadīts"},{"value":7.5,"string_value":"00007.5","pater":0.2,"date":"01.10.2008","source":"Ievadīts"},{"value":7.3,"string_value":"00007.3","pater":1.4,"date":"01.09.2008","source":"Ievadīts"},{"value":5.9,"string_value":"00005.9","pater":1.9,"date":"01.08.2008","source":"Ievadīts"}]},{"ID":702,"address_ID":478,"type":"Karstā ūdens skaitītājs","number":"34567943","signs_before":5,"signs_after":1,"installed":"01.05.2008","next_check":"01.05.2012","readings":[{"value":8,"string_value":"00008.0","pater":1.7,"date":"01.02.2020","source":"Nodots WEBā"},{"value":6.3,"string_value":"00006.3","pater":0.7,"date":"01.12.2008","source":"Ievadīts"},{"value":5.6,"string_value":"00005.6","pater":0,"date":"01.11.2008","source":"Ievadīts"},{"value":5.6,"string_value":"00005.6","pater":0.2,"date":"01.10.2008","source":"Ievadīts"},{"value":5.4,"string_value":"00005.4","pater":2.6,"date":"01.09.2008","source":"Ievadīts"},{"value":2.8,"string_value":"00002.8","pater":1.5,"date":"01.08.2008","source":"Ievadīts"}]},{"ID":701,"address_ID":478,"type":"Elektroenerģijas skaitītājs","number":"511208","signs_before":7,"signs_after":0,"installed":"01.05.2008","next_check":"01.05.2013","readings":[{"value":770,"string_value":"0000770","pater":2,"date":"01.02.2020","source":"Nodots WEBā"},{"value":768,"string_value":"0000768","pater":112,"date":"01.12.2008","source":"Ievadīts"},{"value":656,"string_value":"0000656","pater":0,"date":"01.11.2008","source":"Ievadīts"},{"value":656,"string_value":"0000656","pater":23,"date":"01.10.2008","source":"Ievadīts"},{"value":633,"string_value":"0000633","pater":110,"date":"01.09.2008","source":"Ievadīts"},{"value":523,"string_value":"0000523","pater":160,"date":"01.08.2008","source":"Ievadīts"}]},{"ID":641,"address_ID":478,"type":"Siltumenerģijas skaitītājs","number":"30533876","signs_before":5,"signs_after":3,"installed":"01.05.2008","next_check":"01.05.2013","readings":[{"value":6,"string_value":"00006.000","pater":2.94,"date":"01.02.2020","source":"Nodots WEBā"},{"value":3.06,"string_value":"00003.060","pater":0.097,"date":"01.12.2008","source":"Ievadīts"},{"value":2.963,"string_value":"00002.963","pater":0,"date":"01.11.2008","source":"Ievadīts"},{"value":2.963,"string_value":"00002.963","pater":0,"date":"01.10.2008","source":"Ievadīts"},{"value":2.963,"string_value":"00002.963","pater":0,"date":"01.09.2008","source":"Ievadīts"},{"value":2.963,"string_value":"00002.963","pater":0,"date":"01.08.2008","source":"Ievadīts"}]}]

class MeterHistory {
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

  MeterHistory({
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

  MeterHistory.fromJson(dynamic json) {
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

  int get iD => _iD;
  int get addressID => _addressID;
  String get type => _type;
  String get number => _number;
  int get signsBefore => _signsBefore;
  int get signsAfter => _signsAfter;
  String get installed => _installed;
  String get nextCheck => _nextCheck;
  List<Readings> get readings => _readings;

  Data({
      int iD, 
      int addressID, 
      String type, 
      String number, 
      int signsBefore, 
      int signsAfter, 
      String installed, 
      String nextCheck, 
      List<Readings> readings}){
    _iD = iD;
    _addressID = addressID;
    _type = type;
    _number = number;
    _signsBefore = signsBefore;
    _signsAfter = signsAfter;
    _installed = installed;
    _nextCheck = nextCheck;
    _readings = readings;
}

  Data.fromJson(dynamic json) {
    _iD = json["ID"];
    _addressID = json["addressID"];
    _type = json["type"];
    _number = json["number"];
    _signsBefore = json["signsBefore"];
    _signsAfter = json["signsAfter"];
    _installed = json["installed"];
    _nextCheck = json["nextCheck"];
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
  int _value;
  String _stringValue;
  double _pater;
  String _date;
  String _source;

  int get value => _value;
  String get stringValue => _stringValue;
  double get pater => _pater;
  String get date => _date;
  String get source => _source;

  Readings({
      int value, 
      String stringValue, 
      double pater, 
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
    _stringValue = json["stringValue"];
    _pater = json["pater"];
    _date = json["date"];
    _source = json["source"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["value"] = _value;
    map["stringValue"] = _stringValue;
    map["pater"] = _pater;
    map["date"] = _date;
    map["source"] = _source;
    return map;
  }

}
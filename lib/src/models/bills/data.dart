class BillsData {
  int iD;
  String date;
  String billDate;
  String billPeriod;
  String createDate;
  String dueDate;
  String number;
  var amountCalculated;
  var amountToPay;
  var amountUnpayd;
  var amountPayd;
  int type;
  String address;
  Files files;

  BillsData(
      {this.iD,
        this.number,
        this.date,
        this.amountCalculated,
        this.amountToPay,
        this.amountUnpayd,
        this.amountPayd,
        this.type,
        this.files,
        this.billDate,
        this.createDate,
        this.dueDate,
        this.address,
        this.billPeriod
      });

  BillsData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    date = json['date'];
    number = json['number'];
    amountCalculated = json['amount_calculated'];
    amountToPay = json['amount_to_pay'];
    amountUnpayd = json['amount_unpayd'];
    amountPayd = json['amount_payd'];
    type = json['type'];
    files = json['files'] != null ? new Files.fromJson(json['files']) : null;
    billDate = json["bill_date"];
    createDate = json["create_date"];
    dueDate = json["due_date"];
    address = json["address"];
    billPeriod = json["bill_period"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['date'] = this.date;
    data['amount_calculated'] = this.amountCalculated;
    data['amount_to_pay'] = this.amountToPay;
    data['amount_unpayd'] = this.amountUnpayd;
    data['amount_payd'] = this.amountPayd;
    data['type'] = this.type;
    data['number'] = this.type;
    if (this.files != null) {
      data['files'] = this.files.toJson();
    }
    return data;
  }
}

class Files {
  bool success;
  Invoice invoice;
  List<Attachments> attachments;

  Files({this.success, this.invoice, this.attachments});

  Files.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['invoice'] is Map) {
      invoice =
      json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
    } else {
      invoice = null;
    }
    if (json['attachments'] != null) {
      attachments = new List<Attachments>();
      json['attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.invoice != null) {
      data['invoice'] = this.invoice.toJson();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Invoice {
  String url;
  String name;

  Invoice({this.url, this.name});

  Invoice.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['name'] = this.name;
    return data;
  }
}

class Attachments {
  String url;
  String name;

  Attachments({this.url, this.name});

  Attachments.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['name'] = this.name;
    return data;
  }
}
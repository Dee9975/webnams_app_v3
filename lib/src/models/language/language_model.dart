class LanguageModel {
  int rows;
  int rowsTotal;
  int page;
  int pages;
  List<LanguageModelData> data;

  LanguageModel({this.rows, this.rowsTotal, this.page, this.pages, this.data});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    rows = json['rows'];
    rowsTotal = json['rows_total'];
    page = json['page'];
    pages = json['pages'];
    if (json['data'] != null) {
      data = new List<LanguageModelData>();
      json['data'].forEach((v) => data.add(LanguageModelData.fromJson(v)));
    }
  }
}

class LanguageModelData {
  String code;
  LanguageModelNames names;

  LanguageModelData({this.code, this.names});

  LanguageModelData.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    if (json['names'] != null) {
      names = LanguageModelNames.fromJson(json['names']);
    }
  }
}

class LanguageModelNames {
  String lv;
  String en;
  String ru;

  LanguageModelNames({this.lv, this.en, this.ru});

  LanguageModelNames.fromJson(Map<String, dynamic> json) {
    lv = json['LV'];
    en = json['EN'];
    ru = json['RU'];
  }
}

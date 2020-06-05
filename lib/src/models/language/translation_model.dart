class Translations {
  int rows;
  int rowsTotal;
  int page;
  int pages;
  List<Map<String, dynamic>> data;

  Translations({this.data, this.pages, this.page, this.rowsTotal, this.rows});

  Translations.fromJson(Map<String, dynamic> json) {
    rows = json['rows'];
    rowsTotal = json['rows_total'];
    page = json['page'];
    pages = json['pages'];
    if (json['data'] != null) {
      data = new List<Map<String, dynamic>>();
      json['data'].forEach((v) => data.add(v));
    }
  }
}
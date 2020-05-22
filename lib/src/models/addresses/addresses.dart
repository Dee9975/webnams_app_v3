import "data.dart";

class Addresses {
	int rows;
	int rowsTotal;
	int page;
	int pages;
	List<AddressData> data;
  String language;

	Addresses({this.rows, this.rowsTotal, this.page, this.pages, this.data, this.language});

	Addresses.fromJson(Map<String, dynamic> json) {
		rows = json['rows'];
		rowsTotal = json['rows_total'];
		page = json['page'];
		pages = json['pages'];
		if (json['data'] != null) {
			language = json['data']['language'];
      data = new List<AddressData>();
      json['data']['addresses'].forEach((v) { data.add(new AddressData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['rows'] = this.rows;
		data['rows_total'] = this.rowsTotal;
		data['page'] = this.page;
		data['pages'] = this.pages;
		if (this.data!= null) {
      data['data']['addresses'] = this.data.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

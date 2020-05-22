import "data.dart";

class Meters {
	int rows;
	int rowsTotal;
	int page;
	int pages;
	List<MeterData> data;

	Meters({this.rows, this.rowsTotal, this.page, this.pages, this.data});

	Meters.fromJson(Map<String, dynamic> json) {
		rows = json['rows'];
		rowsTotal = json['rows_total'];
		page = json['page'];
		pages = json['pages'];
		if (json['data'] != null) {
			data = new List<MeterData>();
			json['data'].forEach((v) { data.add(new MeterData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['rows'] = this.rows;
		data['rows_total'] = this.rowsTotal;
		data['page'] = this.page;
		data['pages'] = this.pages;
		if (this.data!= null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

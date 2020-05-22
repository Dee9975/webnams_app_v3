class AddressData {
	int id;
	int houseId;
	int personId;
	String addressName;

	AddressData({this.id, this.houseId, this.personId, this.addressName});

	AddressData.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		houseId = json['house_id'];
		personId = json['person_id'];
		addressName = json['address_name'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['house_id'] = this.houseId;
		data['person_id'] = this.personId;
		data['address_name'] = this.addressName;
		return data;
	}
}

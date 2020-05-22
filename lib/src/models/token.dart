class Token {
	String accessToken;
	int expiresIn;
	String tokenType;
	String scope;

	Token({this.accessToken, this.expiresIn, this.tokenType, this.scope});

	Token.fromJson(Map<String, dynamic> json) {
		accessToken = json['access_token'];
		expiresIn = json['expires_in'];
		tokenType = json['token_type'];
		scope = json['scope'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['access_token'] = this.accessToken;
		data['expires_in'] = this.expiresIn;
		data['token_type'] = this.tokenType;
		data['scope'] = this.scope;
		return data;
	}
}

class Refresh {
  String accessToken;
  int expiresIn;
  String tokenType;
  Null scope;
  String refreshToken;

  Refresh(
      {this.accessToken,
        this.expiresIn,
        this.tokenType,
        this.scope,
        this.refreshToken});

  Refresh.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
    scope = json['scope'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    data['token_type'] = this.tokenType;
    data['scope'] = this.scope;
    data['refresh_token'] = this.refreshToken;
    return data;
  }
}
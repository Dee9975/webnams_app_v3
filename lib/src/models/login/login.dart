class Login {
  int rows;
  int rowsTotal;
  int page;
  int pages;
  Data data;

  Login({this.rows, this.rowsTotal, this.page, this.pages, this.data});

  Login.fromJson(Map<String, dynamic> json) {
    rows = json['rows'];
    rowsTotal = json['rows_total'];
    page = json['page'];
    pages = json['pages'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rows'] = this.rows;
    data['rows_total'] = this.rowsTotal;
    data['page'] = this.page;
    data['pages'] = this.pages;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String accessToken;
  int expiresIn;
  String tokenType;
  Null scope;
  String refreshToken;
  int userId;
  String language;

  Data(
      {this.accessToken,
        this.expiresIn,
        this.tokenType,
        this.scope,
        this.refreshToken,
        this.userId,
        this.language});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
    scope = json['scope'];
    refreshToken = json['refresh_token'];
    userId = json['user_id'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    data['token_type'] = this.tokenType;
    data['scope'] = this.scope;
    data['refresh_token'] = this.refreshToken;
    data['user_id'] = this.userId?? 0;
    data['language'] = this.language;
    return data;
  }
}
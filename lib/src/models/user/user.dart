class User {
  String email;
  String password;
  String clientSecret;
  int host;
  String hostName;
  String token;

  User({
    this.email = "",
    this.password = "",
    this.host = 0,
    this.hostName = "",
    this.token = "",
  });
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:webnams_app_v3/src/models/auth/error.dart';
import 'package:webnams_app_v3/src/models/auth/token.dart';
import 'package:webnams_app_v3/src/models/host/host_model.dart';
import 'package:webnams_app_v3/src/models/login/login.dart';
import 'package:webnams_app_v3/src/models/user/user.dart';
import 'package:webnams_app_v3/src/resources/hash.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webnams_app_v3/src/resources/networking.dart';

class UserData extends ChangeNotifier {
  User user = User('', '', '', null, '', '');

  String _url = kReleaseMode
      ? 'https://webapi.webnams.lv'
      : 'https://dev.webapi.webnams.lv';
  String _jsonResponse = '';
  bool _isFetching = false;
  String _error = '';
  bool _hasError = false;
  HostModel _hosts;

  final client = http.Client();
  NetworkProvider networkProvider;

  UserData() {
    networkProvider = NetworkProvider(client: client, baseUrl: _url);
  }

  bool get isFetching => _isFetching;
  String get error => _error;
  bool get hasError => _hasError;
  String get getResponseText => _jsonResponse;
  HostModel get hosts => _hosts;

  Future<void> updateEmail(String email) async {
    user.email = email;
    notifyListeners();
    await getHosts();
    notifyListeners();
  }

  Future<void> updatePassword(String password) async {
    user.password = password;
    notifyListeners();
    await newLogin();
    notifyListeners();
  }

  void updateHost(int id, String hostName) {
    user.host = id;
    user.hostName = hostName;
    notifyListeners();
  }

  void updateError(bool status, String message) {
    _hasError = status;
    notifyListeners();
    _error = message;
    notifyListeners();
  }

  Future<void> getHosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFetching = true;
    notifyListeners();
    var response = await networkProvider.post(uri: '/user', body: {
      'user': user.email,
      "language": prefs.getInt("language") == 0
          ? "lv"
          : prefs.getInt("language") == 1 ? "en" : "ru"
    });
    if (response.statusCode == 200) {
      _hasError = false;
      _error = '';
      notifyListeners();
      _hosts = HostModel.fromJson(json.decode(response.body));
      notifyListeners();
    } else {
      _hasError = true;
      _error = json.decode(response.body)['error'];
      notifyListeners();
    }
    _isFetching = false;
    notifyListeners();
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFetching = true;
    notifyListeners();

    var response = await client.post('$_url/login', body: {
      'client_id': user.email,
      'client_secret': user.clientSecret,
      'password': user.password,
      'host_id': '${user.host}',
      'grant_type': 'client_credentials',
    }, headers: {
      'grant_type': 'client_credentials',
    });
    if (response.statusCode == 200) {
      _error = '';
      _hasError = false;
      notifyListeners();
      var tokenData = await getToken();
      if (tokenData is Token) {
        user.token = tokenData.accessToken;
        _hasError = false;
        _error = '';
        notifyListeners();
      } else if (tokenData is TokenError) {
        _error = tokenData.errorDescription;
        _hasError = true;
        notifyListeners();
        return;
      }
      await prefs.setStringList('user',
          [user.email, user.password, user.clientSecret, '${user.host}']);
      var expires = DateTime.now().add(new Duration(hours: 1)).toString();
      await prefs.setStringList('token', [
        tokenData.accessToken,
        expires,
      ]);
    } else {
      _hasError = true;
      _error = json.decode(response.body)['error'];
      notifyListeners();
    }
    _isFetching = false;
    notifyListeners();
  }

  Future<void> newLogin() async {
    _isFetching = true;
    notifyListeners();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = 'WebNAMS_APP';
      String password = 'zF##u#^\$kaehxzkuG+F&u3*b8aDJGK#-Ra@d2JPC';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      http.Response response = await networkProvider
          .post(uri: '/login', headers: <String, String>{
        'authorization': basicAuth,
      }, body: {
        'host_id': '${user.host}',
        'grant_type': 'password',
        'username': user.email,
        'password': user.password,
      });
      if (response.statusCode == 200) {
        Login login = Login.fromJson(json.decode(response.body));
        prefs.setString('token', login.data.accessToken);
        prefs.setString('refresh_token', login.data.refreshToken);
        prefs.setString(
            'expires', DateTime.now().add(new Duration(hours: 1)).toString());
        prefs.setInt('user_id', login.data.userId);
        prefs.setInt('host_id', user.host);
        prefs.setString('username', user.email);
        prefs.setString('password', user.password);
        prefs.setBool('userExists', true);
        _hasError = false;
        notifyListeners();
        _error = '';
        notifyListeners();
        _isFetching = false;
        notifyListeners();
        return;
      }
      TokenError tokenError = TokenError.fromJson(json.decode(response.body));
      _hasError = true;
      notifyListeners();
      _error = "zzz";
      notifyListeners();
    } on NoInternetException catch (e) {
      print(e);
    }
  }

  Future<dynamic> getToken() async {
    var response = await networkProvider.post(uri: '/oauth_token', body: {
      'client_id': user.email,
      'client_secret': user.clientSecret,
      'grant_type': 'client_credentials',
    });
    if (response.statusCode == 200) {
      Token tokenData = Token.fromJson(json.decode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var expires = DateTime.now().add(new Duration(hours: 1)).toString();
      await prefs.setStringList('token', [
        tokenData.accessToken,
        expires,
      ]);
      return tokenData;
    }
    TokenError errorData = TokenError.fromJson(json.decode(response.body));
    return errorData;
  }

  getResponseJson() {
    if (_jsonResponse.isNotEmpty) {
      var data = json.decode(_jsonResponse);
      return data['data'];
    }
    return null;
  }
}

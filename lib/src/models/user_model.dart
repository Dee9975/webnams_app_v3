import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:webnams_app_v3/src/models/error.dart';
import 'package:webnams_app_v3/src/models/token.dart';
import 'package:webnams_app_v3/src/models/user.dart';
import 'package:webnams_app_v3/src/resources/hash.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends ChangeNotifier {
  User user = User('', '', '', null, '', '');

  String _url = 'https://webapi.webnams.lv';
  String _jsonResponse = '';
  bool _isFetching = false;
  String _error = '';
  bool _hasError = false;

  final client = http.Client();

  bool get isFetching => _isFetching;
  String get error => _error;
  bool get hasError => _hasError;
  String get getResponseText => _jsonResponse;

  Future<void> updateEmail(String email) async {
    user.email = email;
    notifyListeners();
  }

  Future<void> updatePassword(String password) async {
    user.password = password;
    user.clientSecret = generateMd5(password);
    notifyListeners();
    await login();
    notifyListeners();
  }

  void updateHost(int id, String hostName) {
    user.host = id;
    user.hostName = hostName;
    notifyListeners();
  }

  Future<void> getHosts() async {
    _isFetching = true;
    notifyListeners();
    var response = await client.post('$_url/user', body: {'user': user.email});
    if (response.statusCode == 200) {
      _jsonResponse = response.body;
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
      await prefs
          .setStringList('user', [user.email, user.password, user.clientSecret, '${user.host}']);
    } else {
      _hasError = true;
      _error = json.decode(response.body)['error'];
      notifyListeners();
    }
    _isFetching = false;
    notifyListeners();
  }

  Future<dynamic> getToken() async {
    var response = await client.post('$_url/oauth_token', body: {
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

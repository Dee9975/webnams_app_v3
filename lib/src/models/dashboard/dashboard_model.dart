import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webnams_app_v3/src/models/addresses/addresses.dart';
import 'package:webnams_app_v3/src/models/addresses/data.dart';
import 'package:webnams_app_v3/src/models/auth/error.dart';
import 'package:webnams_app_v3/src/models/auth/token.dart';
import 'package:webnams_app_v3/src/models/bills/bills.dart';
import 'package:webnams_app_v3/src/models/bills/data.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard.dart';
import 'package:webnams_app_v3/src/models/language/language_model.dart';
import 'package:webnams_app_v3/src/models/language/translation_model.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:http/http.dart' as http;
import 'package:webnams_app_v3/src/models/meters/meters.dart';
import 'dart:convert';
import 'dart:io';

import 'package:webnams_app_v3/src/models/user/user.dart';

import 'dash_box.dart';

class DashModel extends ChangeNotifier {
  Dash dash = Dash(0, 0, '');
  User user = User('', '', '', null, '', '');
  final String _url = 'https://webapi.webnams.lv';
  final http.Client client = http.Client();
  String _error = '';
  bool _hasError = false;
  bool _isLoading = false;
  Addresses _addresses;
  Meters _meters;
  AddressData _selectedAddress =
      AddressData(id: 0, houseId: 0, personId: 0, addressName: '');
  MeterData _selectedMeter;
  String _warning = '';
  int _maxLength;
  double _spending;
  String _color;
  Bills _bills;
  BillsData _selectedBill;
  File _pdf;
  ByteData _shareData;
  List<dynamic> _homeList;
  DashBoardBox _dashBoardBox;
  LanguageModel _langs;
  Translations _translations;
  String _flashText;
  String _debugError;

  String get error => _error;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  Addresses get addresses => _addresses;
  AddressData get selectedAddress => _selectedAddress;
  Meters get meters => _meters;
  MeterData get selectedMeter => _selectedMeter;
  String get warning => _warning;
  int get maxLength => _maxLength;
  double get spending => _spending;
  String get color => _color;
  Bills get bills => _bills;
  BillsData get selectedBill => _selectedBill;
  File get pdf => _pdf;
  ByteData get shareData => _shareData;
  List<dynamic> get homeList => _homeList;
  DashBoardBox get dashboardBox => _dashBoardBox;
  LanguageModel get langs => _langs;
  String get flashText => _flashText;
  String get debugError =>  _debugError;

  DashModel() {
    getUser();
  }

  void getFlashText(bool status) {
    if (status) {
      _flashText = getTranslation(code: 'mob_app_flashlight_button_off');
      notifyListeners();
    } else {
      _flashText = getTranslation(code: 'mob_app_flashlight_button');
      notifyListeners();
    }

  }

  void updateDebugError(String e) {
    _debugError = e;
    notifyListeners();
  }

  String getTranslation({String code}) {
    String data;
    if (code != null) {
      _translations.data.forEach((element) {
        if (element.containsKey(code)) {
          data = element[code];
        }
      });
      if (data != null) {
        return data;
      }
      return 'This code doesn\'t exist you fool';
    }
    return 'No code added';
  }

  void updateSelectedIndex(int index) {
    dash.selectedIndex = index;
    notifyListeners();
  }

  Future<void> updateSelectedLanguage(int language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dash.language = language;
    notifyListeners();
    await getTranslations();
    notifyListeners();
    getFlashText(false);
    notifyListeners();
    if (_dashBoardBox != null) {
      await getDashBox();
    }
    await prefs.setInt('language', language);
    notifyListeners();
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('user');
  }

  void updateWarning(String warning, [String color]) {
    if (color != null) {
      _color = color;
    } else {
      _color = '';
    }
    _warning = warning;
    notifyListeners();
  }

  void updateSelectedAddress(AddressData address) async {
    _isLoading = true;
    notifyListeners();
    _selectedAddress = address;
    notifyListeners();
    await getMeters();
    await getBills();
    await getDashBox();
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSelectedBill(BillsData bill) async {
    _selectedBill = bill;
    if (_selectedBill.files.invoice != null) {
      await updatePdf();
      notifyListeners();
    }
    notifyListeners();
  }

  void updateSelectedMeter(MeterData meter) {
    _selectedMeter = meter;
    _maxLength = _selectedMeter.signsBefore + _selectedMeter.signsAfter;
    notifyListeners();
  }

  void updateSpending(double spending) {
    _spending = spending;
    notifyListeners();
  }

  Future<void> getAddresses({bool refresh = false}) async {
    notifyListeners();
    bool check = await checkToken();
    if (check) {
      http.Response response = await client.post('$_url/login', body: {
        'client_id': user.email,
        'client_secret': user.clientSecret,
        'password': user.password,
        'host_id': '${user.host}',
        'grant_type': 'client_credentials'
      });
      if (response.statusCode == 200) {
        _addresses = Addresses.fromJson(json.decode(response.body));
        refresh != null && !refresh
            ? _selectedAddress = _addresses.data[0]
            : _selectedAddress = _selectedAddress;
        notifyListeners();
      } else {
        _hasError = true;
        _error = 'Invalid token';
        notifyListeners();
        throw Exception('Failed to get addresses');
      }
    }
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check = await checkToken();
    if (check) {
      dash.token = prefs.getStringList('token')[0];
      user.token = dash.token;
      notifyListeners();
    } else {
      var response = await refreshToken();
      if (response is Token) {
        dash.token = response.accessToken;
        user.token = dash.token;
        notifyListeners();
      } else if (response is TokenError) {
        _error = response.errorDescription;
        _hasError = true;
        notifyListeners();
      }
    }
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getStringList('user');
    var langData = prefs.getInt('language');
    if (langData == null) {
      prefs.setInt('language', 0);
      dash.language = prefs.getInt('language');
    }
    if (userData == null) {
      _isLoading = true;
      notifyListeners();
      user = User('', '', '', null, null, '');
      await getLanguages();
      notifyListeners();
      await getTranslations();
      notifyListeners();
      _isLoading = false;
      notifyListeners();
      getFlashText(false);
      return;
    } else {
      user = User(userData[0], userData[1], userData[2], int.parse(userData[3]),
          '', dash.token);
    }
    dash.language = prefs.getInt('language');
    _isLoading = true;
    notifyListeners();
    if (_langs == null) {
      await getLanguages();
      notifyListeners();
      await getTranslations();
      notifyListeners();
    }
    try {
      await getToken();
      await getAddresses();
      await getMeters();
      await getBills();
      await getDashBox();
      getFlashText(false);
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _hasError = true;
      notifyListeners();
      _error = e.toString();
      notifyListeners();
    }
    _hasError = false;
    notifyListeners();
    _error = '';
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshHome() async {
    _isLoading = true;
    notifyListeners();
    await getMeters();
    await getBills();
    await getDashBox();
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshMeters() async {
    _isLoading = true;
    await getMeters();
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkToken() async {
    DateTime now = DateTime.now().toUtc();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getStringList('token');
    if (tokenData == null) {
      await refreshToken();
    }
    if (DateTime.parse(tokenData[1]).compareTo(now) > 0) {
      return true;
    }
    var response = await refreshToken();
    if (response is Token) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> refreshToken() async {
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
      dash.token = tokenData.accessToken;
      notifyListeners();
      return tokenData;
    } else {
      TokenError errorData = TokenError.fromJson(json.decode(response.body));
      return errorData;
    }
  }

  Future<void> getMeters() async {
    await getToken();
    http.Response response = await client.post(
        '$_url/meters/${_selectedAddress.id}?access_token=${dash.token}&language=${_langs.data[dash.language].code.toLowerCase()}',
        body: {'host_id': '${user.host}'});
    if (response.statusCode == 200) {
      _meters = Meters.fromJson(json.decode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to get meters');
    }
  }

  Future<void> getBills() async {
    await getToken();
    http.Response response = await client.post(
      '$_url/bills/${_selectedAddress.id}?access_token=${dash.token}&language=${_langs.data[dash.language].code.toLowerCase()}',
      body: {'host_id': '${user.host}', 'id': '${_selectedAddress.id}'},
    );
    if (response.statusCode == 200) {
      _bills = Bills.fromJson(json.decode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to get bills');
    }
  }

  Future<void> getDashBox() async {
    await getToken();
    http.Response response = await client.post(
        '$_url/dashboard/${_selectedAddress.id}?access_token=${dash.token}',
        body: {'host_id': '${user.host}',
          'id': '${_selectedAddress.id}',
          'language': _langs.data[dash.language].code.toLowerCase(),
        });
    if (response.statusCode == 200) {
      _dashBoardBox = DashBoardBox.fromJson(json.decode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to get dashboard');
    }
  }

  Future<bool> sendReading(var reading) async {
    http.Response response = await client
        .post('$_url/meters-reading/${_selectedMeter.id}/$reading', body: {
      'host_id': '${user.host}',
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['data']['success'] != null &&
          json.decode(response.body)['data']['success'] == true) {
        return true;
      }
    }
    updateWarning(json.decode(response.body)['message'] ?? 'Error');
    return false;
  }

  Future<void> updatePdf() async {
    await createFileOfPdfUrl();
    try {
      _shareData = await rootBundle.load(_pdf.path);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> createFileOfPdfUrl() async {
    String url;
    String filename;

    url = _selectedBill.files.invoice.url;
    filename = _selectedBill.files.invoice.name;
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    _pdf = file;
    notifyListeners();
  }

  Future<void> getLanguages() async {
    http.Response response = await client.post('$_url/languages');
    if (response.statusCode == 200) {
      _langs = LanguageModel.fromJson(json.decode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to get languages');
    }
  }

  Future<void> getTranslations() async {
    http.Response response = await client.post(
        '$_url/translations/${_langs.data[dash.language].code.toLowerCase()}');
    if (response.statusCode == 200) {
      _translations = Translations.fromJson(json.decode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to get translations');
    }
  }
}

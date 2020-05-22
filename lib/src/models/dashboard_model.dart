import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webnams_app_v3/src/models/addresses/addresses.dart';
import 'package:webnams_app_v3/src/models/addresses/data.dart';
import 'package:webnams_app_v3/src/models/bills/bills.dart';
import 'package:webnams_app_v3/src/models/bills/data.dart';
import 'package:webnams_app_v3/src/models/dashboard.dart';
import 'package:webnams_app_v3/src/models/error.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:webnams_app_v3/src/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:webnams_app_v3/src/models/user.dart';
import 'package:webnams_app_v3/src/models/meters/meters.dart';
import 'dart:convert';
import 'dart:io';

class DashModel extends ChangeNotifier {
  Dash dash = Dash(0, 'lv', '');
  User user = User('', '', '', null, '', '');
  final String _url = 'https://webapi.webnams.lv';
  final http.Client client = http.Client();
  String _error = '';
  bool _hasError = false;
  bool _isLoading = false;
  Addresses _addresses;
  Meters _meters;
  AddressData _selectedAddress;
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

  DashModel() {
    getUser();
  }

  void updateSelectedIndex(int index) {
    dash.selectedIndex = index;
    notifyListeners();
  }

  void updateSelectedLanguage(String language) {
    dash.language = language;
    notifyListeners();
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
    notifyListeners();
    createHomeList();
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSelectedBill(BillsData bill) async {
    _selectedBill = bill;
    if (_selectedBill.files.invoice != null) {
      await updatePdf();
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

  Future<void> getAddresses() async {
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
        _selectedAddress = _addresses.data[0];
        notifyListeners();
      } else {
        _hasError = true;
        _error = 'Invalid token';
        notifyListeners();
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
    if (userData.isEmpty) {
      return;
    }
    user = User(userData[0], userData[1], userData[2], int.parse(userData[3]),
        '', dash.token);
    _isLoading = true;
    notifyListeners();
    await getToken();
    await getAddresses();
    await getMeters();
    await getBills();
    createHomeList();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkToken() async {
    DateTime now = DateTime.now().toUtc();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getStringList('token');
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
    }
    TokenError errorData = TokenError.fromJson(json.decode(response.body));
    return errorData;
  }

  Future<void> getMeters() async {
    await getToken();
    http.Response response = await client.post(
        '$_url/meters/${_selectedAddress.id}/?access_token=${dash.token}',
        body: {'host_id': '${user.host}'});
    if (response.statusCode == 200) {
      _meters = Meters.fromJson(json.decode(response.body));
      notifyListeners();
    }
  }

  Future<void> getBills() async {
    await getToken();
    http.Response response = await client.post(
      '$_url/bills?access_token=${dash.token}',
      body: {'host_id': '${user.host}', 'id': '${_selectedAddress.id}'},
    );
    if (response.statusCode == 200) {
      _bills = Bills.fromJson(json.decode(response.body));
      notifyListeners();
    }
  }

  sortBills() {
    Map<String, dynamic> sorted = {
      'jan': [],
      'feb': [],
      'mar': [],
      'apr': [],
      'maj': [],
      'jun': [],
      'jul': [],
      'aug': [],
      'sep': [],
      'okt': [],
      'nov': [],
      'dec': [],
    };
    _bills.data.map((data) {

    });
  }

  Future<void> updatePdf() async {
    _pdf = await createFileOfPdfUrl();
    notifyListeners();
    _shareData = await rootBundle.load(_pdf.path);
    notifyListeners();
  }

  Future<File> createFileOfPdfUrl() async {
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
    return file;
  }

  void createHomeList() {
    List<dynamic> homeList = [];
    var billsList = _bills;
    var metersList = _meters;
//    metersList.data.sort((a, b) => DateTime.parse(a.nextCheck).compareTo(DateTime.parse(a.nextCheck)));
    billsList.data.sort((a, b) {
      if (a.amountUnpayd < b.amountUnpayd) {
        return 1;
      }
      return 0;
    });
    billsList.data.forEach((f) {
      homeList.add(f);
    });
    metersList.data.forEach((f) {
      homeList.add(f);
    });
//    homeList.add(metersList.data);
    _homeList = homeList;
    notifyListeners();
  }
}

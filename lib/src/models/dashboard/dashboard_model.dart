import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webnams_app_v3/src/models/addresses/addresses.dart';
import 'package:webnams_app_v3/src/models/addresses/data.dart';
import 'package:webnams_app_v3/src/models/announcements/announcements.dart';
import 'package:webnams_app_v3/src/models/auth/error.dart';
import 'package:webnams_app_v3/src/models/auth/refresh.dart';
import 'package:webnams_app_v3/src/models/auth/token.dart';
import 'package:webnams_app_v3/src/models/bills/bills.dart';
import 'package:webnams_app_v3/src/models/bills/data.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard.dart';
import 'package:webnams_app_v3/src/models/image_model.dart';
import 'package:webnams_app_v3/src/models/language/language_model.dart';
import 'package:webnams_app_v3/src/models/language/translation_model.dart';
import 'package:webnams_app_v3/src/models/meters/data.dart';
import 'package:http/http.dart' as http;
import 'package:webnams_app_v3/src/models/meters/meters.dart';
import 'dart:convert';
import 'dart:io';

import 'package:webnams_app_v3/src/models/user/user.dart';
import 'package:webnams_app_v3/src/resources/db_provider.dart';
import 'package:webnams_app_v3/src/resources/networking.dart';
import 'package:webnams_app_v3/src/resources/translations.dart';

import 'dash_box.dart';

class DashModel extends ChangeNotifier {
  Dash dash = Dash(0, 0, '');
  User user = User('', '', '', null, '', '');
  final String _url = kReleaseMode ? 'https://webapi.webnams.lv' : 'https://dev.webapi.webnams.lv';
  final http.Client client = http.Client();
  NetworkProvider networkProvider;
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
  Announcements _announcements;
  AnnouncementData _selectedAnnouncement;
  String _meterSendText;
  ImageModel _selectedImage;
  String _errorType;

  String get errorType => _errorType;
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
  String get debugError => _debugError;
  Announcements get announcements => _announcements;
  AnnouncementData get selectedAnnouncement => _selectedAnnouncement;
  String get meterSendText => _meterSendText;
  ImageModel get selectedImage => _selectedImage;

  DashModel() {
    networkProvider = new NetworkProvider(client: client, baseUrl: _url);
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
      await getAnnouncements();
    }
    await prefs.setInt('language', language);
    notifyListeners();
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('user');
    prefs.remove("token");
    prefs.remove("refresh_token");
    prefs.remove("userExists");
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
    await getAnnouncements();
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

  Future<void> updateSelectedMeter(MeterData meter) async {
    _selectedMeter = meter;
    _maxLength = _selectedMeter.signsBefore + _selectedMeter.signsAfter;
    notifyListeners();
    await getImage();
    notifyListeners();
  }

  void updateSpending(double spending) {
    _spending = spending;
    notifyListeners();
  }

  Future<void> getAddresses({bool refresh = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await getToken();
    http.Response response = await networkProvider.post(uri: "/addresses", body: {
      "access_token": dash.token,
    });
//    http.Response response = await client.post('$_url/addresses', body: {
//      'access_token': dash.token,
//    });

    if (response.statusCode == 200) {
      _addresses = Addresses.fromJson(json.decode(response.body));
      notifyListeners();
      _selectedAddress = _addresses.data[0];
      notifyListeners();
    } else if (response.statusCode == 999) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "No internet";
      notifyListeners();
    } else if (response.statusCode == 408) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "Timed out";
      notifyListeners();
    }
  }

  Future<void> newGetToken() async {
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

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check = await checkToken();
    if (check) {
      dash.token = prefs.getString('token');
      user.token = dash.token;
      notifyListeners();
    } else {
      _error = 'Error getting the token';
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('username');
    if (userData == null) {
      _isLoading = true;
      notifyListeners();
      try {
        user = User('', '', '', null, null, '');
        await getLanguages();
        notifyListeners();
        await getTranslations();
        notifyListeners();
        getFlashText(false);
      } on NoInternetException catch (_) {
        _isLoading = false;
        notifyListeners();
        _errorType = "internet_loss";
        notifyListeners();
        _hasError = true;
        notifyListeners();
        _error = hardcodedTranslation(dash.language, "internet_loss")["subtitle"];
      } on TimeoutException catch (_) {
        _isLoading = false;
        notifyListeners();
        _errorType = "timeout";
        notifyListeners();
        _hasError = true;
        notifyListeners();
        _error = hardcodedTranslation(dash.language, "timeout")["subtitle"];
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      user = User(prefs.getString('username'), prefs.getString('password'), '',
          prefs.getInt('host_id'), '', prefs.getString('token'));
    }
    dash.language = prefs.getInt('language');
    _isLoading = true;
    notifyListeners();
    if (_langs == null) {
      try {
        await getLanguages();
        notifyListeners();
        await getTranslations();
        notifyListeners();
      } on NoInternetException catch (_) {
        _isLoading = false;
        notifyListeners();
        _errorType = "internet_loss";
        notifyListeners();
        _hasError = true;
        notifyListeners();
        _error = hardcodedTranslation(dash.language, "internet_loss")["subtitle"];
      } on TimeoutException catch (_) {
        _isLoading = false;
        notifyListeners();
        _errorType = "internet_loss";
        notifyListeners();
        _hasError = true;
        notifyListeners();
        _error = hardcodedTranslation(dash.language, "timeout")["subtitle"];
      } finally {
        _isLoading = false;
        notifyListeners();
      }

    }
    try {
      await getToken();
      await getAddresses();
      await getMeters();
      await getBills();
      await getDashBox();
      await getAnnouncements();
      getFlashText(false);
      notifyListeners();
      _hasError = false;
      notifyListeners();
      _error = "";
      notifyListeners();
    } on NoInternetException catch(e) {
      _isLoading = false;
      notifyListeners();
      _errorType = "internet_loss";
      notifyListeners();
      _hasError = true;
      notifyListeners();
      _error = hardcodedTranslation(dash.language, "internet_loss")["subtitle"];
      notifyListeners();
    } on TimeoutException catch(e) {
      _isLoading = false;
      notifyListeners();
      _errorType = "internet_loss";
      notifyListeners();
      _hasError = true;
      notifyListeners();
      _error = hardcodedTranslation(dash.language, "timeout")["subtitle"];
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _hasError = true;
      notifyListeners();
      _error = "An error has occured";
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      await getMeters();
      await getBills();
      await getDashBox();
      notifyListeners();
      _isLoading = false;
      notifyListeners();
      _hasError = false;
      _error = "";
      notifyListeners();
    } on NoInternetException catch (e) {
      _isLoading = false;
      notifyListeners();
      _hasError = true;
      notifyListeners();
      _errorType = "internet_loss";
      notifyListeners();
      _error = hardcodedTranslation(dash.language, _errorType)["subtitle"];
      notifyListeners();
      print(e);
    }

  }

  Future<void> refreshMeters() async {
    _isLoading = true;
    try {
      await getMeters();
      notifyListeners();
      _hasError = false;
      _error = "";
      notifyListeners();
    } on NoInternetException catch (_) {
      _hasError = true;
      notifyListeners();
      _error = hardcodedTranslation(dash.language, "internet_loss")["subtitle"];
      _errorType = "internet_loss";
      notifyListeners();
    } on TimeoutException catch (_) {
      _hasError = true;
      notifyListeners();
      _error = hardcodedTranslation(dash.language, "timeout")["subtitle"];
      _errorType = "timeout";
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _error = "here";
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkToken() async {
    DateTime now = DateTime.now().toUtc();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getString('expires');
    if (tokenData == null) {
      await refreshToken();
    }
    if (DateTime.parse(tokenData).compareTo(now) > 0) {
      return true;
    }
    var response = await refreshToken();
    if (response is Refresh) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = 'WebNAMS_APP';
    String password = 'zF##u#^\$kaehxzkuG+F&u3*b8aDJGK#-Ra@d2JPC';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response = await networkProvider.post(uri: "/token", headers: {
      'authorization': basicAuth
    }, body: {
      'refresh_token': prefs.getString('refresh_token'),
      'grant_type': 'refresh_token',
    });
//    var response = await client.post('$_url/token', headers: {
//      'authorization': basicAuth
//    }, body: {
//      'refresh_token': prefs.getString('refresh_token'),
//      'grant_type': 'refresh_token',
//    });
    if (response.statusCode == 200) {
      Refresh refresh = Refresh.fromJson(json.decode(response.body));
      var expires = DateTime.now().add(new Duration(hours: 1)).toString();
      prefs.setString('token', refresh.accessToken);
      prefs.setString('expires', expires);
      prefs.setString('refresh_token', refresh.refreshToken);
      dash.token = refresh.accessToken;
      notifyListeners();
      return refresh;
    } else if (response.statusCode == 999) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "No internet";
      notifyListeners();
    } else if (response.statusCode == 408) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "Timed out";
      notifyListeners();
    } else {
      TokenError errorData = TokenError.fromJson(json.decode(response.body));
      return errorData;
    }
  }

  Future<void> getMeters() async {
    try {
      await getToken();
      http.Response response =
      await networkProvider.post(uri: '/meters/${_selectedAddress.id}', body: {
        'access_token': dash.token,
        'language': _langs.data[dash.language].code.toLowerCase()
      });
      if (response.statusCode == 200) {
        _meters = Meters.fromJson(json.decode(response.body));
        notifyListeners();
      } else if (response.statusCode == 999) {
        _hasError = true;
        notifyListeners();
        _error = json.decode(response.body)["error"]?? "No internet";
        notifyListeners();
      } else if (response.statusCode == 408) {
        _hasError = true;
        notifyListeners();
        _error = json.decode(response.body)["error"]?? "Timed out";
        notifyListeners();
      } else {
        throw Exception('Failed to get meters');
      }
    } on TimeoutException catch (_) {
      _hasError = true;
      notifyListeners();
      _error = hardcodedTranslation(dash.language, "timeout")["subtitle"];
      notifyListeners();
    } on NoInternetException catch (_) {
      _hasError = true;
      notifyListeners();
      _error = hardcodedTranslation(dash.language, "internet_loss")["subtitle"];
      notifyListeners();
    } catch (e) {
      _hasError = true;
      notifyListeners();
      _error = "hee meters";
//      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> getBills() async {
    try {
      await getToken();
      http.Response response = await networkProvider.post(
        uri: '/bills/${_selectedAddress.id}',
        body: {
          'id': '${_selectedAddress.id}',
          'language': _langs.data[dash.language].code.toLowerCase(),
          'access_token': dash.token
        },
      );
      if (response.statusCode == 200) {
        _bills = Bills.fromJson(json.decode(response.body));
        notifyListeners();
      } else if (response.statusCode == 999) {
        _hasError = true;
        notifyListeners();
        _error = json.decode(response.body)["error"]?? "No internet";
        notifyListeners();
      } else if (response.statusCode == 408) {
        _hasError = true;
        notifyListeners();
        _error = json.decode(response.body)["error"]?? "Timed out";
        notifyListeners();
      } else {
        throw Exception('Failed to get bills');
      }
    } on TimeoutException catch (_) {

    } on FormatException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDashBox() async {
    await getToken();
    http.Response response =
        await networkProvider.post(uri: '/dashboard/${_selectedAddress.id}', body: {
      'id': '${_selectedAddress.id}',
      'language': _langs.data[dash.language].code.toLowerCase(),
      'access_token': dash.token
    });
    if (response.statusCode == 200) {
      _dashBoardBox = DashBoardBox.fromJson(json.decode(response.body));
      notifyListeners();
    } else if (response.statusCode == 999) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "No internet";
      notifyListeners();
    } else if (response.statusCode == 408) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "Timed out";
      notifyListeners();
    } else {
      throw Exception('Failed to get dashboard');
    }
  }

  Future<bool> sendReading(var reading) async {
    await getToken();
    http.Response response = await networkProvider.post(
        uri: '/meters-reading/${_selectedMeter.id}/$reading',
        body: { 'access_token': dash.token, "language": _langs.data[dash.language].code.toLowerCase()});
    if (response.statusCode == 200) {
      if (json.decode(response.body)['data']['success'] != null &&
          json.decode(response.body)['data']['success'] == true) {
        _meterSendText = json.decode(response.body)['data']['msg'];
        notifyListeners();
        return true;
      }
    } else if (response.statusCode == 999) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "No internet";
      notifyListeners();
      return false;
    } else if (response.statusCode == 408) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "Timed out";
      notifyListeners();
      return false;
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

    url = _selectedBill.files.invoice.url + "&access_token=${dash.token}";
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
    try {
      http.Response response = await networkProvider.post(uri: '/languages');
      if (response.statusCode == 200) {
        _langs = LanguageModel.fromJson(json.decode(response.body));
        notifyListeners();
      } else {
        throw Exception(response.body);
      }
    } on NoInternetException catch(_) {
      throw NoInternetException();
    }
  }

  Future<void> getTranslations() async {
    http.Response response = await networkProvider.post(
        uri: '/translations/${_langs.data[dash.language].code.toLowerCase()}');
    if (response.statusCode == 200) {
      _translations = Translations.fromJson(json.decode(response.body));
      notifyListeners();
    } else if (response.statusCode == 999) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "No internet";
      notifyListeners();
    } else if (response.statusCode == 408) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "Timed out";
      notifyListeners();
    } else {
      throw Exception('Failed to get translations');
    }
  }

  Future<void> getAnnouncements() async {
    try {
      await getToken();
      http.Response response = await networkProvider.post(uri: '/announcements', body: {
        'adr_id': '${_selectedAddress.id}',
        'access_token': dash.token,
        'language': _langs.data[dash.language].code.toLowerCase(),
      });
      if (response.statusCode == 200) {
        _announcements = Announcements.fromJson(json.decode(response.body));
        notifyListeners();
      } else if (response.statusCode == 999) {
        _hasError = true;
        notifyListeners();
        _error = json.decode(response.body)["error"]?? "No internet";
        notifyListeners();
      } else if (response.statusCode == 408) {
        _hasError = true;
        notifyListeners();
        _error = json.decode(response.body)["error"]?? "Timed out";
        notifyListeners();
      } else {
        throw Exception('Failed retrieving announcements');
      }
    } catch (e) {
      print (e);
    }

  }

  Future<void> readAnnouncement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response =
        await networkProvider.post(uri: '/announcement_read', body: {
      'user_id': '${prefs.getInt('user_id')}',
      'announcement_id': '${_selectedAnnouncement.id}',
      'access_token': dash.token,
      'host_id': '${user.host}',
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['data']['success']) {
        return;
      }
    } else if (response.statusCode == 999) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "No internet";
      notifyListeners();
    } else if (response.statusCode == 408) {
      _hasError = true;
      notifyListeners();
      _error = json.decode(response.body)["error"]?? "Timed out";
      notifyListeners();
    } else {
      throw Exception("Failed reading the announcement");
    }
  }

  Future<void> updateSelectedAnnouncement(
      AnnouncementData announcementData) async {
    _isLoading = true;
    notifyListeners();
    _selectedAnnouncement = announcementData;
    notifyListeners();
    await readAnnouncement();
    await getAnnouncements();
    await getDashBox();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getImage() async {
    final DbProvider dbProvider = DbProvider.instance;
    ImageModel result = await dbProvider.queryImage(_selectedMeter.id);
    if (result != null) {
      _selectedImage = result;
      notifyListeners();
      return;
    }
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> updateSelectedImage({ImageModel image, bool delete = false}) async {
    final DbProvider dbProvider = DbProvider.instance;
    if (delete != null && delete) {
      await dbProvider.delete(_selectedMeter.id);
      _selectedImage = null;
      notifyListeners();
      return;
    }
    _selectedImage = image;
    notifyListeners();
  }
}

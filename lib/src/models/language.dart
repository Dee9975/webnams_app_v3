class Language {
  Languages languages;

  Language({this.languages});

  Language.fromJson(Map<String, dynamic> json) {
    languages = json['languages'] != null
        ? new Languages.fromJson(json['languages'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.languages != null) {
      data['languages'] = this.languages.toJson();
    }
    return data;
  }
}

class Languages {
  Lv lv;

  Languages({this.lv});

  Languages.fromJson(Map<String, dynamic> json) {
    lv = json['lv'] != null ? new Lv.fromJson(json['lv']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lv != null) {
      data['lv'] = this.lv.toJson();
    }
    return data;
  }
}

class Lv {
  Login login;
  Dashboard dashboard;

  Lv({this.login, this.dashboard});

  Lv.fromJson(Map<String, dynamic> json) {
    login = json['login'] != null ? new Login.fromJson(json['login']) : null;
    dashboard = json['dashboard'] != null
        ? new Dashboard.fromJson(json['dashboard'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.login != null) {
      data['login'] = this.login.toJson();
    }
    if (this.dashboard != null) {
      data['dashboard'] = this.dashboard.toJson();
    }
    return data;
  }
}

class Login {
  String emailPlaceholder;
  String emailButton;
  String hostAppbarTitle;
  String hostAppTitle;
  String hostAppSubtitle;
  String passwordAppTitle;
  String passwordPlaceholder;
  String passwordButton;

  Login(
      {this.emailPlaceholder,
        this.emailButton,
        this.hostAppbarTitle,
        this.hostAppTitle,
        this.hostAppSubtitle,
        this.passwordAppTitle,
        this.passwordPlaceholder,
        this.passwordButton});

  Login.fromJson(Map<String, dynamic> json) {
    emailPlaceholder = json['email_placeholder'];
    emailButton = json['email_button'];
    hostAppbarTitle = json['host_appbar_title'];
    hostAppTitle = json['host_app_title'];
    hostAppSubtitle = json['host_app_subtitle'];
    passwordAppTitle = json['password_app_title'];
    passwordPlaceholder = json['password_placeholder'];
    passwordButton = json['password_button'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_placeholder'] = this.emailPlaceholder;
    data['email_button'] = this.emailButton;
    data['host_appbar_title'] = this.hostAppbarTitle;
    data['host_app_title'] = this.hostAppTitle;
    data['host_app_subtitle'] = this.hostAppSubtitle;
    data['password_app_title'] = this.passwordAppTitle;
    data['password_placeholder'] = this.passwordPlaceholder;
    data['password_button'] = this.passwordButton;
    return data;
  }
}

class Dashboard {
  Navigation navigation;
  Address address;
  Meters meters;
  More more;
  Bills bills;
  Home home;

  Dashboard(
      {this.navigation,
        this.address,
        this.meters,
        this.more,
        this.bills,
        this.home});

  Dashboard.fromJson(Map<String, dynamic> json) {
    navigation = json['navigation'] != null
        ? new Navigation.fromJson(json['navigation'])
        : null;
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    meters =
    json['meters'] != null ? new Meters.fromJson(json['meters']) : null;
    more = json['more'] != null ? new More.fromJson(json['more']) : null;
    bills = json['bills'] != null ? new Bills.fromJson(json['bills']) : null;
    home = json['home'] != null ? new Home.fromJson(json['home']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.navigation != null) {
      data['navigation'] = this.navigation.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.meters != null) {
      data['meters'] = this.meters.toJson();
    }
    if (this.more != null) {
      data['more'] = this.more.toJson();
    }
    if (this.bills != null) {
      data['bills'] = this.bills.toJson();
    }
    if (this.home != null) {
      data['home'] = this.home.toJson();
    }
    return data;
  }
}

class Navigation {
  String home;
  String bills;
  String meters;
  String more;

  Navigation({this.home, this.bills, this.meters, this.more});

  Navigation.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    bills = json['bills'];
    meters = json['meters'];
    more = json['more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home'] = this.home;
    data['bills'] = this.bills;
    data['meters'] = this.meters;
    data['more'] = this.more;
    return data;
  }
}

class Address {
  String title;
  String addButton;
  String close;

  Address({this.title, this.addButton, this.close});

  Address.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    addButton = json['add_button'];
    close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['add_button'] = this.addButton;
    data['close'] = this.close;
    return data;
  }
}

class Meters {
  String title;
  String typeInput;
  String typeRead;
  String number;
  String expire;
  String last;
  String input;
  String spending;
  String inputTitle;
  String newInput;
  String emptyDataError;
  String flashlightButton;
  String cancel;

  Meters(
      {this.title,
        this.typeInput,
        this.typeRead,
        this.number,
        this.expire,
        this.last,
        this.input,
        this.spending,
        this.inputTitle,
        this.newInput,
        this.emptyDataError,
        this.flashlightButton,
        this.cancel});

  Meters.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    typeInput = json['type_input'];
    typeRead = json['type_read'];
    number = json['number'];
    expire = json['expire'];
    last = json['last'];
    input = json['input'];
    spending = json['spending'];
    inputTitle = json['input_title'];
    newInput = json['new_input'];
    emptyDataError = json['empty_data_error'];
    flashlightButton = json['flashlight_button'];
    cancel = json['cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['type_input'] = this.typeInput;
    data['type_read'] = this.typeRead;
    data['number'] = this.number;
    data['expire'] = this.expire;
    data['last'] = this.last;
    data['input'] = this.input;
    data['spending'] = this.spending;
    data['input_title'] = this.inputTitle;
    data['new_input'] = this.newInput;
    data['empty_data_error'] = this.emptyDataError;
    data['flashlight_button'] = this.flashlightButton;
    data['cancel'] = this.cancel;
    return data;
  }
}

class More {
  String title;

  More({this.title});

  More.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    return data;
  }
}

class Bills {
  String paid;
  String unpaid;
  String billNr;
  String due;
  String from;

  Bills({this.paid, this.unpaid, this.billNr, this.due, this.from});

  Bills.fromJson(Map<String, dynamic> json) {
    paid = json['paid'];
    unpaid = json['unpaid'];
    billNr = json['bill_nr'];
    due = json['due'];
    from = json['from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paid'] = this.paid;
    data['unpaid'] = this.unpaid;
    data['bill_nr'] = this.billNr;
    data['due'] = this.due;
    data['from'] = this.from;
    return data;
  }
}

class Home {
  String balance;
  String noDebtTitle;
  String debt;
  String debtTitle;
  String announcement;

  Home(
      {this.balance,
        this.noDebtTitle,
        this.debt,
        this.debtTitle,
        this.announcement});

  Home.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    noDebtTitle = json['no_debt_title'];
    debt = json['debt'];
    debtTitle = json['debt_title'];
    announcement = json['announcement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['no_debt_title'] = this.noDebtTitle;
    data['debt'] = this.debt;
    data['debt_title'] = this.debtTitle;
    data['announcement'] = this.announcement;
    return data;
  }
}

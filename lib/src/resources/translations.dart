Map<String, dynamic> translations = {
  "lv": {
    "timeout": {
      "button": "Mēģināt vēlreiz",
      "title": "Pieprasījuma termiņš beidzies",
      "subtitle": "Lai izmantotu lietotni, nepieciešams interneta pieslēgums."
    },
    "internet_loss": {
      "button": "Mēģināt vēlreiz",
      "title": "Lai izmantotu lietotni, nepieciešams interneta pieslēgums.",
      "subtitle": "Vai vēlaties mēģināt vēlreiz?"
    }
  },
  "en": {
    "timeout": {
      "button": "Retry",
      "title": "Error",
      "subtitle": "Would you like to retry?"
    },
    "internet_loss": {
      "button": "Retry",
      "title": "Error",
      "subtitle": "You need an internet connection to access the contents of the application. Would you like to retry?"
    }
  },
  "ru": {
    "title": "чтобы использовать приложение Вам нужно подключиться к интернету.",
    "subtitle": "Попробовать ещё раз?",
    "button": "Повторить",
  }
};

Map<String, String> hardcodedTranslation(int languageCode, String type) {
  switch (languageCode) {
    case 0:
      return translations["lv"][type];
      break;
    case 1:
      return translations["en"][type];
      break;
    case 2:
      return translations["ru"][type];
    default:
      return translations["lv"][type];
  }
}
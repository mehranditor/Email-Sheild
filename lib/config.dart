import 'dart:io' show Platform;

class Config {
  static String get apiUrl {
    if (Platform.isAndroid) {
      return '';
    } else if (Platform.isIOS) {
      return '';
    } else {
      return '';
    }
  }
}

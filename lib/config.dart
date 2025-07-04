import 'dart:io' show Platform;

class Config {
  static String get apiUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api/chat';
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api/chat';
    } else {
      return 'http://192.168.1.100:5000/api/chat';
    }
  }
}

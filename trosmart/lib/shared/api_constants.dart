import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    try {
      if (Platform.isAndroid) {
        return 'https://10.0.2.2:7083/api';
      }
    } catch (e) {
      // Ignore if on web
    }
    return 'https://localhost:7083/api';
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

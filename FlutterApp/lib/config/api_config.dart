class ApiConfig {
  // Change these to match your backend
  static const String baseUrl =
      'http://10.0.2.2:5000'; // Android emulator -> localhost
  static const String notificationUrl = 'http://10.0.2.2:5006';
  static const String socketUrl = 'http://10.0.2.2:5005';

  // For iOS simulator or physical device, use your machine's IP:
  // static const String baseUrl = 'http://192.168.x.x:5000';
  // static const String notificationUrl = 'http://192.168.x.x:5006';
  // static const String socketUrl = 'http://192.168.x.x:5005';
}

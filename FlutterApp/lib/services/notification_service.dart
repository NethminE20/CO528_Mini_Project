import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class NotificationService {
  static Future<List<dynamic>> getNotifications() async {
    final res = await http.get(Uri.parse('${ApiConfig.notificationUrl}/'));
    final data = jsonDecode(res.body);
    if (data is List) return data;
    if (data is Map && data.containsKey('notifications')) {
      return data['notifications'] is List ? data['notifications'] : [];
    }
    return [];
  }

  static Future<Map<String, dynamic>> createNotification(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.notificationUrl}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }
}

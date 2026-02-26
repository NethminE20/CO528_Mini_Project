import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static String? _token;

  static void setToken(String? token) {
    _token = token;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // ─── Auth / Users ───────────────────────────────────
  static Future<Map<String, dynamic>> registerUser(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/users/register'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> loginUser(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/users/login'),
      headers: _headers,
      body: jsonEncode(data),
    );
    if (res.statusCode >= 400) {
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Login failed');
    }
    return jsonDecode(res.body);
  }

  // ─── Posts ──────────────────────────────────────────
  static Future<List<dynamic>> getPosts() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/posts'),
      headers: _headers,
    );
    final data = jsonDecode(res.body);
    return data is List ? data : [];
  }

  static Future<Map<String, dynamic>> createPost(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/posts'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updatePost(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/posts/$id'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<void> deletePost(String id) async {
    await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/posts/$id'),
      headers: _headers,
    );
  }

  // ─── Jobs ──────────────────────────────────────────
  static Future<List<dynamic>> getJobs() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/jobs'),
      headers: _headers,
    );
    final data = jsonDecode(res.body);
    return data is List ? data : [];
  }

  static Future<Map<String, dynamic>> createJob(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/jobs'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateJob(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/jobs/$id'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<void> deleteJob(String id) async {
    await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/jobs/$id'),
      headers: _headers,
    );
  }

  // ─── Events ────────────────────────────────────────
  static Future<List<dynamic>> getEvents() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/events'),
      headers: _headers,
    );
    final data = jsonDecode(res.body);
    return data is List ? data : [];
  }

  static Future<Map<String, dynamic>> createEvent(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/events'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateEvent(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/events/$id'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future<void> deleteEvent(String id) async {
    await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/events/$id'),
      headers: _headers,
    );
  }

  static Future<Map<String, dynamic>> rsvpEvent(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/events/$id/rsvp'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  // ─── Analytics ─────────────────────────────────────
  static Future<Map<String, dynamic>> getAnalytics() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/analytics'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }
}

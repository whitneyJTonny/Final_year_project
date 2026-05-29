import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final _storage = const FlutterSecureStorage();
  
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else {
      try {
        if (io.Platform.isAndroid) {
          return 'http://10.0.2.2:8000/api';
        }
      } catch (e) {
        // Fallback for standard environments
      }
      return 'http://localhost:8000/api';
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<http.Response> get(String path) async {
    return _sendRequest('GET', path);
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    return _sendRequest('POST', path, body: body);
  }

  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    return _sendRequest('PUT', path, body: body);
  }

  Future<http.Response> _sendRequest(String method, String path, {Map<String, dynamic>? body, bool isRetry = false}) async {
    final url = Uri.parse('$baseUrl$path');
    final accessToken = await getAccessToken();

    final headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    http.Response response;
    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      if (method == 'GET') {
        response = await http.get(url, headers: headers);
      } else if (method == 'POST') {
        response = await http.post(url, headers: headers, body: encodedBody);
      } else if (method == 'PUT') {
        response = await http.put(url, headers: headers, body: encodedBody);
      } else {
        throw UnsupportedError('Unsupported method $method');
      }
    } catch (e) {
      debugPrint('Network error on $method $path: $e');
      rethrow;
    }

    if (response.statusCode == 401 && !isRetry) {
      // Access token expired, attempt to refresh
      final refreshed = await _refreshTokens();
      if (refreshed) {
        return _sendRequest(method, path, body: body, isRetry: true);
      }
    }

    return response;
  }

  Future<bool> _refreshTokens() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final url = Uri.parse('$baseUrl/auth/token/refresh/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess = data['access'];
        final newRefresh = data['refresh'] ?? refreshToken; // simplejwt can rotate refresh tokens
        await saveTokens(newAccess, newRefresh);
        return true;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }

    await clearTokens();
    return false;
  }
}

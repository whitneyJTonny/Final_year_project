import 'dart:convert';
import 'package:flutter/material.dart';
import 'api_client.dart';
import '../main.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login/', {
        'username': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final access = data['access'];
        final refresh = data['refresh'];
        await _apiClient.saveTokens(access, refresh);

        // Fetch User Profile details to customize user session
        return await fetchAndSetProfile();
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['detail'] ?? 'Login failed. Invalid credentials.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register(String name, String email, String password, {String phone = ''}) async {
    try {
      final response = await _apiClient.post('/auth/register/', {
        'first_name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final access = data['tokens']['access'];
        final refresh = data['tokens']['refresh'];
        await _apiClient.saveTokens(access, refresh);

        // Assign global session details directly
        final userData = data['user'];
        userNameNotifier.value = userData['first_name'] ?? name;
        userEmailNotifier.value = userData['email'] ?? email;
        isGuestNotifier.value = false;
        return true;
      } else {
        final body = jsonDecode(response.body);
        // Extract field errors if available
        String errorMsg = 'Registration failed.';
        if (body is Map) {
          if (body.containsKey('email')) {
            errorMsg = (body['email'] as List).join(' ');
          } else if (body.containsKey('password')) {
            errorMsg = (body['password'] as List).join(' ');
          } else if (body.containsKey('non_field_errors')) {
            errorMsg = (body['non_field_errors'] as List).join(' ');
          } else if (body.containsKey('error')) {
            errorMsg = body['error'];
          }
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> fetchAndSetProfile() async {
    try {
      final response = await _apiClient.get('/auth/profile/');
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        userNameNotifier.value = userData['first_name'] ?? '';
        userEmailNotifier.value = userData['email'] ?? '';
        isGuestNotifier.value = false;
        return true;
      }
    } catch (e) {
      debugPrint('Fetching profile failed: $e');
    }
    return false;
  }

  Future<void> logout() async {
    await _apiClient.clearTokens();
    userNameNotifier.value = '';
    userEmailNotifier.value = '';
    isGuestNotifier.value = false;
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post('/auth/forgot-password/', {
        'email': email,
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Forgot password request failed.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> resetPassword(String email, String otp, String newPassword) async {
    try {
      final response = await _apiClient.post('/auth/reset-password/', {
        'email': email,
        'otp': otp,
        'password': newPassword,
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Password reset failed.');
      }
    } catch (e) {
      rethrow;
    }
  }
}

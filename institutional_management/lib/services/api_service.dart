import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  final String baseUrl;
  String? _authToken;

  ApiService({required this.baseUrl});

  void setAuthToken(String token) {
    print('Setting auth token: $token');
    _authToken = token;
  }

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<T> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('GET request to: $url');
      print('Headers: $_headers');

      final response = await http.get(url, headers: _headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message:
              'Failed to load data: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('Error in GET request: $e');
      rethrow;
    }
  }

  Future<T> post<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('POST request to: $url');
      print('Headers: $_headers');
      print('Body: ${jsonEncode(data)}');

      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message:
              'Failed to post data: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('Error in POST request: $e');
      rethrow;
    }
  }

  // Similar methods for put, delete
}

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  ApiException({this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: $statusCode - $message';
}

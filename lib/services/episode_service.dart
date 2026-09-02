import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/episode.dart';

class EpisodeNotFoundException implements Exception {}

class EpisodeService {
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.68.101:3000',
  );

  final http.Client _client;

  EpisodeService({http.Client? client}) : _client = client ?? http.Client();

  Future<Episode> findById(int id) async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/episode/$id'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 404) throw EpisodeNotFoundException();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const SocketException('Request failed');
      }

      return Episode.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } on EpisodeNotFoundException {
      rethrow;
    } on FormatException {
      throw const SocketException('Invalid API response');
    } on TypeError {
      throw const SocketException('Invalid API response');
    } on TimeoutException {
      throw const SocketException('Connection timeout');
    } on http.ClientException {
      throw const SocketException('Connection error');
    }
  }
}

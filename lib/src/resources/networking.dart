import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

class NetworkProvider {
  final http.Client client;
  final String baseUrl;

  const NetworkProvider({@required this.client, @required this.baseUrl});

  Future<http.Response> get({String uri, Map<String, String> headers}) async {
    String url = baseUrl + uri;
    try {
      http.Response response = await client
          .get(url, headers: headers ?? {})
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException();
      });
      return response;
    } on SocketException catch (_) {
      throw NoInternetException();
    } on TimeoutException catch (_) {
      throw TimeoutException();
    } catch (e) {
      return http.Response("{error: $e}", 400);
    }
  }

  Future<http.Response> post(
      {String uri,
      Map<String, String> headers,
      Map<String, dynamic> body}) async {
    String url = baseUrl + uri;
    try {
      http.Response response = await client
          .post(url, headers: headers ?? {}, body: body ?? {})
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException();
      });
      return response;
    } on SocketException catch (_) {
      throw NoInternetException();
    } on TimeoutException catch (_) {
      throw TimeoutException();
    } catch (e) {
      return http.Response("{error: $e}", 400);
    }
  }
}

class NoInternetException implements Exception {
  String _message;
  NoInternetException([String message = "No internet connection detected"]) {
    this._message = message;
  }

  @override
  String toString() {
    return _message;
  }
}

class TimeoutException implements Exception {
  String _message;
  TimeoutException([String message = "Timed out"]) {
    this._message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
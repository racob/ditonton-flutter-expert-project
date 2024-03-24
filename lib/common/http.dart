import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SecureClient extends http.BaseClient {
  SecureClient() {
    _initClient();
  }

  Future<Int8List>? _sslCert;
  IOClient? _ioClient;

  Future<void> _initClient() async {
    final securityContext = SecurityContext(withTrustedRoots: false);
    final certBytes = await _getSslCert();
    securityContext.setTrustedCertificatesBytes(certBytes);

    final httpClient = HttpClient(context: securityContext);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      print('Invalid certificate from $host:$port.');
      return false;
    };

    _ioClient = IOClient(httpClient);
  }

  Future<Int8List> _getSslCert() async {
    if (_sslCert == null) {
      _sslCert = rootBundle
          .load('assets/certificates/themoviedb.org.pem')
          .then((data) => data.buffer.asInt8List());
    }
    return _sslCert!;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Ensure the IOClient is initialized before using it
    await _initClient();
    return _ioClient!.send(request);
  }

  @override
  void close() {
    _ioClient?.close();
  }
}

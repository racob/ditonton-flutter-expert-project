import 'dart:io';
import 'package:flutter/services.dart';

class SecureHttp {
  static Future<void> setSslPinning() async {
    SecurityContext(withTrustedRoots: false);
    final sslCert = (await rootBundle.load('assets/certificates/themoviedb.org.pem'))
        .buffer
        .asUint8List();
    SecurityContext context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(sslCert);
  }
}

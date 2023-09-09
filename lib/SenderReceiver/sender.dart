import 'dart:convert';

import 'package:crypto/crypto.dart';

class Sender {
  String sendMessage(String secretKey,String message) {
    // Generate the MAC using the HMAC algorithm
    final mac = Hmac(sha256, utf8.encode(secretKey))
        .convert(utf8.encode(message))
        .toString();
    return mac;
  }
}

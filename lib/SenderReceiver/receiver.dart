import 'dart:convert';
import 'package:crypto/crypto.dart';

class Receiver {
  bool receiveMessage(String secretKey,String message,String mac){

    final computedMac = Hmac(sha256, utf8.encode(secretKey)).convert(utf8.encode(message)).toString();

    return  mac==computedMac;
  }
}
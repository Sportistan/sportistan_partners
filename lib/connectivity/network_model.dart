import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class NetworkModel{
 static Future<ConnectivityResult> initConnectivity() async {
    try {
    ConnectivityResult result =  await (Connectivity().checkConnectivity());
      return result;
    } on PlatformException {
      return ConnectivityResult.none;
    }
  }
}
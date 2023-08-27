import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckInternetState extends StatefulWidget {
  const CheckInternetState({super.key});

  @override
  State<CheckInternetState> createState() => _CheckInternetStateState();
}

class _CheckInternetStateState extends State<CheckInternetState> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity example app'),
        elevation: 4,
      ),
      body: Center(
          child: Text('Connection Status: ${_connectionStatus.toString()}')),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Center(
          child: Text(
            "No internet connection",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 25,
                fontFamily: "Nunito"),
          ),
        ),
        Flexible(
            child: Image.asset(
          "assets/noInternet.png",
          height: MediaQuery.of(context).size.height / 3,
        )),
        CupertinoButton(
            color: Colors.green,
            onPressed: () {},
            child: const Text("Try Again"))
      ],
    )),
  );
}

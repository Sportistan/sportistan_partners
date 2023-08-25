import 'dart:async';
import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportistan_partners/firebase_options.dart';
import 'package:sportistan_partners/home/home_screen.dart';
import 'package:sportistan_partners/login/authentication.dart';
import 'package:sportistan_partners/onboarding/onboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: "6Ld9L8QnAAAAAOaQ3_ZqaER3HSTSclBXBwuX1RgW",
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MaterialApp(home: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {

    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(const Duration(seconds: 250000), () async {
              _auth.authStateChanges().listen((User? user) {
                if (user == null) {
                  userStateSave();
                } else {
                  _moveToDecision(const Home());
                }
              });
            }));

    return Scaffold(
      backgroundColor: const Color(0xffe29587),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 2,
          child: Lottie.asset(
            'assets/splashScreen.json',
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..repeat();
            },
          ),
        ),
      ),
    );
  }

  _moveToDecision(Widget className) async {
    if (mounted) {
      if (Platform.isAndroid) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => className,
            ),
            (route) => false);
      }
      if (Platform.isIOS) {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => className,
            ),
            (route) => false);
      }
    }
  }

  Future<void> userStateSave() async {
    final value = await SharedPreferences.getInstance();
    bool? get = value.getBool("onBoard");
    if (get != null) {
      if (get) {
        _moveToDecision(const Authentication());
      }
    } else {
      _moveToDecision(const OnBoard());
    }
  }
}

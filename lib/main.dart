import 'dart:async';
import 'dart:convert';

import 'package:debut_assets/Dashboard.dart';
import 'package:debut_assets/assetlogin.dart';
import 'package:debut_assets/constants.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseMessaging messaging;

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  messaging = new FirebaseMessaging();
  messaging.configure(
    onMessage: (Map<String, dynamic> message) {
      print(message);
    },
    onLaunch: (Map<String, dynamic> message) {
      print(message);
    },
    onResume: (Map<String, dynamic> message) {
      print(message);
    },
  );

  messaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  messaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {});
  messaging.getToken().then((token) {
    print("get Token");
    print(token);
    deviceToken = token;
  });

  runApp(new MaterialApp(
    home: new Splash(),
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  BuildContext buildContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  Future<Null> startTimer() async {
    const timeout = const Duration(seconds: 3);
    new Timer(timeout, () {
      SharedPreferences.getInstance().then((prefs) {
        var isUserLoggedIn = prefs.getBool(Constants.IS_LOGGED_IN);
        if (isUserLoggedIn != null && isUserLoggedIn) {
          var jsonStringFromLocal = prefs.getString(Constants.USER);
          var jsonDecoded = json.decode(jsonStringFromLocal);
          CurrentUser user = new CurrentUser.fromJSON(jsonDecoded);
          Navigator.of(buildContext).pushAndRemoveUntil(
            new MaterialPageRoute(
                builder: (context) => new Dashboard(user)),
                (Route<dynamic> newRoute) => false,
          );
        } else {
          Navigator.of(buildContext).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new MyAppLogin()),
                (Route<dynamic> newRoute) => false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return new Scaffold(
      body: new Container(
        color: Colors.grey,
        child: new Center(
          child: new Image(
            image: new AssetImage("assets/logo.png"),
            height: 126.0,
            width: 126.0,
          ),
        ),
      ),
    );
  }
}

class MyAppLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Debut Assets',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Login(),
    );
  }
}

class MyAppDashboard extends StatelessWidget {
  CurrentUser user;

  MyAppDashboard(this.user);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Debut Assets',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Dashboard(user),
    );
  }
}

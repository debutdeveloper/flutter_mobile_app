import 'dart:convert';

import 'package:debut_assets/Dashboard.dart';
import 'package:debut_assets/assetlogin.dart';
import 'package:debut_assets/constants.dart';
import 'package:debut_assets/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SharedPreferences.getInstance().then((prefs) {
    var isUserLoggedIn = prefs.getBool(Constants.IS_LOGGED_IN);
    if (isUserLoggedIn != null && isUserLoggedIn) {
      var jsonStringFromLocal = prefs.getString(Constants.USER);
      print(
          " Json From SharedPreferences ::: ${jsonStringFromLocal.toString()}");
      var jsonDecoded = json.decode(jsonStringFromLocal);
      CurrentUser user = new CurrentUser.fromJSON(jsonDecoded);
      runApp(MyAppDashboard(user));
    } else {
      runApp(MyAppLogin());
    }
  });
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



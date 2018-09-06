import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

/// Static properties

/// Custom UI Properties
String authorizationToken;
String deviceToken = "No Token";
double titleFontSize = 18.0;
double subTitleFontSize = 12.0;
double buttonTitleFontSize = 16.0;
double descriptionFontSize = 12.0;
double timePickerFieldFontSize = 16.0;
double sliderFieldFontSize = 16.0;

/// API URLs
String baseURL = "http://assetchainapi.debutinfotech.com:3001";
//String baseURL = "http://192.168.0.49:3001";
String loginAPI = "$baseURL/user/login";
String forgetPasswordAPI = "$baseURL/user/forget-password";
String resetPasswordAPI = "$baseURL/user/change-password";
String assetsAPI = "$baseURL/asset";
String assetDetailsAPI = "$baseURL/request/requests/";
String requestAPI = "$baseURL/request/";
String myAssetsAPI = "$baseURL/request/approved-requests";
String nextRequestAPI = "$baseURL/request/next-request/";
String handoverAPI = "$baseURL/request/handover";
String notificationAPI = "$baseURL/notifications";
String handoverActionAPI = "$baseURL/request/handover-action";

getColors() {
  return [
    new Color.fromRGBO(23, 88, 232, 1.0),
    new Color.fromRGBO(175, 215, 234, 1.0)
  ];
}

getDecorationBox() {
  return new DecoratedBox(
      decoration: new BoxDecoration(gradient: getGradient()));
}

getGradient() {
  return new LinearGradient(colors: getColors());
}

Widget getNoDataView(String message) {
  return new Container(
    color: Colors.black12,
    child: new Center(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(
          Icons.sentiment_dissatisfied,
          size: 64.0,
        ),
        new Text(
          message,
          style: new TextStyle(fontSize: 32.0),
        ),
      ],
    )),
  );
}

showOkAlert(BuildContext context, String message, bool isFail) {
  print("showOkAlert Shown");
  BuildContext local;
  var cupertinoAlert = new CupertinoAlertDialog(
    content: new Text(message),
    title: new Icon(
      isFail ? Icons.error : Icons.check_circle,
      color: isFail ? Colors.red : Colors.green,
    ),
    actions: <Widget>[
      new CupertinoDialogAction(
        child: new Text('OK'),
        onPressed: () {
          Navigator.of(local).pop();
        },
        isDefaultAction: true,
      ),
    ],
  );

  var materialAlert = new AlertDialog(
    title: new Icon(
      isFail ? Icons.error : Icons.check_circle,
      color: isFail ? Colors.red : Colors.green,
    ),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(local).pop();
        },
        child: new Text('OK'),
      )
    ],
  );

  defaultTargetPlatform == TargetPlatform.iOS
      ? showDialog(
          context: context,
          builder: (BuildContext context) {
            local = context;
            return cupertinoAlert;
          },
          barrierDismissible: false)
      : showDialog(
          context: context,
          builder: (BuildContext context) {
            local = context;
            return materialAlert;
          },
          barrierDismissible: false);
}

Duration timeoutDuration = new Duration(seconds: 30);
double reducedHeight = 25.0;
double buttonHeight = 48.0;

/// Validate email
bool isEmailValid(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(email);
}

String getDate(String date) {
  String dateString = '';
  var tempDate = new DateFormat.yMMMd().format(DateTime.parse(date));
  dateString = tempDate.toString();
  return dateString;
}

String getDateForNotifications(String date) {
  String dateString = '';
  var local = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(date).toLocal();
  var tempDate = new DateFormat.jm().format(local);
  dateString = tempDate.toString();
  return dateString;
}

String getTime(String time) {
  print("getTimeBefore $time");
  String timeString;
  var local = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(time).toLocal();
  print("getTimeLocal $local");
  var tempTime = new DateFormat.jm().format(local);
  timeString = tempTime.toString();
  print("getTimeAfter $timeString");
  return timeString;
}

/// TextField visible with keyboard on
///


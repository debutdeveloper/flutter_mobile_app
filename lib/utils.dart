import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Static properties

/// Custom UI Properties
double titleFontSize = 18.0; 
double subTitleFontSize = 12.0; 
double buttonTitleFontSize = 16.0; 
double descriptionFontSize = 12.0; 
double timePickerFieldFontSize = 16.0; 
double sliderFieldFontSize = 16.0;

/// API URLs
String baseURL = "http://192.168.0.18:3001";
String loginAPI = "$baseURL/user/login";
String forgetPasswordAPI = "$baseURL/user/forget-password";
String resetPasswordAPI = "$baseURL/user/change-password";
String assetsAPI = "$baseURL/asset";
String assetDetailsAPI = "$baseURL/request/requests/";
String requestAPI = "$baseURL/request/";
String myAssetsAPI = "$baseURL/request/approved-requests";



getColors() {
  return [
    new Color.fromRGBO(23, 88, 232, 1.0),
    new Color.fromRGBO(175, 215, 234, 1.0)
  ];
}

getDecorationBox() {
  return new DecoratedBox(
      decoration:
      new BoxDecoration(gradient: getGradient()));
}


getGradient() {
  return new LinearGradient(colors: getColors());
}

// Custom Alert

showAlert(BuildContext context,{Widget title,Widget content, List<Widget> cupertinoActions, List<Widget> materialActions}){

  var cupertinoAlert = new CupertinoAlertDialog(
    content: content,
    title: title,
    actions: cupertinoActions
  );

  var materialAlert = new AlertDialog(
    title: title,
    content: content,
    actions: materialActions
  );

  defaultTargetPlatform == TargetPlatform.iOS
      ? showDialog(context: context,
      builder: (BuildContext context) => cupertinoAlert)
      : showDialog(context: context,
      builder: (BuildContext context) => materialAlert);

}

Duration timeoutDuration = new Duration(seconds: 60);
double reducedHeight = 25.0;
double buttonHeight = 48.0;

/// Validate email
bool isEmailValid(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(email);
}

String getDate(String date){
  String dateString = '';
  var tempDate = new DateFormat.yMMMd().format(DateTime.parse(date));
  dateString = tempDate.toString();
  return dateString;
}

String getTime(String time){
  String timeString;
  var tempTime = new DateFormat.jm().format(DateTime.parse(time));
  timeString = tempTime.toString();
  return timeString;
}

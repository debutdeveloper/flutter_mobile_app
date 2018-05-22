import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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



Widget showAlert(BuildContext context,{Widget title,Widget content}){

  var cupertinoAlert = new CupertinoAlertDialog(
    content: content,
    title: title,
    actions: <Widget>[
      new CupertinoDialogAction(
        child: new Text('OK'),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );

  var materialAlert = new AlertDialog(
    title: title,
    content: content,
    actions: <Widget>[
      new FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text("OK"))
    ],
  );



  defaultTargetPlatform == TargetPlatform.iOS
      ? showDialog(context: context,
      builder: (BuildContext context) => cupertinoAlert)
      : showDialog(context: context,
      builder: (BuildContext context) => materialAlert);

}


double reducedHeight = 25.0;
double buttonHeight = 48.0;

/// Validate email
bool isEmailValid(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(email);
}

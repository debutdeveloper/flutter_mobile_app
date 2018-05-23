import 'dart:convert';

import 'package:debut_assets/assetlogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'utils.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final _forgotPasswordFormKey = new GlobalKey<FormState>();

  static final TextEditingController _emailController =
      new TextEditingController();

  String get _email => _emailController.text;

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return "Please enter your email";
    } else if (!isEmailValid(value)) {
      return "Please enter valid e-mail Id";
    } else {
      return null;
    }
  }

  _submit(BuildContext context) async {
    if (_forgotPasswordFormKey.currentState.validate()) {
      final String resetPasswordUrl =
          "http://192.168.0.18:3001/user/forget-password";
      final credentials = {
        "email": _email.toLowerCase()
      };

      try {
        var response = await http.put(resetPasswordUrl,
            body: credentials, headers: {}).timeout(timeoutDuration);
        print("Reset password response : ${json.decode(response.body)}");

        print("ENTERED EMAIL : $_email");

        if (response.statusCode == 200) {
          print("Your new password has been sent to your email address.");
          var responseJson = json.decode(response.body);
          showAlert(
            context,
            title: new Title(color: Colors.blue, child: new Text("Success")),
            content: new Text(responseJson["message"]),
            cupertinoActions: <Widget>[
              new CupertinoDialogAction(
                child: new Text("Login"),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(
                            builder: (context) => new Login()),
                        (Route<dynamic> newRoute) => false,
                      );
                },
              ),
            ],
            materialActions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (context) => new Login()),
                          (Route<dynamic> newRoute) => false,
                        );
                  },
                  child: new Text("Login"))
            ],
          );
        } else {
          print("Error occured");
          var errorJson = json.decode(response.body);
          showAlert(
            context,
            title: new Title(color: Colors.blue, child: new Icon(Icons.error, color:  Colors.red,)),
            content: new Text(errorJson["message"]),
            cupertinoActions: <Widget>[
              new CupertinoDialogAction(
                child: new Text("Ok"),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            materialActions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (context) => new Login()),
                          (Route<dynamic> newRoute) => false,
                        );
                  },
                  child: new Text("Login"))
            ],
          );
        }
      } catch (e) {
        print("Exception occured");
        showAlert(
          context,
          title: new Title(color: Colors.blue, child: new Text("Success")),
          content: new Text('Connection time-out'),
          cupertinoActions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("Login"),
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(builder: (context) => new Login()),
                      (Route<dynamic> newRoute) => false,
                    );
              },
            ),
          ],
          materialActions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(
                            builder: (context) => new Login()),
                        (Route<dynamic> newRoute) => false,
                      );
                },
                child: new Text("Login"))
          ],
        );
      }
    }
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      key: _scaffoldKey,
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
              child: new Center(
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 48.0,
                  backgroundImage: new AssetImage("assets/logo.jpg"),
                ),
              ),
              width: _screenSize.width,
              height: _screenSize.height / 2.8,
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(colors: getColors())),
            ),
            new Container(
              child: new Padding(
                padding: new EdgeInsets.all(24.0),
                child: new Column(
                  children: <Widget>[
                    new SizedBox(height: 16.0),
                    new Text(
                      "Forgot Password?",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize),
                    ),
                    new SizedBox(height: 16.0),
                    new Text(
                      "We just need your registered Email Id to send you password reset instructions",
                      textAlign: TextAlign.center,
                    ),
                    new SizedBox(height: 24.0),
                    new Form(
                      key: _forgotPasswordFormKey,
                      child: new TextFormField(
                        decoration: new InputDecoration(
                            border: new UnderlineInputBorder(),
                            suffixIcon: new Icon(Icons.email),
                            hintText: "Registered Email ID"),
                        controller: _emailController,
                        validator: _validateEmail,
                      ),
                    ),
                    new SizedBox(height: 32.0),
                    new Container(
                      decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(32.0)),
                        gradient: new LinearGradient(
                          colors: getColors(),
                        ),
                      ),
                      child: new ButtonTheme(
                        minWidth: _screenSize.width,
                        height: buttonHeight,
                        child: new FlatButton(
                          onPressed: () {
                            print("Reset password button is pressed");
                            _submit(context);
                          },
                          child: new Text(
                            "RESET PASSWORD",
                            style: new TextStyle(color: Colors.white,
                              fontSize: buttonTitleFontSize
                            ),
                          ),
                          color: Colors.transparent,
                          shape: new StadiumBorder(),
                        ),
                      ),
                    ),
                    new SizedBox(height: 64.0),
                    new GestureDetector(
                        onTap: () {
                          print("Back to login page pressed");
                          Navigator.of(context).pop();
                        },
                        child: new Text(
                          "Back to Login Page",
                          style: new TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: buttonTitleFontSize
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Validate email field

}

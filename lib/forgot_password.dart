import 'package:debut_assets/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  static final TextEditingController _emailController =
  new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  String get _email => _emailController.text;

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery
        .of(context)
        .size;
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
                          fontSize: 20.0),
                    ),
                    new SizedBox(height: 16.0),
                    new Text(
                      "We just need your registered Email Id to send you password reset instructions",
                      textAlign: TextAlign.center,

                    ),
                    new SizedBox(height: 24.0),
                    new TextFormField(
                      decoration: new InputDecoration(
                          border: new UnderlineInputBorder(),
                          suffixIcon: new Icon(Icons.email),
                          hintText: "Registered Email ID"),
                      controller: _emailController,
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
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (
                                    context) => new ResetPasswordScreen()));
                          },
                          child: new Text(
                            "RESET PASSWORD",
                            style: new TextStyle(color: Colors.white),
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

import 'dart:convert';

import 'package:debut_assets/assetlogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  FocusNode _emailIDField = new FocusNode();

  BuildContext _context;
  static final TextEditingController _emailController =
      new TextEditingController();

  String get _email => _emailController.text;
  bool _showLoader = true;

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
      final String forgetPasswordUrl = forgetPasswordAPI;
      final credentials = {"email": _email.toLowerCase()};

      setState(() {
        _showLoader = false;
      });

      try {
        var response = await http
            .put(forgetPasswordUrl, body: credentials)
            .timeout(timeoutDuration);
        print("Reset password response : ${json.decode(response.body)}");

        print("ENTERED EMAIL : $_email");

        if (response.statusCode == 200) {
          print("Your new password has been sent to your email address.");
          var responseJson = json.decode(response.body);
          defaultTargetPlatform == TargetPlatform.iOS
              ? showDialog(
                  context: context,
                  builder: (context) {
                    return new CupertinoAlertDialog(
                      title: new Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      content: new Text(responseJson["message"]),
                      actions: <Widget>[
                        new CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            _emailController.clear();
                            Navigator.of(context).pushAndRemoveUntil(
                                  new MaterialPageRoute(
                                      builder: (context) => new Login()),
                                  (Route<dynamic> newRoute) => false,
                                );
                          },
                          child: new Text(
                            "Login",
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  })
              : showDialog(
                  context: context,
                  builder: (context) {
                    return new AlertDialog(
                      title: new Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      content: new Text(responseJson["message"]),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            _emailController.clear();
                            Navigator.of(context).pushAndRemoveUntil(
                                  new MaterialPageRoute(
                                      builder: (context) => new Login()),
                                  (Route<dynamic> newRoute) => false,
                                );
                          },
                          child: new Text("Login"),
                        )
                      ],
                    );
                  });

        } else {
          print("Error occured");
          var errorJson = json.decode(response.body);
          showOkAlert(_context, errorJson["message"], true);
        }
      } catch (e) {
        print("Exception occured");
        showOkAlert(_context, 'Connection time-out', true);
      }

      setState(() {
        _showLoader = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final Size _screenSize = MediaQuery.of(context).size;
    return new Stack(
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            _emailIDField.unfocus();
          },
          child: new Scaffold(
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
                        backgroundImage: new AssetImage("assets/logo.png"),
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
                              focusNode: _emailIDField,
                            ),
                          ),
                          new SizedBox(height: 32.0),
                          new Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(32.0)),
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
                                  _emailIDField.unfocus();
                                  _submit(context);
                                },
                                child: new Text(
                                  "RESET PASSWORD",
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: buttonTitleFontSize),
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
                                Navigator.pop(context);
                              },
                              child: new Text(
                                "Back to Login Page",
                                style: new TextStyle(
                                    fontSize: buttonTitleFontSize),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        new Offstage(
          child: new Container(
              color: new Color.fromRGBO(1, 1, 1, 0.3),
              child: new Center(
                child: new CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                ),
              )),
          offstage: _showLoader,
        )
      ],
    );
  }

  /// Validate email field

}

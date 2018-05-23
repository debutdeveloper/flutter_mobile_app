import 'dart:convert';

import 'package:debut_assets/assetlogin.dart';
import 'package:debut_assets/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  final CurrentUser user;
  ResetPasswordScreen({@required this.user});
  @override
  ResetPasswordScreenState createState() => new ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {

  /// Custom properties
  TextEditingController _oldPasswordController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();

  String get _oldPassword => _oldPasswordController.text;
  String get _newPassword => _newPasswordController.text;
  String get _confirmPassword => _confirmPasswordController.text;

  FocusNode _newPasswordField = new FocusNode();
  FocusNode _confirmNewPasswordField = new FocusNode();

  final _resetPasswordFormKey = new GlobalKey<FormState>();

  Size _screenSize;

  /// Custom Methods
  ///
  /// Submit method to submit the reset password info
  void _submit(BuildContext context) async {
    final form = _resetPasswordFormKey.currentState;

    if (form.validate()) {
      final String resetPasswordUrl = "http://192.168.0.18:3001/user/change-password";
      final credentials = {
        "id": widget.user.id,
        "old_password": _oldPassword,
        "new_password": _newPassword,
        "confirm_password": _confirmPassword
      };

      try {
        var response = await http.put(
            resetPasswordUrl, body: credentials, headers: {}).timeout(
            new Duration(seconds: 60));
        print("Reset password response : ${json.decode(response.body)}");

        if (response.statusCode == 200) {
          print("Password changed successfully");
          var responseJson = json.decode(response.body);
          showAlert(context,
            title: new Title(color: Colors.blue, child: new Text("Success")),
            content: new Text(responseJson["message"]),
            cupertinoActions: <Widget>[
              new CupertinoDialogAction(
                child: new Text("Login"),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (context) => new Login()
                    ),
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
                          builder: (context) => new Login()
                      ),
                          (Route<dynamic> newRoute) => false,
                    );
                  },
                  child: new Text("Login"))
            ],
          );
        } else {
          print("Error occured");
          var errorJson = json.decode(response.body);
          showAlert(context,
            title: new Icon(Icons.warning, color: Colors.red,),
            content: new Text(errorJson["message"]),
            cupertinoActions: <Widget>[
              new CupertinoDialogAction(
                child: new Text("OK"),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            materialActions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("OK"))
            ],
          );
        }
      }
      catch (e) {
        print("Exception occured");
        showAlert(context, title: new Icon(Icons.warning, color: Colors.red,),
            content: new Text('Connection time-out'));
      }
    }
  }

  /// Validator method of old password textFormField
  ///
  /// To validate the oldPassword entered by user
  String _validateOldPassword(String value) {
    if (value.isEmpty) {
      return "Please enter old password";
    } else if (value.length < 5) {
      return "Password length must be greater than 5";
    } else {
      FocusScope.of(context).requestFocus(_newPasswordField);
      return null;
    }
  }

  /// Validator method of new password textFormField
  ///
  /// To validate the newPassword entered by user
  String _validateNewPassword(String value) {
    if (value.isEmpty) {
      return "Please enter new password";
    } else if (value.length < 5) {
      return "Password length must be greater than 5";
    } else {
      FocusScope.of(context).requestFocus(_confirmNewPasswordField);
      return null;
    }
  }


  /// Validator method of confirm password textFormField
  ///
  /// To validate the confirmPassword entered by user
  String _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return "Please confirm new password";
    } else if (value != _newPassword) {
      return "Confirm password must be same as new password";
    } else {
      //FocusScope.of(context).;
      return null;
    }
  }

  /// Build method
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery
        .of(context)
        .size;
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(
                height: _screenSize.height / 2.8,
                decoration: new BoxDecoration(
                    color: Colors.blue,
                    gradient: new LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: getColors(),
                      tileMode: TileMode.repeated,
                    )),
                alignment: FractionalOffset.center,
                child: new Container(
                  child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 48.0,
                    backgroundImage: new AssetImage("assets/logo.jpg"),
                  ),
                )),
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Container(
                //height: _screenSize.height / 2.8,
                child: new Form(
                  key: _resetPasswordFormKey,
                  child: new Column(
                    children: <Widget>[
                      const Text(
                        'Reset Password',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      new SizedBox(height: 16.0),
                      new Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16.0, 0.0, 16.0, 0.0),
                        child: new TextFormField(
                            controller: _oldPasswordController,
                            validator: _validateOldPassword,
                            decoration: new InputDecoration(
                              hintText: "Old Password",
                              labelText: "Old Password",
                              border: new UnderlineInputBorder(),
                              suffixIcon: new Icon(Icons.lock),
                            )),
                      ),
                      new SizedBox(height: 16.0),
                      new Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16.0, 0.0, 16.0, 0.0),
                        child: new TextFormField(
                          controller: _newPasswordController,
                            validator: _validateNewPassword,
                            focusNode: _newPasswordField,
                            decoration: new InputDecoration(
                              hintText: "New Password",
                              labelText: "New Password",
                              border: new UnderlineInputBorder(),
                              suffixIcon: new Icon(Icons.lock),
                            )),
                      ),
                      new SizedBox(height: 16.0),
                      new Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16.0, 0.0, 16.0, 0.0),
                        child: new TextFormField(
                          controller: _confirmPasswordController,
                          validator: _validateConfirmPassword,
                          focusNode: _confirmNewPasswordField,
                          decoration: new InputDecoration(
                            hintText: "Confirm Password",
                            labelText: "Confirm Password",
                            border: new UnderlineInputBorder(),
                            suffixIcon: new Icon(Icons.lock),
                          ),
                        ),
                      ),
                      new SizedBox(height: 32.0),
                      new Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16.0, 0.0, 16.0, 0.0),
                        child: new Container(
                            height: buttonHeight,
                            decoration: new BoxDecoration(
                                color: Colors.blue,
                                gradient: new LinearGradient(
                                  colors: getColors(),
                                ),
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: new ButtonTheme(
                              minWidth: _screenSize.width,
                              child: new FlatButton(
                                onPressed: () {
                                  _submit(context);
                                },
                                color: Colors.transparent,
                                child: new Text(
                                  'CHANGE PASSWORD',
                                  style: new TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                        ),
                      ),
                      new SizedBox(height: 24.0),
                      new FlatButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: new Text("Back",
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

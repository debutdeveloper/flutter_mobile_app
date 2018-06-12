import 'dart:convert';

import 'package:debut_assets/Dashboard.dart';
import 'package:debut_assets/constants.dart';
import 'package:debut_assets/forgot_password.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';
class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginState();
  }
}

class _LoginState extends State<Login> {
  static final TextEditingController _user = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();

  String username = _user.text;
  String password = _pass.text;


  bool rememberMe = false;
  bool errorsOnForm = false;
  bool _obscureText = true;

  bool _showLoader = true;

  FocusNode _email = new FocusNode();
  FocusNode _password = new FocusNode();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext _context;

  bool isPasswordValid(String password) {
    return true;
  }



  void _validate() async {
    if (_formKey.currentState.validate()) {
      final String loginURL = loginAPI;
      final credentials = {
        "email": username.toLowerCase().trim(),
        "password": password,
        "device_token": deviceToken
      };

      setState(() {
        _showLoader = false;
      });

      try {
        var response = await http.post(loginURL,
            body: credentials, headers: {}).timeout(timeoutDuration);
        if (response.statusCode == 200) {
          print("SUCCESSFULLY LOGIN");

          var prefs = await SharedPreferences.getInstance();
          var body = response.body;
          prefs.setString(Constants.USER, body);
          prefs.setBool(Constants.IS_LOGGED_IN, true);
          print("Resposne Body :::: $body");

          var userJson = json.decode(body);
          var newUser = new CurrentUser.fromJSON(userJson);
          authorizationToken = newUser.data.token;
          if (newUser.data.is_random_password) {
            Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (context) =>
                  new ResetPasswordScreen(user: newUser)),
                  (Route<dynamic> newRoute) => false,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (context) => new Dashboard(newUser, 0)),
                  (Route<dynamic> newRoute) => false,
            );
          }
        } else {
          var errorJson = json.decode(response.body);
          showOkAlert(_context, errorJson["message"], true);
        }
      } catch (e) {
        print(e);
        showOkAlert(_context, 'Connection time-out', true);
      }

      setState(() {
        _showLoader = true;
      });
    }
  }


  String _validateEmail(String value) {
    if (value.isEmpty || !isEmailValid(value)) {
      errorsOnForm = true;
      return 'Please enter a valid email.';
    }
    errorsOnForm = false;
    username = value;
    return null;
  }

  String _validatePassword(String value) {
    if (!isPasswordValid(value)) {
      errorsOnForm = true;
      return 'Please enter a passsword with more than 6 character.';
    }
    errorsOnForm = false;
    password = value;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    var screenSize = MediaQuery.of(context).size;

    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            _email.unfocus();
            _password.unfocus();
          },
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                height: screenSize.height / 2 - reducedHeight,
                width: screenSize.width,
                child: new DecoratedBox(
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(colors: getColors()))),
              ),
              new Container(
                height: screenSize.height / 2 + reducedHeight,
                width: screenSize.width,
                color: Colors.white,
              ),
            ],
          ),
        ),
        new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Center(
                child: new CircleAvatar(
              backgroundColor: Colors.white,
              radius: 48.0,
                  backgroundImage: new AssetImage("assets/logo.png"),
            )),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: new Card(
                  elevation: 4.0,
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(4.0))),
                  child: new Padding(
                    padding: new EdgeInsets.all(16.0),
                    child: new Form(
                      key: _formKey,
                      child: new Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new TextFormField(
                              controller: _user,
                              validator: _validateEmail,
                              focusNode: _email,
                              onFieldSubmitted: (value) {
                                FocusScope
                                    .of(context)
                                    .requestFocus(_password);
                              },
                              decoration: new InputDecoration(
                                hintText: "Email ID",
                                border: new UnderlineInputBorder(),
                                suffixIcon: new Icon(Icons.email),
                              )),
                          new SizedBox(height: 16.0),
                          new TextFormField(
                            controller: _pass,
                            validator: _validatePassword,
                            focusNode: _password,
                            decoration: new InputDecoration(
                              hintText: "Password",
                              border: new UnderlineInputBorder(),
                              suffixIcon: new Icon(Icons.lock),
                            ),
                            obscureText: _obscureText,
                          ),
                          new SizedBox(height: 48.0),
                          new Center(
                            child: new Container(
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(32.0),
                                  gradient:
                                      new LinearGradient(colors: getColors())),
                              child: new ButtonTheme(
                                minWidth: screenSize.width,
                                height: buttonHeight,
                                child: new FlatButton(
                                  shape: new StadiumBorder(),
                                  onPressed: () {
                                    _password.unfocus();
                                    _validate();
                                  },
                                  child: new Text(
                                    "LOGIN",
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: buttonTitleFontSize),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new SizedBox(height: 32.0),
                        ],
                      ),
                    ),
                  )),
            ),
            new Center(
              child: new Material(
                color: Colors.transparent,
                child: new GestureDetector(
                  onTap: () {
                    print("FORGOT PRESSED");
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new ForgotPassword()));
                  },
                  child: new Text(
                    "Forgot Password?",
                    style: new TextStyle(
                        fontSize: buttonTitleFontSize, color: Colors.black),
                  ),
                ),
              ),
            )
          ],
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
}

//{
//"status": 1,
//"message": "User created successfully",
//"data": {
//"user_id": "1wdcnc0jhsugy4s",
//"first_name": "Lakhwinder",
//"last_name": "Singh",
//"email": "ls@gmail.com",
//"generated_password": "1wdcnc0jhsugy4t",
//"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjF3ZGNuYzBqaHN1Z3k0cyIsImVtYWlsIjoibHNAZ21haWwuY29tIiwiZmlyc3RfbmFtZSI6Ikxha2h3aW5kZXIiLCJsYXN0X25hbWUiOiJTaW5naCIsImlhdCI6MTUyNzY2ODY1MiwiZXhwIjoxNTI3NzU1MDUyfQ.VnyYLkzdGSZZ83IDeNNJKrkU2wIKiEL9bZWRISGOr74"
//},
//"event_status": "VALID"
//}
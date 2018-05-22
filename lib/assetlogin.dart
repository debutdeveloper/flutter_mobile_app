import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import 'package:debut_assets/Dashboard.dart';
import 'package:debut_assets/forgot_password.dart';
import 'package:debut_assets/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'utils.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _state();
  }
}

class _state extends State<Login> {
  static final TextEditingController _user = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();

  String username = _user.text;
  String password = _pass.text;

  bool rememberMe = false;
  bool errorsOnForm = false;
  bool _obscureText = true;

  bool _showLoader = true;

  FocusNode _password = new FocusNode();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext _context;

  bool isPasswordValid(String password) {
    return true;
  }

  void _validate() async {

    //print(new DateFormat.yMMMd().format(new DateTime.now()));
    if (_formKey.currentState.validate()) {
      final String loginURL = "http://192.168.0.18:3000/user/login";
      final credentials = {
        "email": username,
        "password": password,
        "device_token": "abrakadabra"
      };

      setState(() {
        _showLoader = false;
      });
      try{
        var response = await http.post(loginURL, body: credentials, headers: {}).timeout(new Duration(seconds: 10));
        print(response.body);

        if (response.statusCode == 200) {
          print("SUCCESSFULLY LOGIN");

          var userJson = json.decode(response.body);
          var newUser = new CurrentUser.fromJSON(userJson);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new Dashboard(newUser)));
        } else {
          var errorJson = json.decode(response.body);
          showAlert(_context,title: new Icon(Icons.error,color: Colors.red,),content: new Text(errorJson["message"]));
        }
      }
      catch(e){
        showAlert(_context,title: new Icon(Icons.error,color: Colors.red,),content: new Text('Connection time-out'));
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
    FocusScope.of(context).requestFocus(_password);
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
        new Column(
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
        new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Center(
                child: new CircleAvatar(
              backgroundColor: Colors.white,
              radius: 48.0,
              backgroundImage: new AssetImage("assets/logo.jpg"),
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
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(_password);
                              },
                              decoration: new InputDecoration(
                                hintText: "Email",
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
                                    setState(() {
//                                      _showLoader =
                                      _password.unfocus();
                                    });
                                    _validate();
                                  },
                                  child: new Text(
                                    "LOGIN",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 16.0),
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
                    style: new TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
        new Offstage(child: new Container( color: new Color.fromRGBO(1, 1, 1 , 0.3), child: new Center(child: new CircularProgressIndicator(backgroundColor: Colors.transparent,),)),
        offstage: _showLoader,)
      ],
    );
  }
}

//{
//"status": 1,
//"message": "User created successfully",
//"data": {
//"user_id": "bbumv1uu9us7j0j8rjgg",
//"first_name": "lakhwinder",
//"last_name": "Singh",
//"email": "lakhwinder.singh@debutinfotech.com",
//"generated_password": "bbumv1uu9us7j0j8rjg0",
//"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImJidW12MXV1OXVzN2owajhyamdnIiwiZW1haWwiOiJsYWtod2luZGVyLnNpbmdoQGRlYnV0aW5mb3RlY2guY29tIiwiaWF0IjoxNTI2NTU4NTk5LCJleHAiOjE1MjY2NDQ5OTl9.pJlKzKEAFSprJ4V2EFUq4Aqvn5r6VP4Rq3Z-4ELJ6qc"
//},
//"event_status": "VALID"
//}

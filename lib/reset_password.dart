import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(new MaterialApp(
    home: new ResetPasswordScreen(),
  ));
}

class ResetPasswordScreen extends StatefulWidget {
  @override
  ResetPasswordScreenState createState() => new ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // State properties
  String _newPassword = '';
  String _confirmedPassword = '';

  // Keys
  final _resetPasswordFormKey = new GlobalKey<FormState>();

  // Constraint properties
  Size _screenSize;

  // Methods
  void _submit() {
    final form = _resetPasswordFormKey.currentState;

    if (form.validate()) {
      form.save();
    }
  }

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
                height: _screenSize.height / 2.8,
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

                            decoration: new InputDecoration(
                              hintText: "New Password",
                              border: new UnderlineInputBorder(),
                              suffixIcon: new Icon(Icons.email),
                            )),
                      ),
                      new SizedBox(height: 16.0),
                      new Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16.0, 0.0, 16.0, 0.0),
                        child: new TextFormField(

                          decoration: new InputDecoration(
                            hintText: "Confirm Password",
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
                                  _submit();
                                },
                                color: Colors.transparent,
                                child: new Text(
                                  'CHANGE PASSWORD',
                                  style: new TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                      )
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

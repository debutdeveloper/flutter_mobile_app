import 'package:debut_assets/utils.dart';
import 'package:flutter/material.dart';

class RequestAsset extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<RequestAsset> {
  static final TextEditingController _user = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();

  String username = _user.text;
  String password = _pass.text;

  bool rememberMe = false;
  bool errorsOnForm = false;

  bool _obscureText = true;

  FocusNode _password = new FocusNode();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Request For Asset"),
      ),
      body: new Container(
          color: Colors.white,
          height: screenSize.height,
          width: screenSize.width,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SizedBox(
                height: 24.0,
              ),
              new Padding(
                padding: new EdgeInsets.all(16.0),
                child: new Card(
                    elevation: 4.0,
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(4.0)),
                    child: new Padding(
                      padding: new EdgeInsets.all(16.0),
                      child: new Form(
                        key: _formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Material(
                              child: new Text(
                                "REQUEST FOR ASSEST",
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            new SizedBox(
                              height: 24.0,
                            ),
                            new TextFormField(
                                maxLines: 1,
                                decoration: new InputDecoration(
                                  hintText: "Asset needs to",
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(12.0)),
                                )),
                            new SizedBox(
                              height: 8.0,
                            ),
                            new TextFormField(
                                maxLines: 1,
                                decoration: new InputDecoration(
                                  hintText: "Asset needs upto",
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(12.0)),
                                )),
                            new SizedBox(
                              height: 8.0,
                            ),
                            new TextFormField(
                                maxLines: 1,
                                decoration: new InputDecoration(
                                  hintText: "Employee ID",
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(12.0)),
                                )),
                            new SizedBox(
                              height: 8.0,
                            ),
                            new GestureDetector(
                              onTap: () {
                                print("adhsfadfks");
                              },
                              child: new TextFormField(
                                  maxLines: 5,
                                  decoration: new InputDecoration(
                                    hintText: "Purpose",
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                        new BorderRadius.circular(12.0)),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 64.0, right: 64.0),
                child: new Container(
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(32.0),
                      gradient: new LinearGradient(colors: getColors())),
                  child: new ButtonTheme(
                    minWidth: screenSize.width,
                    height: buttonHeight,
                    child: new FlatButton(
                      onPressed: () {

                      },
                      shape: new StadiumBorder(),
                      child: new Text(
                        "REQUEST",
                        style: new TextStyle(
                            color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

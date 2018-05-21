import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/material.dart';

class RequestAsset extends StatefulWidget {
  final User user;
  final Asset asset;

  RequestAsset({@required this.user,@required this.asset});

  @override
  _State createState() => new _State();
}

enum RequestPriority {
  high,
  medium,
  low,
}

class _State extends State<RequestAsset> {
  static final TextEditingController _user = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String username = _user.text;
  String password = _pass.text;
  double priority = 0.0;

  bool rememberMe = false;
  bool errorsOnForm = false;

  TimeOfDay _startTime = new TimeOfDay.now();
  TimeOfDay _endTime = new TimeOfDay.now();

  Future startTimePicker(BuildContext context) async {
    final TimeOfDay time = await showTimePicker(context: context, initialTime: _startTime);

    /// Check selected date
    if (time != null) {
      setState(() {
        _startTime = time;
        print("starttime $_startTime");
      });
    }
  }

  Future endTimePicker(BuildContext context) async {
    final TimeOfDay time = await showTimePicker(context: context, initialTime: _endTime);

    /// Check selected date
    if (time != null) {
      setState(() {
        _endTime = time;
        print(_endTime);
      });
    }
  }

  _requestForAsset() async{
    if (_formKey.currentState.validate()) {
      final String requestURL = "http://192.168.0.18:3000/request/" +
          widget.asset.record.category.id;
      final credentials = {
        "description": "POORNIMA TK",
        "start_time": "10/12/2017 23:59:30",
        "end_time": "10/12/2017 00:59:30",
        "priority": "1",
        "user": {
          "id": "bbukl4eu9us7j0j8rj5g",
          "first_name": "Raj",
          "last_name": "Thakur"
        },
        "asset": {
          "id": "bbukk4eu9us7j0j8rj4g",
          "name": "Iphone 6s",
          "description": "sfsddas"
        }
      };

      var response = await http.post(
          requestURL, body: credentials, headers: {});
      print(response.body);


      if (response.statusCode == 200) {
        print("SUCCESSFULLY REQUEST SENT");
        scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Requested Successfully"))
        );
      } else {
        scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: new Text("Something went wrong"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

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
//                            new TextFormField(
//                                maxLines: 1,
//                                keyboardType: ,
//                                decoration: new InputDecoration(
//                                  hintText: "Asset needs from",
//                                  labelText:  "Asset needs from",
//                                  border: new OutlineInputBorder(
//                                      borderRadius:
//                                          new BorderRadius.circular(12.0)),
//                                )),
                            new GestureDetector(
                              onTap: () { startTimePicker(context); },
                              child: new Container(
                                height: 48.0,
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(12.0)),
                                    border: new Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    )),
                                child: new Center(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Text('Today:',
                                        style: const TextStyle(
                                          fontSize: 18.0
                                        ),
                                      ),
                                      new Text(_startTime.toString(),
                                        style: const TextStyle(
                                            fontSize: 18.0
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            new SizedBox(
                              height: 8.0,
                            ),
//                            new TextFormField(
//                                maxLines: 1,
//                                decoration: new InputDecoration(
//                                  hintText: "Asset needs upto",
//                                  border: new OutlineInputBorder(
//                                      borderRadius:
//                                          new BorderRadius.circular(12.0)),
//                                )),
                            new GestureDetector(
                              onTap: () { endTimePicker(context); },
                              child: new Container(
                                height: 48.0,
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(12.0)),
                                    border: new Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    )),
                                child: new Center(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Text('Today:',
                                        style: const TextStyle(
                                            fontSize: 18.0
                                        ),
                                      ),
                                      new Text(_endTime.toString(),
                                        style: const TextStyle(
                                            fontSize: 18.0
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            new SizedBox(
                              height: 8.0,
                            ),
                            new TextFormField(
                                maxLines: 1,
                                initialValue: widget.user.data.emp_id,
                                enabled: false,
                                decoration: new InputDecoration(
                                  labelText: "Employee ID",
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(12.0),
                                  ),
                                )
                            ),
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
                            new SizedBox(
                              height: 8.0,
                            ),
                            new Container(
                              padding: new EdgeInsets.only(
                                  left: 4.0, right: 4.0, bottom: 4.0),
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(12.0)),
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  )),
                              child: new Row(
                                children: <Widget>[
                                  new Text(
                                    "Priority",
                                    style: new TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  new SizedBox(
                                    width: 12.0,
                                  ),
                                  new Expanded(
                                    child: new Column(
                                      children: <Widget>[
                                        new Slider(
                                          max: 2.0,
                                          min: 0.0,
                                          label: setSliderLabel(),
                                          value: priority,
                                          onChanged: (value) {
                                            setState(() {
                                              priority = value;
                                            });
                                          },
                                          divisions: 2,
                                        ),
                                        new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Text(
                                              "Low",
                                              style: new TextStyle(
                                                color: priority == 0.0
                                                    ? Colors.blue
                                                    : Colors.black,
                                              ),
                                            ),
                                            new Text(
                                              "Medium",
                                              style: new TextStyle(
                                                color: priority == 1.0
                                                    ? Colors.blue
                                                    : Colors.black,
                                              ),
                                            ),
                                            new Text(
                                              "High",
                                              style: new TextStyle(
                                                color: priority == 2.0
                                                    ? Colors.blue
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
              new Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 64.0, right: 64.0),
                child: new Container(
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(32.0),
                      gradient: new LinearGradient(colors: getColors())),
                  child: new ButtonTheme(
                    minWidth: screenSize.width,
                    height: buttonHeight,
                    child: new FlatButton(
                      onPressed: () {
                        _requestForAsset();
                      },
                      shape: new StadiumBorder(),
                      child: new Text(
                        "REQUEST",
                        style:
                            new TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  String setSliderLabel() {
    switch (priority.truncate()) {
      case 0:
        return "Low";
      case 1:
        return "Medium";
      case 2:
        return "High";
      default:
        return 'Low';
    }
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestAsset extends StatefulWidget {
  final CurrentUser user;
  final Asset asset;

  RequestAsset({@required this.user, @required this.asset});

  @override
  _State createState() => new _State();
}

enum RequestPriority {
  high,
  medium,
  low,
}

class _State extends State<RequestAsset> {
  static final TextEditingController _purposeController =
      new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String get _purpose => _purposeController.text;
  double priority = 0.0;

  bool rememberMe = false;
  bool errorsOnForm = false;

  bool isStartTimeSelected = false;
  bool isEndTimeSelected = false;

  TimeOfDay _actualStartTime = new TimeOfDay.now();

  String _startTimeLabel = 'Select time';
  String _endTimeLabel = 'Select time';

  String _startTimeString =
      '${new TimeOfDay.now().hour}:${new TimeOfDay.now().minute}:00';
  String _endTimeString =
      '${new TimeOfDay.now().hour}:${new TimeOfDay.now().minute}:00';

  String _today = new DateFormat("dd/MM/yyyy").format(new DateTime.now());

  Future startTimePicker(BuildContext context) async {
    final TimeOfDay time = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());

    /// Check selected date
    if (time != null) {
      if (time.hour == new TimeOfDay.now().hour) {
        if (time.minute > new TimeOfDay.now().minute) {
          setState(() {
            _startTimeLabel = time.format(context);
            _startTimeString = '${time.hour}:${time.minute}:00';
            _actualStartTime = time;
            isStartTimeSelected = true;
            _endTimeLabel = "Select date";
          });
        } else {
          print("failed 1");
          showAlert(context,
              title: new Icon(
                Icons.error,
                color: Colors.red,
              ),
              content: new Text("Selected time is not valid"),
              materialActions: <Widget>[
                new CupertinoDialogAction(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  isDefaultAction: true,
                ),
              ],
              cupertinoActions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("OK"))
              ]);
        }
      } else if (time.hour > new TimeOfDay.now().hour) {
        setState(() {
          _startTimeLabel = time.format(context);
          _startTimeString = '${time.hour}:${time.minute}:00';
          _actualStartTime = time;
          isStartTimeSelected = true;
          isEndTimeSelected = false;
          _endTimeLabel = "Select time";
        });
      } else {
        print("failed 2");
        showAlert(context,
            title: new Icon(
              Icons.error,
              color: Colors.red,
            ),
            content: new Text("Selected time is not valid"),
            materialActions: <Widget>[
              new CupertinoDialogAction(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                isDefaultAction: true,
              ),
            ],
            cupertinoActions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("OK"))
            ]);
      }
    } else {
      print('failed 3');
      showAlert(context,
          title: new Icon(
            Icons.error,
            color: Colors.red,
          ),
          content: new Text("Please select time"),
          materialActions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
            ),
          ],
          cupertinoActions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("OK"))
          ]);
    }
  }

  Future endTimePicker(BuildContext context) async {
    final TimeOfDay time = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());

    /// Check selected date
    //   && (time.hour >= _actualStartTime.hour && time.minute > _actualStartTime.minute)
    if (time != null) {
      if (time.hour == _actualStartTime.hour) {
        if (time.minute > _actualStartTime.minute) {
          setState(() {
            _endTimeLabel = time.format(context);
            isEndTimeSelected = true;
            _endTimeString = '${time.hour}:${time.minute}:00';
          });
        } else {
          print("Failed 1");
          showAlert(context,
              title: new Icon(
                Icons.error,
                color: Colors.red,
              ),
              content: new Text("Selected time is not valid"),
              materialActions: <Widget>[
                new CupertinoDialogAction(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  isDefaultAction: true,
                ),
              ],
              cupertinoActions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("OK"))
              ]);
        }
      } else if (time.hour > _actualStartTime.hour) {
        setState(() {
          _endTimeLabel = time.format(context);
          isEndTimeSelected = true;
          _endTimeString = '${time.hour}:${time.minute}:00';
        });
      } else {
        print("Failed 2");
        showAlert(context,
            title: new Icon(
              Icons.error,
              color: Colors.red,
            ),
            content: new Text("Selected time is not valid"),
            materialActions: <Widget>[
              new CupertinoDialogAction(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                isDefaultAction: true,
              ),
            ],
            cupertinoActions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("OK"))
            ]);
      }
    } else {
      print('failed 3');
      showAlert(context,
          title: new Icon(
            Icons.error,
            color: Colors.red,
          ),
          content: new Text("Please select time"),
          materialActions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
            ),
          ],
          cupertinoActions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("OK"))
          ]);
    }
  }

  String _validatePurpose(String value) {
    if (value.isEmpty) {
      return "Please enter purpose";
    } else {
      return null;
    }
  }

  _requestForAsset() async {
    print("Date : ${new DateFormat("dd-MM-yyyy").format(new DateTime.now())}");
    if (isStartTimeSelected && isEndTimeSelected) {
      if (_formKey.currentState.validate()) {
        final String requestURL = requestAPI + widget.asset.record.category.id;
        final credentials = {
          "description": _purpose,
          "start_time": "${new DateFormat("dd/MM/yyyy").format(new DateTime.now())} $_startTimeString",
          "end_time": "${new DateFormat("dd/MM/yyyy").format(new DateTime.now())} $_endTimeString",
          "priority": priority.round().toString(),
          "user": {
            "id": widget.user.id,
            "first_name": widget.user.data.first_name,
            "last_name": widget.user.data.last_name
          },
          "asset": {
            "id": widget.asset.record.category.id,
            "name": widget.asset.record.name,
            "description": widget.asset.record.description
          }
        };

        try {
          var response = await http.post(requestURL,
              body: json.encode(credentials),
              headers: {
                "Authorization": widget.user.data.token,
              }).timeout(timeoutDuration);
          print(response.body);
          print(json.encode(credentials));

          if (response.statusCode == 200) {
            print("SUCCESSFULLY REQUEST SENT");
            scaffoldKey.currentState.showSnackBar(
                new SnackBar(content: new Text("Requested Successfully")));
          } else {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text("Something went wrong, Request not sent.")));
            print(response.statusCode);
          }
        } catch (e) {
          print(e);
          scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text("Connection time-out, Request not sent.")));
        }
      }
    } else {
      showAlert(context,
          title: new Icon(
            Icons.error,
            color: Colors.red,
          ),
          content: new Text("All fields are required"),
          materialActions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
            ),
          ],
          cupertinoActions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("OK"))
          ]);
    }
    _purposeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    print("Today is: $_today");
    var screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("Request For Asset"),
      ),
      body: new SingleChildScrollView(
        child: new Container(
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
                              new Text(
                                "REQUEST FOR ASSEST",
                                style: new TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              new SizedBox(
                                height: 24.0,
                              ),
//
                              new GestureDetector(
                                onTap: () {
                                  startTimePicker(context);
                                },
                                child: new Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Text(
                                          'From (Today):',
                                          style: new TextStyle(
                                              fontSize:
                                                  timePickerFieldFontSize),
                                        ),
                                        new Text(
                                          _startTimeLabel,
                                          style: new TextStyle(
                                              fontSize: timePickerFieldFontSize,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              new SizedBox(
                                height: 8.0,
                              ),
                              new GestureDetector(
                                onTap: () {
                                  endTimePicker(context);
                                },
                                child: new Container(
                                  height: 48.0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(12.0)),
                                      border: new Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      )),
                                  child: new Center(
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Text(
                                          'To (Today):',
                                          style: new TextStyle(
                                              fontSize:
                                                  timePickerFieldFontSize),
                                        ),
                                        new Text(
                                          _endTimeLabel,
                                          style: new TextStyle(
                                              fontSize: timePickerFieldFontSize,
                                              fontWeight: FontWeight.bold),
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
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                  decoration: new InputDecoration(
                                    labelText: "Employee ID",
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(12.0),
                                    ),
                                  )),
                              new SizedBox(
                                height: 8.0,
                              ),
                              new TextFormField(
                                  maxLines: 5,
                                  controller: _purposeController,
                                  validator: _validatePurpose,
                                  decoration: new InputDecoration(
                                    hintText: "Purpose",
                                    labelText: "Purpose",
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(12.0)),
                                  )),
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: new Row(
                                    children: <Widget>[
                                      new Text(
                                        "Priority",
                                        style: new TextStyle(
                                            fontSize: sliderFieldFontSize),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                new Text(
                                                  "Low",
                                                  style: new TextStyle(
                                                      color: priority == 0.0
                                                          ? Colors.blue
                                                          : Colors.black,
                                                      fontSize:
                                                          descriptionFontSize),
                                                ),
                                                new Text(
                                                  "Medium",
                                                  style: new TextStyle(
                                                      color: priority == 1.0
                                                          ? Colors.blue
                                                          : Colors.black,
                                                      fontSize:
                                                          descriptionFontSize),
                                                ),
                                                new Text(
                                                  "High",
                                                  style: new TextStyle(
                                                      color: priority == 2.0
                                                          ? Colors.blue
                                                          : Colors.black,
                                                      fontSize:
                                                          descriptionFontSize),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
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
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: buttonTitleFontSize),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
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

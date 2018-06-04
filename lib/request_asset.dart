import 'dart:async';
import 'dart:convert';

import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RequestAsset extends StatefulWidget {
  final CurrentUser user;
  final Asset asset;

  RequestAsset({@required this.user, @required this.asset});

  @override
  _State createState() => new _State();
}

class _State extends State<RequestAsset> {
  static final TextEditingController _purposeController =
      new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode _purposeFieldFocus = new FocusNode();

  String get _purpose => _purposeController.text;
  double priority = 0.0;

  bool rememberMe = false;
  bool errorsOnForm = false;
  bool _showLoader = true;

  bool isStartTimeSelected = false;
  bool isEndTimeSelected = false;

  TimeOfDay _actualStartTime = new TimeOfDay.now();

  String _startTimeLabel = 'Select time';
  String _endTimeLabel = 'Select time';

  String _startTimeString =
      '${new TimeOfDay.now().toString().substring(10,15)}:00';
  String _endTimeString =
      '${new TimeOfDay.now().toString().substring(10,15)}:00';

  String _today = new DateFormat("dd/MM/yyyy").format(new DateTime.now());

  Future startTimePicker(BuildContext context, bool isStart) async {
    final TimeOfDay currentTime = new TimeOfDay.now();
    final TimeOfDay time = await showTimePicker(
        context: context, initialTime: currentTime);
    /// Check selected date
    if (time != null) {
      if (time.hour == currentTime.hour && time.minute > currentTime.minute) {
          setState(() {
            _startTimeLabel = time.format(context);
            _startTimeString = '${time.toString().substring(10,15)}:00';
            _actualStartTime = time;
          });
      } else {
        alert("Please select valid time");
      }
    }
  }


  alert(String message) {
    showAlert(context,
        title: new Icon(
          Icons.error,
          color: Colors.red,
        ),
        content: new Text(message),
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


  String _validatePurpose(String value) {
    if (value.isEmpty) {
      return "Please enter purpose";
    } else {
      return null;
    }
  }

  _requestForAsset() async {
    print(
        "Date : ${new DateFormat("dd-MM-yyyy").format(
            new DateTime.now().toUtc())}");
    if (isStartTimeSelected && isEndTimeSelected) {
      if (_formKey.currentState.validate()) {
        var utcStartTime = new DateFormat("dd/MM/yyyy HH:mm:ss")
            .parse(_today + " " + _startTimeString)
            .toUtc();
        var utcEndTime = new DateFormat("dd/MM/yyyy HH:mm:ss")
            .parse(_today + " " + _endTimeString)
            .toUtc();
        var formatter = new DateFormat("dd/MM/yyyy HH:mm:ss");
        var formattedStartDate =
        formatter.format(utcStartTime).toString().substring(0, 19);
        var formattedEndDate =
        formatter.format(utcEndTime).toString().substring(0, 19);

        final String requestURL = requestAPI;
        final credentials = {
          "description": _purpose,
          "start_time": formattedStartDate,
          "end_time": formattedEndDate,
          "priority": priority.round().toString(),
          "user": {
            "id": widget.user.id,
            "first_name": widget.user.data.first_name,
            "last_name": widget.user.data.last_name
          },
          "asset": {
            "id": widget.asset.key,
            "name": widget.asset.record.name,
            "description": widget.asset.record.description
          }
        };

        print(json.encode(credentials));

        setState(() {
          _showLoader = false;
        });

        try {
          var response = await http
              .post(requestURL, body: json.encode(credentials), headers: {
            "Authorization": authorizationToken,
            "Content-Type": "application/json",
          }).timeout(timeoutDuration);
          print(response.body);

          if (response.statusCode == 200) {
            var responseJson = json.decode(response.body);
            print("SUCCESSFULLY REQUEST SENT");
            showAlert(
              context,
              title: new Title(color: Colors.blue, child: new Text("Success")),
              content: new Text(responseJson["message"]),
              cupertinoActions: <Widget>[
                new CupertinoDialogAction(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
              materialActions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: new Text("OK"))
              ],
            );
          } else {
            var errorJson = json.decode(response.body);
            showAlert(
              context,
              title: new Icon(
                Icons.error,
                color: Colors.red,
              ),
              content: new Text(errorJson["message"]),
              cupertinoActions: <Widget>[
                new CupertinoDialogAction(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              materialActions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text("OK"))
              ],
            );
            print(response.statusCode);
          }
        } catch (e) {
          showAlert(
            context,
            title: new Icon(
              Icons.error,
              color: Colors.red,
            ),
            content: new Text('Connection time-out'),
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

        setState(() {
          _showLoader = true;
        });
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
  }

  @override
  Widget build(BuildContext context) {
    print("Today is: $_today");
    var screenSize = MediaQuery.of(context).size;
    return new Stack(
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            print("on tap called");
            _purposeFieldFocus.unfocus();
          },
//          onVerticalDragDown: (value) {
//            print("on drag called");
//            _purposeFieldFocus.unfocus();
//          },
          child: new Scaffold(
            key: scaffoldKey,
            appBar: new AppBar(
              title: new Text("Request For Asset"),
              leading: new IconButton(
                  icon: new Icon(
                    Icons.keyboard_arrow_left,
                    size: 40.0,
                  ),
                  onPressed: () {
                    _purposeFieldFocus.unfocus();
                    _purposeController.clear();
                    Navigator.pop(context);
                  }),
              automaticallyImplyLeading: false,
            ),
            body: new SingleChildScrollView(
              child: new Container(
                  color: Colors.white,
                  height: screenSize.height,
                  width: screenSize.width,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                                      "REQUEST FOR ASSET",
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
                                        _purposeFieldFocus.unfocus();
                                        startTimePicker(context, true);
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
                                                    fontSize:
                                                    timePickerFieldFontSize,
                                                    fontWeight:
                                                    FontWeight.bold),
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
                                        _purposeFieldFocus.unfocus();
                                        startTimePicker(context, false);
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
                                                    fontSize:
                                                    timePickerFieldFontSize,
                                                    fontWeight:
                                                    FontWeight.bold),
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
                                    new EnsureVisibleWhenFocused(
                                      focusNode: _purposeFieldFocus,
                                      child: new TextFormField(
                                          maxLines: 5,
                                          controller: _purposeController,
                                          validator: _validatePurpose,
                                          focusNode: _purposeFieldFocus,
                                          onFieldSubmitted: (value) {
                                            _purposeFieldFocus.unfocus();
                                          },
                                          decoration: new InputDecoration(
                                            hintText: "Purpose",
                                            labelText: "Purpose",
                                            border: new OutlineInputBorder(
                                                borderRadius:
                                                new BorderRadius.circular(
                                                    12.0)),
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: new Row(
                                          children: <Widget>[
                                            new Text(
                                              "Priority",
                                              style: new TextStyle(
                                                  fontSize:
                                                  sliderFieldFontSize),
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
                                                      _purposeFieldFocus
                                                          .unfocus();
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
                                                            color: priority ==
                                                                0.0
                                                                ? Colors.blue
                                                                : Colors.black,
                                                            fontSize:
                                                            descriptionFontSize),
                                                      ),
                                                      new Text(
                                                        "Medium",
                                                        style: new TextStyle(
                                                            color: priority ==
                                                                1.0
                                                                ? Colors.blue
                                                                : Colors.black,
                                                            fontSize:
                                                            descriptionFontSize),
                                                      ),
                                                      new Text(
                                                        "High",
                                                        style: new TextStyle(
                                                            color: priority ==
                                                                2.0
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
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 64.0, right: 64.0),
                        child: new Container(
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(32.0),
                              gradient:
                              new LinearGradient(colors: getColors())),
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

import 'dart:async';
import 'dart:convert';

import 'package:debut_assets/Dashboard.dart';
import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  String _startTimeLabel = 'Select time';
  String _endTimeLabel = 'Select time';
  TimeOfDay _actualStartTime = new TimeOfDay.now();

  String _startTimeString =
      '${new TimeOfDay.now().toString().substring(10,15)}:00';
  String _endTimeString =
      '${new TimeOfDay.now().toString().substring(10,15)}:00';

  String _today = new DateFormat("dd/MM/yyyy").format(new DateTime.now());

  Future requestTimePicker(BuildContext context, bool isStart) async {
    final TimeOfDay currentTime = new TimeOfDay.now();
    final TimeOfDay time =
    await showTimePicker(context: context, initialTime: currentTime);

    /// Check selected date
    if (time != null) {
      if (isStart) {
        if (time.hour == currentTime.hour) {
          if (time.minute > currentTime.minute) {
            setState(() {
              _startTimeLabel = time.format(context);
              _startTimeString = '${time.toString().substring(10, 15)}:00';
              isStartTimeSelected = true;
              _actualStartTime = time;
              _endTimeLabel = "Select time";
            });
          } else {
            showOkAlert(context, "Please select valid time", true);
          }
        } else if (time.hour > currentTime.hour) {
          setState(() {
            _startTimeLabel = time.format(context);
            _startTimeString = '${time.toString().substring(10,15)}:00';
            isStartTimeSelected = true;
            _actualStartTime = time;
            _endTimeLabel = "Select time";
          });
        } else {
          showOkAlert(context, "Please select valid time", true);
        }
      } else {
        if (time.hour == _actualStartTime.hour) {
          if (time.minute >= (_actualStartTime.minute + 15)) {
            setState(() {
              _endTimeLabel = time.format(context);
              _endTimeString = '${time.toString().substring(10, 15)}:00';
              isEndTimeSelected = true;
            });
          } else {
            showOkAlert(
                context,
                "Please select minimum 15 minute gap between start time and end time",
                true);
          }
        } else if (time.hour > _actualStartTime.hour) {
          setState(() {
            _endTimeLabel = time.format(context);
            _endTimeString = '${time.toString().substring(10, 15)}:00';
            isEndTimeSelected = true;
          });
        } else {
          showOkAlert(context,
              "End time must be greater than start time selected.", true);
        }
      }
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
    final String format = "dd/MM/yyyy HH:mm:ss";
    print("Date : ${new DateFormat("dd-MM-yyyy").format(
            new DateTime.now().toUtc())}");
    if (isStartTimeSelected && isEndTimeSelected) {
      if (_formKey.currentState.validate()) {
        var utcStartTime = new DateFormat(format)
            .parse(_today + " " + _startTimeString)
            .toUtc();
        var utcEndTime =
        new DateFormat(format).parse(_today + " " + _endTimeString).toUtc();
        var formatter = new DateFormat(format);
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

        print("request credentials 1 :::: ${json.encode(credentials)}");

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
          print("request credentials 2 :::: ${json.encode(credentials)}");
          if (response.statusCode == 200) {
            var responseJson = json.decode(response.body);
            print("SUCCESSFULLY REQUEST SENT");

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
                          Navigator.of(context).pushAndRemoveUntil(
                            new MaterialPageRoute(
                                builder: (context) =>
                                new Dashboard(widget.user, 0)),
                                (Route<dynamic> newRoute) => false,
                          );
                        },
                        child: new Text(
                          "OK",
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
                          Navigator.of(context).pushAndRemoveUntil(
                            new MaterialPageRoute(
                                builder: (context) =>
                                new Dashboard(widget.user, 0)),
                                (Route<dynamic> newRoute) => false,
                          );
                        },
                        child: new Text("OK"),
                      )
                    ],
                  );
                });
          } else {
            var errorJson = json.decode(response.body);
            showOkAlert(context, errorJson["message"], true);
            print(response.statusCode);
          }
        } catch (e) {
          showOkAlert(context, "Connection time-out", true);
        }

        setState(() {
          _showLoader = true;
        });
      }
    } else {
      showOkAlert(context, "All fields are required", true);
    }
    _purposeController.clear();
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
                                    new GestureDetector(
                                      onTap: () {
                                        _purposeFieldFocus.unfocus();
                                        requestTimePicker(context, true);
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
                                        requestTimePicker(context, false);
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
                                    new TextFormField(
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

import 'dart:convert';

import 'package:debut_assets/models/Request.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HandOverAsset extends StatefulWidget {
  final Request request;
  final CurrentAsset asset;

  HandOverAsset({@required this.asset, this.request});

  @override
  _HandOverAssetState createState() => new _HandOverAssetState();
}

class _HandOverAssetState extends State<HandOverAsset> {
  bool _showLoader = true;
  bool empOffStage = true;
  int _handOverAssetTo = 1;

  @override
  void initState() {
    if (widget.request != null && widget.request.id != null) {
      empOffStage = false;
    }
    super.initState();
  }

  _handoverAsset(BuildContext context) async {
    print("Date : ${new DateFormat("dd-MM-yyyy").format(new DateTime.now())}");
    final String url = handoverAPI;

    final credentials = {
      "description": widget.request?.value?.currentAsset?.description,
      "start_timing": widget.request?.value?.start_timing,
      "end_timing": widget.request?.value?.start_timing,
      "priority": widget.request?.value?.priority,
      "user": {
        "id": widget.request?.value?.user?.id,
        "first_name": widget.request?.value?.user?.first_name,
        "last_name": widget.request?.value?.user?.last_name
      },
      "request_id": widget?.request?.id,
      "old_request_id": widget?.request?.old_request_id,
      "asset": {
        "id": widget.asset.id,
        "description": widget.asset.description,
        "name": widget.asset.name,
      },
      "req_type": _handOverAssetTo
    };

    setState(() {
      _showLoader = false;
    });

    try {
      var body = json.encode(credentials);
      print(body);
      print(authorizationToken);

      var response = await http.put(url, body: body, headers: {
        "Authorization": authorizationToken,
        "Content-Type": "application/json",
      }).timeout(timeoutDuration);
      print(response.body);
      if (response.statusCode == 200) {
        print("HANDOVER SUCCESSFULLY");

        defaultTargetPlatform == TargetPlatform.iOS
            ? showDialog(
            context: context,
            builder: (context) {
              return new CupertinoAlertDialog(
                title: new Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                content: new Text("Success"),
                actions: <Widget>[
                  new CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
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
                content: new Text("Success"),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: new Text("OK"),
                  )
                ],
              );
            });

      } else {
        var errorJson = json.decode(response.body);

        showOkAlert(context, errorJson["message"], true);
      }
    } catch (e) {
      showOkAlert(context, 'Connection time-out', true);
    }

    setState(() {
      _showLoader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    return new Stack(
      children: <Widget>[
        new Scaffold(
          appBar: new AppBar(
            title: new Text("HANDOVER ASSET"),
            leading: new IconButton(
                icon: new Icon(
                  Icons.keyboard_arrow_left,
                  size: 40.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            automaticallyImplyLeading: false,
          ),
          body: new SingleChildScrollView(
            child: new Container(
                color: Colors.white,
                //height: screenSize.height,
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
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    "HANDOVER ASSET TO",
                                    style: new TextStyle(
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  new SizedBox(
                                    height: 24.0,
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new RadioListTile(
                                          selected: false,
                                          value: 1,
                                          groupValue: _handOverAssetTo,
                                          onChanged: (value) {
                                            setState(() {
                                              _handOverAssetTo = value;
                                            });
                                            print("$value");
                                          },
                                          title: new Text("Admin"),
                                        ),
                                      ),
                                      new Flexible(
                                        child: new Offstage(
                                          offstage: empOffStage,
                                          child: new RadioListTile(
                                            value: 0,
                                            groupValue: _handOverAssetTo,
                                            onChanged: (value) {
                                              setState(() {
                                                _handOverAssetTo = value;
                                              });
                                              print("$value");
                                            },
                                            title: new Text(
                                                "${widget.request?.value?.user
                                                    ?.first_name}" ??
                                                    "Emp"),
                                          ),
                                        ),
                                      )
                                    ],
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
                              _handoverAsset(context);
                            },
                            shape: new StadiumBorder(),
                            child: new Text(
                              "HANDOVER",
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

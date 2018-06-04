import 'dart:async';
import 'dart:convert';

import 'package:debut_assets/handOverDevice.dart';
import 'package:debut_assets/models/Request.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyAssets extends StatefulWidget {
  final CurrentUser user;
  MyAssets(this.user);

  @override
  _CardViewState createState() => new _CardViewState();
}

class _CardViewState extends State<MyAssets> {
  List requestList;
  List<Request> listOfRequests = [];
  bool _showLoader = true;

  Future getAssetHistory() async {

    setState(() {
      _showLoader = false;
    });

    try {
      var response = await http.get(myAssetsAPI, headers: {
        "Authorization": authorizationToken
      }).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        print(response.body);
        var assetHistoryJson = json.decode(response.body);
        var requestListJson = assetHistoryJson["requests"];
        List<Request> listOfRequests = [];
        for (var requestJSON in requestListJson) {
          Request request = new Request.fromJSON(requestJSON);
          listOfRequests.add(request);
        }
        this.listOfRequests.clear();
        setState(() {
          this.listOfRequests = listOfRequests;
        });
      } else {
        print("response !200");
        var errorJson = json.decode(response.body);
        alert(errorJson["message"], true);
      }
    } catch (e) {
      print("inside catch");
      alert('Connection time-out', true);
    }

    setState(() {
      print("Hide loader");
      _showLoader = true;
    });
  }

  void alert(String message, bool isFail) {
    showAlert(
      context,
      title: new Icon(
        isFail ? Icons.error : Icons.tag_faces,
        color: isFail ? Colors.red : Colors.green,
      ),
      content: new Text(message),
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

  @override
  void initState() {
    super.initState();
    getAssetHistory();
  }

  Widget getMyAssetList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new MyAssetCard(
              asset: listOfRequests[index],
              user: widget.user,
            ),
            const SizedBox(
              height: 12.0,
            ),
          ],
        );
      },
      itemCount: listOfRequests.isEmpty ? 1 : listOfRequests.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.black12,
      child: new Stack(
        children: <Widget>[
          listOfRequests.length > 0
              ? getMyAssetList()
              : getNoDataView("No Asset Found"),
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
      ),
    );
  }
}

class MyAssetCard extends StatelessWidget {
  final Request asset;
  final CurrentUser user;
  MyAssetCard({@required this.asset, @required this.user});

  _popupMenuAction(int value, BuildContext context) {
    switch (value) {
      case 0:
        _handoverToNextRequest(context);
        //Navigator.push(context, new MaterialPageRoute(builder: (context)=>new HandOverAsset()));
        break;
    }
  }

  _handoverToNextRequest(BuildContext context) async {
    String url = nextRequestAPI;
    var credentials = {
      "asset_id": asset.value.currentAsset.id,
    };

    try {
      print("request : $credentials");
      var response = await http.post(url, body: credentials, headers: {
        "Authorization": authorizationToken
      }).timeout(timeoutDuration);

      print(authorizationToken);
      if (response.statusCode == 200) {
        print("response 200");
        print(response.body);
        var responseData = json.decode(response.body);
        Map<String, dynamic> req = responseData["request"];
        if (req.length > 0) {
          print("Next request response: $req");
          Request nextRequest = new Request.fromJSON(req);
          nextRequest.old_request_id = asset.id;
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                  new HandOverAsset(
                    asset: asset.value.currentAsset,
                    request: nextRequest,
                  )));
        } else {
          Request oldRequestId = new Request(asset.id);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                  new HandOverAsset(
                    asset: asset.value.currentAsset,
                    request: oldRequestId,
                  )));
        }
      } else {
        print("response !200");
        var errorJson = json.decode(response.body);
        showAlert(context,
            title: new Icon(
              Icons.error,
              color: Colors.red,
            ),
            content: new Text(errorJson["message"]),
            cupertinoActions: <Widget>[
              new CupertinoDialogAction(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
                isDefaultAction: true,
              ),
            ],
            materialActions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('OK'),
              )
            ]);
      }
    } catch (e) {
      print("inside catch");
      print("Exception: $e");
      showAlert(context,
          title: new Icon(
            Icons.error,
            color: Colors.red,
          ),
          content: new Text("Error Occured"),
          cupertinoActions: <Widget>[
            new CupertinoDialogAction(
              child: new Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
              isDefaultAction: true,
            ),
          ],
          materialActions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text('OK'),
            )
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 6.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
      child: new Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: new Row(children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 4.0, right: 12.0),
            child: new CircleAvatar(
              minRadius: 36.0,
              child: new Text(
                asset.value.currentAsset.name[0],
                style: new TextStyle(color: Colors.white, fontSize: 32.0),
              ),
              backgroundColor: Colors.deepOrange,
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        asset.value.currentAsset.name,
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    new PopupMenuButton(
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        new PopupMenuItem(
                          child: new Text("Handover"),
                          value: 0,
                          enabled: true,
                        ),
                      ],
                      icon: new Icon(Icons.more_vert),
                      onSelected: (value) {
                        _popupMenuAction(value, context);
                      },
                      elevation: 50.0,
                      onCanceled: () {
                        print("Cancelled");
                      },
                    )
                  ],
                ),
                new Padding(padding: const EdgeInsets.only(top: 8.0)),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Text('Category - ',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                )),
                            new Text(" Mobile",
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        new Padding(padding: const EdgeInsets.only(top: 2.0)),
                        new Row(
                          children: <Widget>[
                            new Text('Return time -',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                )),
                            new Text(" ${getTime(asset.value.end_timing)}",
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: 0 == 0 ? Colors.red : Colors.green,
                                )),
                          ],
                        ),
                        new Padding(padding: const EdgeInsets.only(top: 2.0)),
                        new Row(
                          children: <Widget>[
                            new Text('Retrun date - ',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                )),
                            new Text(" ${getDate(asset.value.end_timing)}",
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        new Padding(padding: const EdgeInsets.only(top: 16.0)),
                      ],
                    ),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    )
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

//new Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//new Row(
//children: <Widget>[
//new Text(""),
//new Text(""),
//],
//),
//new Padding(
//padding: const EdgeInsets.only(top: 4.0)),
//new Row(
//children: <Widget>[
//new Text('Retrun date - ',
//style: new TextStyle(
//fontSize: 12.0,
//)),
//new Text(
//new DateFormat.yMMMd()
//.format(new DateTime.now()),
//style: new TextStyle(
//fontSize: 12.0,
//color: Colors.green,
//fontWeight: FontWeight.w400)),
//],
//)
//],
//),

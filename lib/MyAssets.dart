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

  Future getAssetHistory() async {
    try {
      var response = await http.get(myAssetsAPI, headers: {
        "Authorization": authorizationToken
      }).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        print(body);
        var assetHistoryJson = body;
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
        showOkAlert(context, errorJson["message"], true);
      }
    } catch (e) {
      print("inside catch");
      showOkAlert(context, "Connection time-out", true);
    }
  }

  @override
  void initState() {
    super.initState();
    getAssetHistory();
  }

  Widget child;
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
    return listOfRequests.length > 0
        ? getMyAssetList()
        : getNoDataView("No Asset Found");
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
        showOkAlert(context, errorJson["message"], true);
      }
    } catch (e) {
      print("inside catch");
      print("Exception: $e");
      showOkAlert(context, "Connection time-out", true);
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

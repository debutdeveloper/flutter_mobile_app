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
    print("getting asset history called");
    print("Getting Asset History");

    final assetHistoryURL = myAssetsAPI;

    setState(() {
      print("Show loader");
      _showLoader = false;
    });

    try {
      print("inside try");
      var response = await http.get(assetHistoryURL, headers: {
        "Authorization": widget.user.data.token
      }).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        print("response 200");
        setState(() {
          var assetHistoryJson = json.decode(response.body);
          requestList = assetHistoryJson["requests"];
          print('REQUESTLIST LENGTH :${requestList.length}');
          for (var requestJSON in requestList) {
            print("Request json: $requestJSON");
            Request request = new Request.fromJSON(requestJSON);
            listOfRequests.add(request);
          }
        });
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
                child: new Text('Ok'),
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
                child: new Text('Ok'),
              )
            ]);
      }
    }
    catch (e) {
      print("inside catch");
      showAlert(context,
          title: new Icon(
            Icons.error,
            color: Colors.red,
          ),
          content: new Text('Connection time-out'),
          cupertinoActions: <Widget>[
            new CupertinoDialogAction(
              child: new Text('Ok'),
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
              child: new Text('Ok'),
            )
          ]);
    }

    setState(() {
      print("Hide loader");
      _showLoader = true;
    });

  }

  @override
  void initState() {
    print("ASSET DETAILS INIT CALLED");
    super.initState();
    getAssetHistory();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int index) {
            return listOfRequests.isEmpty
                ? new Center(
              child: new Text(
                'No Assets found',
                style: new TextStyle(color: Colors.grey,
                    fontSize: 16.0
                ),
              ),
            )
                : new Column(
              children: <Widget>[
                new MyAssetCard(asset: listOfRequests[index],user: widget.user,),
                const SizedBox(
                  height: 12.0,
                ),
              ],
            );
          },
          itemCount: listOfRequests.isEmpty ? 1 : listOfRequests.length,
        ),
        new Offstage(child: new Container( color: new Color.fromRGBO(1, 1, 1 , 0.3), child: new Center(child: new CircularProgressIndicator(backgroundColor: Colors.transparent,),)),
          offstage: _showLoader,)
      ],
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
      "asset_id":asset.value.currentAsset.id,
    };


    try {
      print("request : $credentials");
      var response = await http.post(url, body: credentials, headers: {
        "Authorization": user.data.token
      }).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        print("response 200");
        var responseData = json.decode(response.body);
        Map<String, dynamic> req = responseData["request"];
        if (req.length > 0) {
          print("Next request response: $req");
          Request nextRequest = new Request.fromJSON(req);
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new HandOverAsset(
                asset: asset.value.currentAsset, request: nextRequest,)));
        } else {
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new HandOverAsset(
                  asset: asset.value.currentAsset)));
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
    }
    catch (e) {
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
        child: new Row(
          children: <Widget>[
          new Padding(
            padding:
                const EdgeInsets.only(left: 12.0, top: 4.0, right: 12.0),
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
                        new Padding(
                            padding: const EdgeInsets.only(top: 2.0)),
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
                        new Padding(
                            padding: const EdgeInsets.only(top: 2.0)),
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
                        new Padding(
                            padding: const EdgeInsets.only(top: 16.0)),
                      ],
                    ),
                    new Padding(
                      padding:
                          const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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

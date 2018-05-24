import 'dart:async';
import 'dart:convert';

import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/models/Request.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/request_asset.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AssetHistory extends StatefulWidget {
  final Asset asset;
  final CurrentUser user;
  const AssetHistory({@required this.asset, @required this.user});

  @override
  _AssetHistoryState createState() => new _AssetHistoryState();
}

class _AssetHistoryState extends State<AssetHistory> {
  List requestList;
  List<Request> listOfRequests = [];
  BuildContext _context;
  bool _showLoader = true;

  Future getAssetHistory() async {
    print("getting asset history called");
    print("Getting Asset History");

    final assetHistoryURL = assetDetailsAPI + widget.asset.key;

    setState(() {
      _showLoader = false;
    });

    try {
      var response = await http.get(assetHistoryURL, headers: {
        "Authorization": widget.user.data.token
      }).timeout(timeoutDuration);

      if (response.statusCode == 200) {
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
        var errorJson = json.decode(response.body);
        showAlert(_context,
            title: new Icon(
              Icons.error,
              color: Colors.red,
            ),
            content: new Text(errorJson["message"]),
            cupertinoActions: <Widget>[
              new CupertinoDialogAction(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.pop(_context);
                },
                isDefaultAction: true,
              ),
            ],
            materialActions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(_context);
                },
                child: new Text('Ok'),
              )
            ]);
      }
    } catch (e) {
      showAlert(_context,
          title: new Icon(
            Icons.error,
            color: Colors.red,
          ),
          content: new Text('Connection time-out'),
          cupertinoActions: <Widget>[
            new CupertinoDialogAction(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.pop(_context);
              },
              isDefaultAction: true,
            ),
          ],
          materialActions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(_context);
              },
              child: new Text('Ok'),
            )
          ]);
    }

    setState(() {
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
    print("Build callled");
    print(listOfRequests.length);
    _context = context;
    final _screenSize = MediaQuery.of(context).size;
    return new Stack(
      children: <Widget>[
        new Scaffold(
          appBar: new AppBar(
            title: new Text(
              "Asset History",
            ),
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
          body: new Container(
            height: _screenSize.height,
            width: _screenSize.width,
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Card(
                    elevation: 4.0,
                    child: new Container(
                      height: _screenSize.height * 0.60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: new ListView(children: getRequestDetails()),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Container(
                    decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(32.0),
                        gradient: new LinearGradient(colors: getColors())),
                    child: new ButtonTheme(
                      minWidth: _screenSize.width,
                      height: buttonHeight,
                      child: new FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new RequestAsset(
                                  user: widget.user, asset: widget.asset)));
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

  List<Widget> getRequestDetails() {
    List<Widget> requestDetailsList = [];
    if (listOfRequests.isEmpty) {
      requestDetailsList.add(new Center(
        child: new Text(
          'No history found',
          style: new TextStyle(color: Colors.grey),
        ),
      ));
    } else {
      for (var request in listOfRequests) {
        var username =
            '${request.value.user.first_name} ${request.value.user.last_name}';
        var requestDate = getDate(request.value.start_timing);
        var from = getTime(request.value.start_timing);
        var upto = getTime(request.value.end_timing);
        var requestData = new RequestData(
            status: request.value.status,
            details: '$username, $requestDate, $from-$upto');
        requestDetailsList.add(new RequestDetails(requestData));
      }
    }

    return requestDetailsList;
  }
}

class RequestDetails extends StatelessWidget {
  final RequestData _requestData;
  RequestDetails(this._requestData);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.only(top: 1.0, bottom: 1.0),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 40.0,
            width: 5.0,
            decoration: new BoxDecoration(
                color: _requestData.status == 0 ? Colors.red : Colors.green,
                borderRadius: new BorderRadius.circular(10.0)),
          ),
          new Expanded(
            child: new Container(
              margin: const EdgeInsets.only(left: 5.0),
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
              decoration: new BoxDecoration(
                  color: new Color.fromRGBO(226, 227, 228, 1.0),
                  borderRadius: new BorderRadius.circular(10.0)),
              child: new Text(
                _requestData.details,
                maxLines: 10,
                style: new TextStyle(fontSize: descriptionFontSize),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//
//class AssetHistory extends StatefulWidget {
//
//  final Asset asset;
//  final User user;
//  const AssetHistory({@required this.asset,@required this.user});
//
//  @override
//  _AssetHistoryState createState() => new _AssetHistoryState();
//}
//
//class _AssetHistoryState extends State<AssetHistory> {
//  List<AssetData> dataList = new List();
//
//  @override
//  void initState() {
//    fillList();
//    print("Device name : ${widget.asset.record.name}");
//    super.initState();
//  }
//
//  fillList() {
//    for (int i = 0; i < 50; i++) {
//      dataList.add(new AssetData(
//          "Hello Number $i", (i.isEven ? Colors.red : Colors.grey)));
//    }
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    final _screenSize = MediaQuery
//        .of(context)
//        .size;
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Asset History",),
//      ),
//      body: new Container(
//        height: _screenSize.height,
//        width: _screenSize.width,
//        color: Colors.white,
//        child: new Column(
//          children: <Widget>[
//            new Padding(
//              padding: const EdgeInsets.all(20.0),
//              child: new Card(
//                elevation: 4.0,
//                child: new Container(
//                  height: _screenSize.height * 0.60,
//                  padding: const EdgeInsets.symmetric(
//                      vertical: 10.0, horizontal: 30.0),
//                  child: new ListView(children: getAssetDetails()),
//                ),
//              ),
//            ),
//            new Padding(
//              padding: const EdgeInsets.all(16.0),
//              child: new Container(
//                decoration: new BoxDecoration(
//                    borderRadius: new BorderRadius.circular(32.0),
//                    gradient: new LinearGradient(colors: getColors())),
//                child: new ButtonTheme(
//                  minWidth: _screenSize.width,
//                  height: buttonHeight,
//                  child: new FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).push(new MaterialPageRoute(
//                          builder: (context) => new RequestAsset(user: widget.user,asset: widget.asset)));
//                    },
//                    shape: new StadiumBorder(),
//                    child: new Text(
//                      "REQUEST",
//                      style: new TextStyle(color: Colors.white, fontSize: 16.0),
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  List<AssetItem> getAssetDetails() {
//    List<AssetItem> assetsDetailsList = [];
//    for (var asset in dataList) {
//      assetsDetailsList.add(new AssetItem(asset));
//    }
//    return assetsDetailsList;
//  }
//}
//
//class AssetData {
//  String details;
//  MaterialColor color;
//
//  AssetData(this.details, this.color);
//}
//
//class AssetItem extends StatelessWidget {
//  final AssetData _data;
//
//  AssetItem(this._data);
//
//  @override
//  Widget build(BuildContext context) {
//    return new Container(
//      margin: const EdgeInsets.only(top: 1.0, bottom: 1.0),
//      child: new Row(
//        mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          new Container(
//            height: 40.0,
//            width: 5.0,
//            decoration: new BoxDecoration(
//                color: _data.color,
//                borderRadius: new BorderRadius.circular(10.0)),
//          ),
//          new Expanded(
//            child: new Container(
//              margin: const EdgeInsets.only(left: 5.0, right: 60.0),
//              padding: const EdgeInsets.only(
//                  left: 15.0, right: 15.0, top: 2.0, bottom: 2.0),
//              decoration: new BoxDecoration(
//                  color: Colors.grey,
//                  borderRadius: new BorderRadius.circular(10.0)),
//              child: new Text(
//                _data.details,
//                maxLines: 10,
//                style: const TextStyle(fontSize: 12.0),
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}

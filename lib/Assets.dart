import 'dart:async';
import 'dart:convert';

import 'package:debut_assets/AssetCard.dart';
import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Assets extends StatefulWidget {
  final CurrentUser user;
  const Assets({@required this.user});
  @override
  _CardViewState createState() => new _CardViewState();
}

class _CardViewState extends State<Assets> {

  bool _showLoader = true;
  List assetsList;
  List<Asset> listOfAssets = [];

  getAssetsList() async {
    print("GETASSETSLIST CALLED");
    print("Getting list");

    setState(() {
      _showLoader = false;
    });

    try {
      var response = await http.get(assetsAPI,
          headers: {"Authorization": widget.user.data.token}).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        var listData = json.decode(response.body);
        setState(() {
          assetsList = listData["assets"];
          print("Asset list : ${assetsList.length}");
          for (var assetJSON in assetsList) {
            print("Asset json: ${assetJSON}");

            Asset asset = new Asset.fromJSON(assetJSON);
            listOfAssets.add(asset);
          }
        });
      } else {
        showAlert(context,
          title: new Icon(Icons.error,color: Colors.red,),
          content: new Text("Assets not found!"),
          cupertinoActions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("OK"),
              isDefaultAction: true,
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
      }
    } catch (e) {
      showAlert(context,
        title: new Icon(Icons.error,color: Colors.red,),
        content: new Text("Connection time-out"),
        cupertinoActions: <Widget>[
          new CupertinoDialogAction(
            child: new Text("OK"),
            isDefaultAction: true,
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
    }

    setState(() {
      _showLoader = true;
    });

  }

  @override
  void initState() {
    print("ASSETS INIT CALLED");
    super.initState();
    this.getAssetsList();
  }

  @override
  Widget build(BuildContext context) {
    print("ASSETS BUILD CALLED");
    return new Stack(
      children: <Widget>[
        new Container(
            color: Colors.white,
            child: getListView()
        ),
        new Offstage(child: new Container( color: new Color.fromRGBO(1, 1, 1 , 0.3), child: new Center(child: new CircularProgressIndicator(backgroundColor: Colors.transparent,),)),
          offstage: _showLoader,)
      ],
    );
  }

  Widget getListView() {
    return new ListView.builder(

      padding: new EdgeInsets.all(8.0),
      itemBuilder: (buildContext, index) {
        return new Column(
          children: <Widget>[
            new AssetCard(
            asset: listOfAssets[index],
              user: widget.user,
            ),
            const SizedBox(height: 12.0,),
          ],
        );
      },
      itemCount: listOfAssets == null ? 0 : listOfAssets.length,
    );
  }
}

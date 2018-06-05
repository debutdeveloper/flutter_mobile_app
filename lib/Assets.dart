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
  BuildContext _context;
  List<Asset> listOfAssets = [];

  getAssetsList() async {
    print("GETASSETSLIST CALLED");

    setState(() {
      _showLoader = false;
    });

    try {
      var response = await http.get(assetsAPI, headers: {
        "Authorization": authorizationToken
      }).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        print(body);
        var listData = body;
        var assetsListJSON = listData["assets"];
        List<Asset> assetsList = [];
        print("Asset list : ${assetsListJSON.length}");
        for (var assetJSON in assetsListJSON) {
          Asset asset = new Asset.fromJSON(assetJSON);
          assetsList.add(asset);
        }
        listOfAssets.clear();
        setState(() {
          listOfAssets = assetsList;
        });
      } else {
        showOkAlert(_context, "Assets not found!", true);
      }
    } catch (e) {
      showOkAlert(_context, "Connection time-out", true);
    }

    setState(() {
      _showLoader = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getAssetsList();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return new Stack(
      children: <Widget>[
        new Container(
            color: Colors.black12,
            child: listOfAssets.length > 0
                ? getListView()
                : getNoDataView("No Asset Found")),
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
            new SizedBox(height: 12.0,)
          ],
        );
      },
      itemCount: listOfAssets == null ? 0 : listOfAssets.length,
    );
  }
}

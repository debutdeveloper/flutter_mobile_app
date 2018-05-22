import 'dart:async';
import 'dart:convert';

import 'package:debut_assets/AssetCard.dart';
import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Assets extends StatefulWidget {
  final User user;
  const Assets({@required this.user});
  @override
  _CardViewState createState() => new _CardViewState();
}

class _CardViewState extends State<Assets> {


  List assetsList;
  List<Asset> listOfAssets = [];

  Future<String> getAssetsList() async {
    print("Getting list");
    var response = await http.get("http://192.168.0.18:3001/asset",
        headers: {"Accept": "application/json"});
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
    }else{
      //TODO:-
    }
//    print(listOfAssets.length.toString());
    return "Success";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getAssetsList();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.white,
        child: getListView()
    );
  }

  Widget getListView() {
    return new ListView.builder(

      padding: new EdgeInsets.all(8.0),
      itemBuilder: (buildContext, index) {
        return new AssetCard(
          asset: listOfAssets[index],
          user: widget.user,
        );
      },
      itemCount: listOfAssets == null ? 0 : listOfAssets.length,
    );
  }
}

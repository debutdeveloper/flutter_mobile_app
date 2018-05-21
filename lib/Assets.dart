import 'dart:async';
import 'dart:convert';

import 'package:debut_assets/AssetCard.dart';
import 'package:debut_assets/models/Asset.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Assets extends StatefulWidget {
  @override
  _CardViewState createState() => new _CardViewState();
}

class _CardViewState extends State<Assets> {


  List assetsList;
  List<Asset> listOfAssets;

  Future<String> getAssetsList() async {
    print("Getting list");
    var response = await http.get("http://192.168.0.18:3000/asset",
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var listData = json.decode(response.body);
      setState(() {
        assetsList = listData["assets"];
        print("Asset llist : $assetsList");
        for (var assetJSON in assetsList) {
          print("Asset json: ${assetJSON.runtimeType}");
          Asset asset = new Asset.fromJSON(assetJSON);
          listOfAssets.add(asset);
        }
      });
    }
print(listOfAssets.length.toString());
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
        );
      },
      itemCount: listOfAssets == null ? 0 : listOfAssets.length,
    );
  }
}

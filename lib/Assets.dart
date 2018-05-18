import 'dart:async';
import 'dart:convert';

import 'package:debut_assets/Asset.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Assets extends StatefulWidget {
  @override
  _CardViewState createState() => new _CardViewState();
}

class _CardViewState extends State<Assets> {
  List assetsList;

  Future<String> getAssetsList() async {
    var response = await http.get("http://192.168.0.18:3000/asset",
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var listData = json.decode(response.body);
      setState(() {
        assetsList = listData["assets"];
      });
    }

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
      itemBuilder: (buildContext, index) {
        return new Asset(
          cardModel: assetsList[index]["Record"],
        );
      },
      itemCount: assetsList == null ? 0 : assetsList.length,

    );
  }
}

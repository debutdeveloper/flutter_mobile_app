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
  BuildContext _context;
  List<Asset> listOfAssets = [];

  // For searching purpose
  List<Asset> searchedListOfAssets = [];

  bool isSearching = false;

  getAssetsList() async {
    print("GETASSETSLIST CALLED");

    try {
      var response = await http.post(assetsAPI, headers: {
        "Authorization": authorizationToken
      }).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        var listData = body;
        var assetsListJSON = listData["assets"];
        List<Asset> assetsList = [];
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
  }

  @override
  void initState() {
    super.initState();

    getAssetsList();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return new Container(
        color: Colors.black12,
        child: listOfAssets.length > 0
            ? getListView()
            : getNoDataView("No Asset Found"));
  }

  Widget getListView() {
    return new ListView.builder(
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (buildContext, index) {
        return new Column(
          children: <Widget>[
            new AssetCard(
              asset: getListAsset(index),
              user: widget.user,
            ),
            new SizedBox(
              height: 12.0,
            )
          ],
        );
      },
      itemCount: getListCount(),
    );
  }

  getListCount() {
    if (isSearching) {
      return listOfAssets == null ? 0 : listOfAssets.length;
    } else {
      return searchedListOfAssets == null ? 0 : searchedListOfAssets.length;
    }
  }

  getListAsset(int index) {
    return isSearching ? searchedListOfAssets[index] : listOfAssets[index];
  }

  void searchAsset(String query) {
    searchedListOfAssets.clear();
    setState(() {
      listOfAssets.map((asset) {
        if (asset.record.name
            .toLowerCase()
            .trim()
            .contains(new RegExp(r'' + query.toLowerCase().trim() + ''))) {
          searchedListOfAssets.add(asset);
        }
      }).toList();
    });
  }
}

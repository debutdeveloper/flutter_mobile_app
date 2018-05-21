import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/request_asset.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/material.dart';

class AssetHistory extends StatefulWidget {

  final Asset asset;

  const AssetHistory(this.asset);

  @override
  _State createState() => new _State();
}

class _State extends State<AssetHistory> {
  List<AssetData> dataList = new List();

  @override
  void initState() {
    fillList();
    print("Device name : ${widget.asset.record.name}");
    super.initState();
  }

  fillList() {
    for (int i = 0; i < 50; i++) {
      dataList.add(new AssetData(
          "Hello Number $i", (i.isEven ? Colors.red : Colors.grey)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery
        .of(context)
        .size;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Asset History",),
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
                      vertical: 10.0, horizontal: 30.0),
                  child: new ListView(children: getAssetDetails()),
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
                          builder: (context) => new RequestAsset()));
                    },
                    shape: new StadiumBorder(),
                    child: new Text(
                      "REQUEST",
                      style: new TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AssetItem> getAssetDetails() {
    List<AssetItem> assetsDetailsList = [];
    for (var asset in dataList) {
      assetsDetailsList.add(new AssetItem(asset));
    }
    return assetsDetailsList;
  }
}

class AssetData {
  String details;
  MaterialColor color;

  AssetData(this.details, this.color);
}

class AssetItem extends StatelessWidget {
  final AssetData _data;

  AssetItem(this._data);

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
                color: _data.color,
                borderRadius: new BorderRadius.circular(10.0)),
          ),
          new Expanded(
            child: new Container(
              margin: const EdgeInsets.only(left: 5.0, right: 60.0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 2.0, bottom: 2.0),
              decoration: new BoxDecoration(
                  color: Colors.grey,
                  borderRadius: new BorderRadius.circular(10.0)),
              child: new Text(
                _data.details,
                maxLines: 10,
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}

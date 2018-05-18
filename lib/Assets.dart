import 'package:debut_assets/Asset.dart';
import 'package:flutter/material.dart';


class Assets extends StatefulWidget {
  @override
  _CardViewState createState() => new _CardViewState();
}

class _CardViewState extends State<Assets> {
  String iconImage =
      "http://68.media.tumblr.com/f7e2e01128ca8eb2b9436aa3eb2a0a33/tumblr_ogwlnpSpcU1sikc68o1_1280.png";

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: new ListView(
          padding: new EdgeInsets.all(6.0),
          children: getMyAssets(12)
      ),
    );
  }


  List<Widget> getMyAssets(int count) {
    List<Widget> notificationCards = [];
    for (int i = 0; i < count; i++) {
      var assetModel = new AssetModel(
          allotedTo: "Narinder Singh",
          available: "$i May, 2018",
          status: "Alloted",
          icon: iconImage,
          category: "Iphone",
          modelName: "Iphone $i -64 GB");

      notificationCards.add(new Asset(cardModel: assetModel,));
    }
    return notificationCards;
  }

}

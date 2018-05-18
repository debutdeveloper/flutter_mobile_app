import 'package:flutter/material.dart';

class MyAssets extends StatefulWidget {
  @override
  _CardViewState createState() => new _CardViewState();
}

class _CardViewState extends State<MyAssets> {
  String iconImage =
      "http://68.media.tumblr.com/f7e2e01128ca8eb2b9436aa3eb2a0a33/tumblr_ogwlnpSpcU1sikc68o1_1280.png";

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new ListView(
          padding: new EdgeInsets.all(8.0),
          children: []
      ),
    );
  }


}

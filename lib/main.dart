import 'package:debut_assets/assetlogin.dart';
import 'package:debut_assets/handOverDevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Debut Assets',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Login(),
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => new _DemoState();
}

class _DemoState extends State<Demo> {

  _popupMenuAction(int value) {
    switch (value) {
      case 0:
        Navigator.push(context, new MaterialPageRoute(builder: (context)=>new HandOverAsset()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Demo"),
      ),
      body: new ListView(
        children: <Widget>[
          new Card(
            elevation: 6.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
            child: new Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: new Row(children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 4.0, right: 12.0),
                  child: new CircleAvatar(
                    minRadius: 36.0,
                    child: new Text(
                      "I",
                      style: new TextStyle(color: Colors.white, fontSize: 32.0),
                    ),
                    backgroundColor: Colors.deepOrange,
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "Iphone X",
                              style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          new PopupMenuButton(
                            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              new PopupMenuItem(
                                child: new Text("Handover"),
                                value: 0,
                                enabled: true,
                              ),
                            ],
                            icon: new Icon(Icons.more_vert),
                            onSelected: (value) {
                              _popupMenuAction(value);
                            },
                            elevation: 50.0,
                            onCanceled: () {
                              print("Cancelled");
                            },
                          )
                        ],
                      ),
                      new Padding(padding: const EdgeInsets.only(top: 8.0)),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  new Text('Category - ',
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      )),
                                  new Text(" Mobile",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              new Padding(padding: const EdgeInsets.only(top: 2.0)),
                              new Row(
                                children: <Widget>[
                                  new Text('Return time -',
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      )),
                                  new Text("12:10 PM",
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: 0 == 0 ? Colors.red : Colors.green,
                                      )),
                                ],
                              ),
                              new Padding(padding: const EdgeInsets.only(top: 2.0)),
                              new Row(
                                children: <Widget>[
                                  new Text('Retrun date - ',
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                      )),
                                  new Text("01.01.2000",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              new Padding(
                                  padding: const EdgeInsets.only(top: 16.0)),
                            ],
                          ),
                          new Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ),
        ],
      )
    );
  }
}

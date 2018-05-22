import 'package:debut_assets/asset_details.dart';
import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/models/User.dart';
import 'package:flutter/material.dart';


class AssetCard extends StatelessWidget {
//  final Map cardModel;
  final Asset asset;
  final CurrentUser user;

  AssetCard({@required this.asset,@required this.user});

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 8.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
      child:
      new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
          Widget>[
        new Padding(padding: const EdgeInsets.all(8.0)),
        new Row(children: <Widget>[
          new Padding(padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0)),
          new CircleAvatar(
            minRadius: 36.0,
            child: new Text(
              asset.record.name[0],
              style: new TextStyle(color: Colors.white, fontSize: 32.0),
            ),
            backgroundColor: Colors.deepOrange,
          ),
          new Padding(padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0)),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  asset.record.name,
                  style: new TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                new Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0)),
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
                            new Text(asset.record.category.name,
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        new Padding(
                            padding:
                            const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0)),
                        new Row(
                          children: <Widget>[
                            new Text('Status - ',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                )),
                            new Text(
                                asset.record.status == 0 ? "False" : "True",
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: asset.record.status == 0
                                      ? Colors.red
                                      : Colors.green,
                                )),
                          ],
                        )
                      ],
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Text('Alloted - ',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                )),
                            new Text("Admin",
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        new Padding(
                            padding:
                            const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0)),
                        new Row(
                          children: <Widget>[
                            new Text('Available - ',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                )),
                            new Text(asset.record.status.toString(),
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    color: asset.record.status == 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.w400)),
                          ],
                        )
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
        new Padding(padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0)),
        new ButtonTheme(
          height: 40.0,
          child: new RaisedButton(
            child: new Text(
              'VIEW DETAIS',
              style: new TextStyle(fontSize: 12.0),
            ),
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new AssetHistory(user: user,asset: asset,)));
            },
            textColor: Colors.white,
          ),
        )
      ]),
    );
  }
}

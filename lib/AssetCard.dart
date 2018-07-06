import 'package:debut_assets/asset_details.dart';
import 'package:debut_assets/models/Asset.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/material.dart';

class AssetCard extends StatelessWidget {
//  final Map cardModel;
  final Asset asset;
  final CurrentUser user;

  AssetCard({@required this.asset, @required this.user});

  Widget get spacer {
    return const SizedBox(
      height: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 6.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
      child:
      new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
          Widget>[
        spacer,
        new Row(children: <Widget>[
          new Padding(padding: const EdgeInsets.only(left: 12.0)),
          new CircleAvatar(
            minRadius: 36.0,
            child: new Text(
              asset.record.name[0],
              style: new TextStyle(color: Colors.white, fontSize: 32.0),
            ),
            backgroundColor: Colors.deepOrange,
          ),
          new Padding(padding: const EdgeInsets.only(left: 12.0)),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  asset.record.name,
                  style: new TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
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
                                  fontSize: descriptionFontSize,
                                )),
                            new Container(
                              width: 80.0,
                              child: new Text(asset.record.category.name,
                                  style: new TextStyle(
                                      fontSize: descriptionFontSize,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        new Padding(padding: const EdgeInsets.only(top: 4.0)),
                        new Row(
                          children: <Widget>[
                            new Text('Status - ',
                                style: new TextStyle(
                                  fontSize: descriptionFontSize,
                                )),
                            new Text(
                                asset.record.status == 0 ? "False" : "True",
                                style: new TextStyle(
                                  fontSize: descriptionFontSize,
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
                                  fontSize: descriptionFontSize,
                                )),
                            new Text("Admin",
                                style: new TextStyle(
                                    fontSize: descriptionFontSize,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        new Padding(padding: const EdgeInsets.only(top: 4.0)),
                        new Row(
                          children: <Widget>[
                            new Text('Available - ',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                )),
                            new Text(asset.record.status.toString(),
                                style: new TextStyle(
                                    fontSize: descriptionFontSize,
                                    color: asset.record.status == 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.bold)),
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
        spacer,
        new ButtonTheme(
          height: 40.0,
          child: new RaisedButton(
            child: new Text(
              'VIEW DETAILS',
              style: new TextStyle(fontSize: buttonTitleFontSize),
            ),
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) =>
                  new AssetHistory(
                    user: user,
                    asset: asset,
                  )));
            },
            textColor: Colors.white,
          ),
        )
      ]),
    );
  }
}

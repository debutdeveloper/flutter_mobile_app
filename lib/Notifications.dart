import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => new _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Widget> _notificationCard(int count) {
    List<Widget> notificationCards = [];
    for (int i = 0; i < count; i++)
      notificationCards.add(new NotificationCard());
    return notificationCards;
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new ListView(
        padding: new EdgeInsets.all(8.0),
        children: _notificationCard(12),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String _notificationTitle = "NEQUE PORRO QUISQUAM ESTQUI";
  final String _notificationMessage =
      "Lorem ipsum dolor sit amet,consectetur adipiscing elit, sed do eiusmod tempor incididunt ut "
      "ip ex ea commodo consequat. Duis aute iruredolor in reprehenderit"
      " in voluptate velit esse cillum dolore eu fugiatnulla.";

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery
        .of(context)
        .size;
    return new Card(
      elevation: 4.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(6.0))),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.all(12.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _notificationTitle,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Padding(padding: new EdgeInsets.only(top: 8.0)),
                new Text(
                  _notificationMessage,
                  style: new TextStyle(
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new ButtonTheme(
                minWidth: _screenSize.width / 2 - 12,
                child: new FlatButton(
                  onPressed: () {},
                  child: new Text(
                    "ACCEPT",
                    style: new TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  shape: new RoundedRectangleBorder(),
                ),
              ),
              new ButtonTheme(
                minWidth: _screenSize.width / 2 - 12,
                child: new FlatButton(
                  onPressed: () {},
                  child: new Text(
                    "CANCEL",
                    style: new TextStyle(color: Colors.black),
                  ),
                  color: Colors.black12,
                  shape: new RoundedRectangleBorder(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

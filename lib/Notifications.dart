import 'dart:convert';

import 'package:debut_assets/models/notification.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => new _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<AssetNotification> notifications = [];

  _getNotification() async {
    try {
      print(authorizationToken);
      var response = await http.get(notificationAPI, headers: {
        "Authorization": authorizationToken
      }).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        var listData = json.decode(response.body);
        var notificationListJson = listData["docs"];
        if (notificationListJson.isNotEmpty) {
          List<AssetNotification> notificationList = [];
          for (var notification in notificationListJson) {
            print(notification);
            AssetNotification assetNotification =
                new AssetNotification.fromJSON(notification);
            notificationList.add(assetNotification);
          }
          print(notificationList.length);
          notifications.clear();
          setState(() {
            notifications = notificationList;
          });
        }
      } else {
        showOkAlert(context, "There is no notifiaction!", true);
      }
    } catch (e) {
      showOkAlert(context, "Connection time-out", true);
    }
  }

  @override
  void initState() {
    _getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        color: Colors.black12,
        child: notifications.length > 0
            ? new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            itemBuilder: (BuildContext context, int index) {
              return new Column(
                children: <Widget>[
                  new NotificationCard(notifications[index], this),
                  new SizedBox(
                    height: 12.0,
                  )
                ],
              );
            },
            itemCount: notifications.length)
            : getNoDataView("No Notifications"));
  }
}

class NotificationCard extends StatelessWidget {
  final AssetNotification notification;
  final _NotificationsState parentWidget;

  NotificationCard(this.notification, this.parentWidget);

  void acceptHandover() {
    sendHandoverAction(0);
  }

  void rejectHandover() {
    sendHandoverAction(1);
  }

  sendHandoverAction(int action) async {
    final request = {
      "action": action,
      "request_id": notification.requestId,
      "old_request_id": notification.oldRequestId,
      "req_type": 0,
      "asset_id": notification.asset.id,
      "notification_id": notification.id,
    };

    try {
      print(json.encode(request));
      print(authorizationToken);
      var response = await http.put(handoverActionAPI,
          body: json.encode(request),
          headers: {
            "Authorization": authorizationToken,
            "Content-Type": "application/json"
          }).timeout(timeoutDuration);
      print(response.body);
      if (response.statusCode == 200) {
        defaultTargetPlatform == TargetPlatform.iOS
            ? showDialog(
            context: parentWidget.context,
            builder: (context) {
              return new CupertinoAlertDialog(
                title: new Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                content: new Text("Success"),
                actions: <Widget>[
                  new CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text(
                      "OK",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            })
            : showDialog(
            context: parentWidget.context,
            builder: (context) {
              return new AlertDialog(
                title: new Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                content: new Text("Success"),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("OK"),
                  )
                ],
              );
            });

        parentWidget._getNotification();
      } else {
        var errorJson = json.decode(response.body);
        showOkAlert(parentWidget.context, errorJson["message"], true);
      }
    } catch (e) {
      print(e);
      showOkAlert(parentWidget.context, "Error", true);
    }
  }

  String getPriority(int value) {
    switch (value) {
      case 0:
        return "Low";
      case 1:
        return "Medium";
      case 2:
        return "High";

      default:
        return "No priority";
    }
  }

  getPriorityColor(int value) {
    switch (value) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.red;

      default:
        return Colors.black;
    }
  }

  getContent(AssetNotification asset) {
    int action = asset.action;
    int type = asset.type;

    if (type == 2 && action == 4) {
      asset.description = "Your request for this device has been Approved";
    } else if (type == 2 && action == 5) {
      asset.description = "Your request for this device has been Rejected";
    } else if (type == 1 && action == 1) {
      asset.description = "You accepted the handover";
    } else if (type == 1 && action == 2) {
      asset.description = "You reject the handover";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    getContent(notification);


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
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(notification.asset.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    new Text(
                      'Starts at: ' +
                          getDateForNotifications(notification.startTiming),
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),

                new Text(
                  notification.description,
                  maxLines: 2,
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text('Priority: ' + getPriority(notification.priority),
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            color: getPriorityColor(notification.priority))),
                    new Text(
                      'Sender: ${notification.sender.firstName}',
                      style: new TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13.0,
                          color: Colors.blueGrey),
                    ),
                  ],
                )
              ],
            ),
          ),
          new Offstage(
            offstage: !(notification.action == 0 && notification.type == 1),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new ButtonTheme(
                  minWidth: _screenSize.width / 2 - 12,
                  child: new FlatButton(
                    onPressed: acceptHandover,
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
                    onPressed: rejectHandover,
                    child: new Text(
                      "REJECT",
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: Colors.black12,
                    shape: new RoundedRectangleBorder(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

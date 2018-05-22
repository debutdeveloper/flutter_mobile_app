import 'dart:async';

import 'package:debut_assets/Assets.dart';
import 'package:debut_assets/MyAssets.dart';
import 'package:debut_assets/Notifications.dart';
import 'package:debut_assets/models/User.dart';
import 'package:debut_assets/reset_password.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/material.dart';
import 'assetlogin.dart';

class Dashboard extends StatefulWidget {
  final CurrentUser user;
  Dashboard(this.user);
  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with TickerProviderStateMixin {
  TabController tabController;

  String _allAssets = "All Assets";
  String _MyAssets = "My Assets";
  String _Notification = "Notification";

  String _appTitle = 'ALL ASSETS';
  int _tabIndex = 0;

  _getAppTitle() {
    setState(() {
      switch (_tabIndex) {
        case 0:
          _appTitle = _allAssets;
          break;
        case 1:
          _appTitle = _MyAssets;
          break;
        case 2:
          _appTitle = _Notification;
          break;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        int index = tabController.index;
        print(index);
        _tabIndex = index;
        _getAppTitle();
      }
    });


    print(widget.user.data.first_name);
//    _askedToLead();
  }

  Future<Null> _askedToLead() async {
    await showDialog(
        context: context,
        child: new SimpleDialog(
          title: const Text('Alert'),
          children: <Widget>[
            new Text(
              "Welcome ${widget.user.data.first_name} to Debut Assets",
              style: new TextStyle(fontSize: 24.0, color: Colors.teal),
            ),
            new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_appTitle),
        flexibleSpace: new Container(
          child: getDecorationBox(),
        ),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: new BoxDecoration(
                gradient: getGradient()
              ),
              accountName: new Text(widget.user.data.first_name + " " + widget.user.data.last_name),
              accountEmail: new Text(widget.user.data.email),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: new Color.fromRGBO(170, 210, 234, 1.0),
                child: new Text(widget.user.data.first_name[0],
                  style: new TextStyle(
                    fontSize: 40.0,
                    color: new Color.fromRGBO(33, 96, 232, 1.0)
                  ),
                ),
              ),
            ),
            new InkWell(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (
                        context) => new ResetPasswordScreen(user: widget.user,)));
              },
              child: new ListTile(
                leading: new Icon(Icons.change_history),
                title: new Text("Change password",
                  style: new TextStyle(
                    fontSize: 16.0
                  ),
                ),
              ),
            ),
            new Divider(),
            new InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                    builder: (context) => new Login()
                ),
                      (Route<dynamic> newRoute)=>false,
                );
              },
              child: new ListTile(
                leading: new Icon(Icons.power_settings_new),
                title: new Text("Logout",
                  style: new TextStyle(
                      fontSize: 16.0
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: new TabBar(
        key: new PageStorageKey("assets"),
        labelStyle: new TextStyle(fontSize: 12.0, color: Colors.white),
        unselectedLabelColor: Colors.black,
        indicator: new BoxDecoration(
          gradient: getGradient(),
        ),
        tabs: <Widget>[
          new Tab(
            icon: new Icon(Icons.devices),
            text: _allAssets,
          ),
          new Tab(
            icon: new Icon(Icons.folder),
            text: _MyAssets,
          ),
          new Tab(
            icon: new Icon(Icons.notifications),
            text: _Notification,
          ),
        ],
        controller: tabController,
      ),
      body: new TabBarView(
        children: [
          new Assets(user: widget.user),
          new MyAssets(),
          new Notifications(),
        ],
        controller: tabController,
      ),
    );
  }
}

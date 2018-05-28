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
  final PageStorageKey _tabBarKey = new PageStorageKey("assets");

  String _allAssets = "All Assets";
  String _myAssets = "My Assets";
  String _notifications = "Notifications";

  String _appTitle = 'ALL ASSETS';
  int _tabIndex = 0;

  _getAppTitle() {
    setState(() {
      switch (_tabIndex) {
        case 0:
          _appTitle = _allAssets;
          break;
        case 1:
          _appTitle = _myAssets;
          break;
        case 2:
          _appTitle = _notifications;
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
                leading: new Icon(Icons.lock_outline),
                title: new Text("Reset password",
                  style: new TextStyle(
                    fontSize: buttonTitleFontSize
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
                      fontSize: buttonTitleFontSize
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: new TabBar(
        //key: _tabBarKey,
        labelStyle: new TextStyle(fontSize: descriptionFontSize, color: Colors.white),
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
            icon: new Icon(Icons.list),
            text: _myAssets,
          ),
          new Tab(
            icon: new Icon(Icons.notification_important),
            text: _notifications,
          ),
        ],
        controller: tabController,
      ),
      body: new TabBarView(
        //key: _tabBarKey,
        physics: new NeverScrollableScrollPhysics(),
        children: [
          new Assets(user: widget.user),
          new MyAssets(widget.user),
          new Notifications()
        ],
        controller: tabController,
      ),
    );
  }
}

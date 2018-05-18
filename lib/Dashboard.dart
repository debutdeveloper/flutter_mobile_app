import 'package:debut_assets/Assets.dart';
import 'package:debut_assets/MyAssets.dart';
import 'package:debut_assets/Notifications.dart';
import 'package:debut_assets/models/LoginResponse.dart';
import 'package:debut_assets/utils.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {

  final LoginResponse loginResponse;

  Dashboard(this.loginResponse);

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
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
        automaticallyImplyLeading: false,
        title: new Text(_appTitle),
        flexibleSpace: new Container(
          child: getDecorationBox(),
        ),
      ),
      bottomNavigationBar: new TabBar(


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
        physics: new NeverScrollableScrollPhysics(),

        children: [
          new Assets(),
          new MyAssets(),
          new Notifications(),
        ],
        controller: tabController,
      ),
    );
  }
}

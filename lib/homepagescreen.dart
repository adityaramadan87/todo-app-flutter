import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learnflutter/fragment/fragment_todo.dart';
import 'package:learnflutter/fragment/fragment_about.dart';
import 'package:learnflutter/fragment/fragment_post.dart';
import 'package:learnflutter/loginscreen.dart';
import 'package:learnflutter/data/appdata.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePageScreen  extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("To Do", Icons.verified_user),
    new DrawerItem("About", Icons.info)
  ];
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

 
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String formatDate = DateFormat('kk:mm:ss \n EEE d MMM').format(date);

    return Scaffold(
      appBar: new AppBar(
        title: new Text("HomePage"),
        backgroundColor: Colors.redAccent,
      ),
      body: new Container(
        alignment: Alignment.center,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Halo!\n" + appData.text.toString(),
              style: new TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(),
            new Text(
              formatDate.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,),
            ),
          ],
        ),
    ),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("Hi! :)", style: new TextStyle(fontSize: 24.0,color: Colors.white)),
            decoration: new BoxDecoration(
              color: Colors.redAccent
            ),
          ),
          ListTile(
            title: Text("ToDo"),
            leading: Icon(Icons.verified_user),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new FragmentTodo()));
            },
          ),
          ListTile(
            title: Text("About"),
            leading: Icon(Icons.info),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new FragmentAbout()));
            },
          ),
          ListTile(
            title: Text("Post"),
            leading: Icon(Icons.local_post_office),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new FragmentPost()));
            },
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                builder: (BuildContext context) => new LoginScreen()), 
                (Route<dynamic> route) => false);
            },
          )
        ],
      ),
    ),
    );
  }
}
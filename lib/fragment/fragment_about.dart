import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

class FragmentAbout extends StatefulWidget {
  @override
  _FragmentAboutState createState() => _FragmentAboutState();
}

class _FragmentAboutState extends State<FragmentAbout> {

  String _platformVersion = 'unknown';
  String _projectVersion = '';
  String _projectCode = '';
  String _projectAppID = '';
  String _projectName = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
      }
    void initPlatformState() async {
      String platformVersion;
      try {
        platformVersion = await GetVersion.platformVersion;
      }on PlatformException {
        platformVersion = 'fail to get version';
      }
      String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        projectVersion = await GetVersion.projectVersion;
      } on PlatformException {
        projectVersion = 'Failed to get project version.';
      }

      String projectCode;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        projectCode = await GetVersion.projectCode;
      } on PlatformException {
        projectCode = 'Failed to get build number.';
      }

      String projectAppID;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        projectAppID = await GetVersion.appID;
      } on PlatformException {
        projectAppID = 'Failed to get app ID.';
      }
      
      String projectName;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        projectName = await GetVersion.appName;
      } on PlatformException {
        projectName = 'Failed to get app name.';
      }

      if (!mounted) return;

      setState(() {
       _platformVersion = platformVersion;
      _projectVersion = projectVersion;
      _projectCode = projectCode;
      _projectAppID = projectAppID;
      _projectName = projectName; 
      });

    }
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text("About"),
          backgroundColor: Colors.redAccent),
          body:  new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Container(
                  height: 10.0,
                ),
                new ListTile(
                  leading: new Icon(Icons.sort_by_alpha, color: Colors.redAccent,),
                  title: const Text("name app"),
                  subtitle: new Text(_projectName),
                ),
                new Divider(
                  height: 20.0,
                ),
                new ListTile(
                  leading: new Icon(Icons.directions_run, color: Colors.redAccent,),
                  title: const Text("Running"),
                  subtitle: new Text(_platformVersion),
                ),
                new Divider(
                  height: 20.0,
                ),
                new ListTile(
                  leading: new Icon(Icons.build, color: Colors.redAccent,),
                  title: const Text("Version Name"),
                  subtitle: new Text(_projectVersion),
                ),
                new Divider(
                  height: 20.0,
                ),
                new ListTile(
                  leading: new Icon(Icons.code, color: Colors.redAccent,),
                  title: const Text("Version Code"),
                  subtitle: new Text(_projectCode),
                ),
                new Divider(
                  height: 20.0,
                ),
                new ListTile(
                  leading: new Icon(Icons.apps, color: Colors.redAccent,),
                  title: const Text("App ID"),
                  subtitle: new Text(_projectAppID),
                ),
                new Divider(
                  height: 20.0,
                ),
                new ListTile(
                  leading: new Icon(Icons.developer_mode, color: Colors.redAccent,),
                  title: const Text("Developed By"),
                  subtitle: new Text("Rizky Adytia Ramadan"),
                ),
              ],
            ),
          )
          
        );
      }
    
      
}
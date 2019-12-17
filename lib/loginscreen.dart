import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:learnflutter/homepagescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learnflutter/data/appdata.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool checkValidate = false;

  SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    getValid();
  }

  @override
  Widget build(BuildContext context) {

    email.text = appData.text;

    return Scaffold(
      appBar: new AppBar(
        title: Text("Learn Flutter"),
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
      ),
      body: new SingleChildScrollView(
        child: _loginBody(),
        scrollDirection: Axis.vertical,
      ),
      
    );
  }
  
  Widget _loginBody() {
    return new Container(
      padding: EdgeInsets.only(right: 20.0, left: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new TextField(
            controller: email,
            decoration: InputDecoration(
              hintText: "E-mail",
              hintStyle: new TextStyle(color: Colors.grey.withOpacity(0.3))
            ),
            onChanged: (text) {
              appData.text = text;
            },
          ),
          new TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "password",
              hintStyle: new TextStyle(color: Colors.grey.withOpacity(0.3))
            ),
          ),
          new CheckboxListTile(
            value: checkValidate,
            onChanged: _onChange,
            title: new Text("Ingatkan Saya!"),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          new Container(
            color: Colors.redAccent,
            // decoration: new BoxDecoration(border: Border.all(color: Colors.redAccent)),
            child: new ListTile(
              title: new Text("Login", textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)
            ),
            onTap: _navigate,
            ),
          )
        ],
       ),
      );
     }
            
            
    _onChange(bool value) async {

      preferences = await SharedPreferences.getInstance();
    setState(() {
      checkValidate = value;
      preferences.setBool("check", checkValidate);
      preferences.setString("email", email.text);
      preferences.setString("password", password.text);
      preferences.commit();
      getValid();
      });
      
    }
      
    getValid() async {
      preferences = await SharedPreferences.getInstance();
      setState(() {
       checkValidate = preferences.getBool("check");
       if (checkValidate != null){
         if (checkValidate) {
           email.text = preferences.getString("email");
           password.text = preferences.getString("password");
         }else {
           email.clear();
           password.clear();
           preferences.clear();
         }
       }else{
         checkValidate = false;
       }
      });
    }
    

  _navigate() {
    if (email.text.length != 0 || password.text.length != 0) {
      Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
          builder: (BuildContext context) => new HomePageScreen()),
        (Route<dynamic> route) => false);
    }else {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: new CupertinoAlertDialog(
          content: new Text(
            "email dan password harus diisi",
            style: new TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: new Text("OK"),
            )
          ],
        )
      );
    }
  }
}
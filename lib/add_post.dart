import 'package:flutter/material.dart';
import 'package:learnflutter/api/api_service.dart';
import 'package:learnflutter/model/post_model.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
class AddPost extends StatefulWidget {

  Post post;
  AddPost({this.post});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldEmailValid;
  bool _isFieldAgeValid;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();

  @override
  void initState() {
    if (widget.post != null){
      _isFieldNameValid = true;
      _controllerName.text = widget.post.name;
      _isFieldEmailValid = true;
      _controllerEmail.text = widget.post.name;
      _isFieldAgeValid = true;
      _controllerAge.text = widget.post.age.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.redAccent,
      title: Text(
        widget.post == null ? "Add Post" : "Edit Post",
        style: TextStyle(color: Colors.white),
      ),),
      body: Wrap(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTextFieldName(),
            _buildTextFieldEmail(),
            _buildTextFieldAge(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RaisedButton(
                child : Text(
                  widget.post == null ?
                  "Submit".toUpperCase() : "Update".toUpperCase(),
                  style: TextStyle(color: Colors.white
                  ), 
                ),
                onPressed: () {
                  if (_isFieldNameValid == null || _isFieldEmailValid == null || _isFieldAgeValid == null
                  || !_isFieldNameValid || !_isFieldEmailValid || !_isFieldAgeValid) {
                    _scaffoldState.currentState.showSnackBar(SnackBar(
                      content : Text("tolong di isi semuanya"),
                    ));
                    return;
                  }
                  setState(() => _isLoading = true);
                  String name = _controllerName.text.toString();
                  String email = _controllerEmail.text.toString();
                  int age = int.parse(_controllerAge.text.toString());
                  Post post = Post(name: name, email:email, age: age);
                   
                    
                  if (widget.post == null){
                    _apiService.createPost(post).then((isSuccess){
                      setState(() => _isLoading = false);
                      if (isSuccess){
                      Navigator.pop(_scaffoldState.currentState.context);
                    }else{
                      _scaffoldState.currentState.showSnackBar(SnackBar(
                        content : Text("Submit data Fail")
                      ));
                    }
                  });
                  }else {
                    post.id = widget.post.id;
                    _apiService.updatePost(post).then((isSuccess) {
                      setState(() => _isLoading = false);
                       if (isSuccess){
                      Navigator.pop(_scaffoldState.currentState.context);
                      }else{
                      _scaffoldState.currentState.showSnackBar(SnackBar(
                        content : Text("Update data Fail")
                      ));
                    }
                    });
                  }
                },
                color: Colors.redAccent,
              ),
            ),
          ],
          ),          
        ),
        _isLoading ? Stack(children: <Widget>[
          Opacity(opacity: 0.3,
          child: ModalBarrier(
            dismissible: false,
            color: Colors.grey,
          ),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],): Container()       
      ],
      ),
    );
  }
  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Full name",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Email is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldAge() {
    return TextField(
      controller: _controllerAge,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Age",
        errorText: _isFieldAgeValid == null || _isFieldAgeValid
            ? null
            : "Age is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldAgeValid) {
          setState(() => _isFieldAgeValid = isFieldValid);
        }
      },
    );
  }
}
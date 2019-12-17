
import 'package:flutter/material.dart';
import 'package:learnflutter/database/database.dart';
import 'package:learnflutter/model/todo_model.dart';
import 'package:intl/intl.dart';

class AddTaskDialog extends StatefulWidget {

  final String appBarTitle;
  final Todo todo;
  AddTaskDialog(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState(){
    return _AddTaskDialogState(this.todo, this.appBarTitle);
  }
}

class _AddTaskDialogState extends State<AddTaskDialog> {

  static var _priorities = ['Important', 'Normal'];
  DatabaseHelper helper = DatabaseHelper();
  Todo todo;
  String appBarTitle;

  TextEditingController taskController = TextEditingController();
  _AddTaskDialogState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    
    TextStyle textStyle = Theme.of(context).textTheme.title;
    taskController.text = todo.task;
    
    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Colors.redAccent,
          leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: (){
            moveToLastScreen();
          },),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                      );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityAsString(todo.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                     debugPrint('User Selecte $valueSelectedByUser'); 
                     updatePriorityAsInt(valueSelectedByUser);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: taskController,
                  style: textStyle,
                  onChanged: (value){
                    debugPrint('some change');
                    updateTask();
                  },
                  decoration: InputDecoration(
                    labelText: 'Task',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child : Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: Text(
                          'save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: (){
                          setState(() {
                           debugPrint("save clicked");
                           _save(); 
                          });
                        },
                      ),
                    ),
                    Container(width: 5.0,),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: Text(
                         'Delete',
                         textScaleFactor: 1.5, 
                        ),
                        onPressed: (){
                          setState(() {
                           debugPrint("delete clicked"); 
                           _delete();
                          });
                        },
                        ),
                    )
                  ],)
              )
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  getPriorityAsString(int value) {
    String priority;
    switch(value){
      case 1:
      priority = _priorities[0];
      break;
      case 2:
      priority = _priorities[1];
      break;
    }
    return priority;
  }

  void updatePriorityAsInt(String value) {
    switch (value){
      case 'Important':
      todo.priority = 1;
      break;
      case 'Normal':
      todo.priority = 2;
      break;
    }
  }

  void updateTask() {
    todo.task = taskController.text;
  }

  void _save() async {
    moveToLastScreen();
    todo.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (todo.id != null){
      result = await helper.updateTask(todo);
    }else {
      result = await helper.insertTask(todo);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Task Saved');
    }else {
      _showAlertDialog('Status', 'problem saving task');
    }

  }

  void _delete() async {
    moveToLastScreen();

    if (todo.id == null){
      _showAlertDialog('status', 'no task deleted');
      return;
    }
    int result = await helper.deleteTask(todo.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Task Deleted');
    }else{
      _showAlertDialog('Status', 'Error while Delete Task');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}
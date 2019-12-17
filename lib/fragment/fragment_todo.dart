import 'package:flutter/material.dart';
import 'dart:async';
import 'package:learnflutter/database/database.dart';
import 'package:learnflutter/model/todo_model.dart';
import 'package:learnflutter/add_task.dart';

import 'package:sqflite/sqlite_api.dart';

class FragmentTodo extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _FragmentTodoState();
  }
}

class _FragmentTodoState extends State<FragmentTodo> {
  
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(title: Text("To Do"),
      backgroundColor: Colors.redAccent,),
      body: getTaskList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: (){
          debugPrint('Float clicked');
          navigateToDetail(Todo('', '', 2),'add task');
        },

        tooltip: 'Add Task',
        child: Icon(Icons.add_box),
      ),
    );
  }
  ListView getTaskList() {
    TextStyle taskStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Dismissible(
          key: UniqueKey(),
          background: Container(color : Colors.grey),
          onDismissed: (direction){
            _delete(context, todoList[position]);
          },
          child: Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.todoList[position].priority),
              child: getPriorityIcon(this.todoList[position].priority),
            ),
            title: Text(this.todoList[position].task, style: taskStyle,),
            subtitle: Text(this.todoList[position].date),
            onTap: (){
              debugPrint("list tapped");
              navigateToDetail(this.todoList[position],'Task');
            },
            onLongPress: (){
              navigateToDetail(this.todoList[position], 'Edit Task');
            },
          ),
        )
        );
      },
    ); 
  }

  void navigateToDetail(Todo todo, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTaskDialog(todo, title);
    }));
    if (result == true){
      updateListView();
    }
  }

  void _delete(BuildContext context, Todo todoList) async {
    int result = await databaseHelper.deleteTask(todoList.id);
    if(result != 0){
      _showSnackbar(context, 'task berhasil dihapus');
      updateListView();
    }
  }

  getPriorityColor(int priority) {
    switch(priority){
      case 1:
      return Colors.red;
      break;
      case 2:
      return Colors.yellow;
      break;
      default:
      return Colors.yellow;
    }
  }

  getPriorityIcon(int priority) {
    switch(priority){
      case 1:
      return Icon(Icons.play_arrow);
      break;
      case 2:
      return Icon(Icons.keyboard_arrow_right);
      default:
      return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _showSnackbar(BuildContext context, String s) {
    final snackBar = SnackBar(content: Text(s),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList){
        setState(() {
         this.todoList = todoList;
         this.count = todoList.length; 
        });
      });
    });
  }
}
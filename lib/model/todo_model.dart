class Todo {
  int _id;
  String _task;
  String _date;
  int _priority;

  Todo(this._task, this._date, this._priority);
  Todo.withId(this._id, this._task, this._date, this._priority);

  int get id => _id;
  
  String get task => _task;

  String get date => _date;

  int get priority => _priority;

  set task(String newTask){
    if (newTask.length <= 255){
      this._task = newTask;
    }
  }
  set date(String newDate){
    this._date = newDate;
  }
  set priority(int newPriority){
    if (newPriority >= 1 && newPriority <= 2){
      this._priority = newPriority;
    }
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null){
      map['id'] = _id;
    }
    map['task'] = _task;
    map['date'] = _date;
    map['priority'] = _priority;

    return map;
  }

  Todo.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._task = map['task'];
    this._date = map['date'];
    this._priority = map['priority'];
  }

}
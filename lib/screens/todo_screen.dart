import 'package:flutter/material.dart';
import 'package:to_do_app/model/todo.dart';
import 'package:to_do_app/util/dbhelper.dart';
import 'todo_detials.dart';
class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  var dbHelper = DbHelper();
  List<ToDo>? toDoList;

  var count = 0;

  void getData() {
    var dbFuture = dbHelper.initailzeDB();
    dbFuture.then((value) {
      final todoFuture = dbHelper.getToDo();
      todoFuture.then((value) {
        print("Number of Item $value");
        var listofData = List<ToDo>.empty(growable: true);
        count = value.length;
        print("count $count");

        for (int i = 0; i < count; i++) {
          listofData.add(ToDo.fromobject(value[i]));
          debugPrint(listofData[i].title);
        }

        setState(() {
          toDoList = listofData;
          count = count;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (toDoList == null) {
      toDoList = List<ToDo>.empty(growable: true);
      getData();
      print("bakr "+toDoList!.length.toString());
    }
    return Scaffold(
      body: toDoListItem(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigationToDetials(ToDo('',3,'',''));
        },
        backgroundColor: Colors.amber,
        tooltip: "Add new TODO",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView toDoListItem() {
    return ListView.builder(
        itemCount: count, itemBuilder: (BuildContext context, int postion) {
      return Card(
        elevation: 2,
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: getPriority(toDoList![postion].proiority),
            child: Text(toDoList![postion].id.toString()),
          ),
          title: Text(toDoList![postion].title),
          subtitle:Text(toDoList![postion].date) ,
          onTap: (){
            navigationToDetials(toDoList![postion]);
            debugPrint("Tap On :"+toDoList![postion].title);
          },
        ),
      );
    });
  }

  Color getPriority(int priority){
    switch(priority)
    {
      case 1 :
        return Colors.red;
        break;
      case 2 :
        return Colors.yellowAccent;
        break;
      case 3 :
        return Colors.green;
        break;
    }
    
    return Colors.black;
  }

  void navigationToDetials(ToDo todo) async
  {
    bool result =await Navigator.push(context, MaterialPageRoute(builder: (context)=>ToDoDetails(todo))) ;

    if(result==true)
      {
        getData();
      }

  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/model/todo.dart';
import 'package:to_do_app/util/dbhelper.dart';

var dbHelper = DbHelper();

final List<String> chooses = const <String>[
  "save  Todo & Back ",
  "Delete ",
  "Back To List"
];

const menuSave = "save  Todo & Back ";
const menuDelete = "Delete ";
const menuBack = "Back To List";

class ToDoDetails extends StatefulWidget {
  final ToDo toDo;

  ToDoDetails(this.toDo);

  @override
  _ToDoDetailsState createState() => _ToDoDetailsState(toDo);
}

class _ToDoDetailsState extends State<ToDoDetails> {
  final ToDo toDo;

  _ToDoDetailsState(this.toDo);

  final _priorites = ["High", "Medium", "Low"];
  var _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    descriptionController.text = toDo.description;
    titleController.text = toDo.title;
    TextStyle textStyle = Theme.of(context).textTheme.title!;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return chooses.map<PopupMenuItem<String>>((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
            onSelected: _select,
          ),
        ],
        title: Text(toDo.title),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: TextField(
              controller: titleController,
              style: textStyle,
              onChanged: (value) => updateTitle(),
              decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: descriptionController,
              style: textStyle,
              onChanged: (value) => updateDescrition(),
              decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          DropdownButton<String>(
            items: _priorites.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            style: textStyle,
            value: retriveProiorty(toDo.proiority),
            onChanged: (value) {
              updatePriority(value!);
            },
          )
        ],
      ),
    );
  }

  void _select(String select) {
    switch (select) {
      case menuSave:
        save();
        break;
      case menuDelete:
        delete();
        break;

      case menuBack:
        back();
        break;
    }
  }

  void save() {
     if (toDo.id > 0) {
      dbHelper.update(toDo);
    } else {
      toDo.date = DateTime.now().toString();
      dbHelper.insert(toDo);

    }

     back();

  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        toDo.proiority = 1;
        break;
      case "Medium":
        toDo.proiority = 2;
        break;
      case "Low":
        toDo.proiority = 3;
        break;
    }

    setState(() {
      _priority = value;
    });
  }

  String retriveProiorty(int proitory) {
    return _priorites[proitory - 1];
  }

  void updateTitle() {
    toDo.title = titleController.text;
  }

  void updateDescrition() {
    toDo.description = descriptionController.text;
  }

  void delete() async {
    if (toDo.id == 0) {
      return;
    } else {
      var result = await dbHelper.delete(toDo.id);
      if (result != 0) {
        AlertDialog alertDialog = AlertDialog(
          title: Text("Delte ToDo"),
          content: Text("Deleted Successfully"),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  back();
                },
                child: Text("Ok"))
          ],
        );
        showDialog(context: context, builder: (_) => alertDialog);
      }
    }
  }

  void back() {
    Navigator.pop(context, true);
  }
}

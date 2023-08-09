// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note});

  final Map<String, dynamic>? note;
  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  Map<String, dynamic>? note;

  var titleTEC = TextEditingController();
  var bodyTEC = TextEditingController();

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    note = widget.note;
    if (note != null) {
      isUpdate = true;
      titleTEC.text = note!["title"];
      bodyTEC.text = note!["body"];
    }

    titleTEC.addListener(() {
      save();
    });
    bodyTEC.addListener(() {
      save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }

  AppBar get _appBar => AppBar(
        title: const Text('New Note'),
        /*  actions: [
          IconButton(
            onPressed: () {
              save();
            },
            icon: Icon(Icons.save),
          ),
        ], */
      );

  Widget get _body {
    return Center(
      child: Column(
        children: [
          _titleTextField,
          _bodyTextField,
        ],
      ),
    );
  }

  Widget get _titleTextField {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: titleTEC,
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: "Title"),
      ),
    );
  }

  Widget get _bodyTextField {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: bodyTEC,
          // textAlignVertical: TextAlignVertical.top,
          // textAlign: TextAlign.start,
          maxLines: null, // 10,
          minLines: null, // 1,
          cursorColor: Colors.amber,
          expands: false,
          decoration: InputDecoration(
              border: InputBorder.none /* OutlineInputBorder() */,
              hintText: "Body"),
        ),
      ),
    );
  }

  save() async {
    var title = titleTEC.text;
    var body = bodyTEC.text;

    if (isUpdate) {
      //Update
      var noteTotUpdate = note!;

      var id = noteTotUpdate["id"] as int;

      SharedPreferences sharedPref = await SharedPreferences.getInstance();
      List<String> notes = sharedPref.getStringList('noteListJson') ?? [];

      List<Map<String, dynamic>> savedNotesList = [];

      for (var stringJson in notes) {
        var obj = jsonDecode(stringJson) as Map<String, dynamic>;
        savedNotesList.add(obj);
      }

      /* savedNotesList = [
        {"id": 12, "title": "Hello", "body": "TEXT TEST"}, //index 0
        {"id": 23, "title": "Hello", "body": "TEXT TEST"}, //index 1
        {"id": 34, "title": "Hello", "body": "TEXT TEST"}, //index 2
        {"id": 45, "title": "Hello", "body": "TEXT TEST"}, //index 3
        {"id": 56, "title": "Hello", "body": "TEXT TEST"}, //index 4
      ]; */

      int index = 0;

      // to Get the index of the Note
      for (var i = 0; i < savedNotesList.length; i++) {
        var listId = (savedNotesList[i]['id'] as int);
        if (listId == id) {
          index = i;
          break; //this is to exit the for loop
        }
      }

      savedNotesList[index]["title"] = title;
      savedNotesList[index]["body"] = body;

      /*  savedNotesList = [
        {"id": 12, "title": "Hello", "body": "TEXT TEST"},
        {"id": 23, "title": "Hello", "body": "TEXT TEST"},
        {"id": 34, "title": "new title", "body": "new new body"},
        {"id": 45, "title": "Hello", "body": "TEXT TEST"},
        {"id": 56, "title": "Hello", "body": "TEXT TEST"},
      ]; */

      List<String> stringList = [];

      for (var obj in savedNotesList) {
        var stringObg = jsonEncode(obj);
        stringList.add(stringObg);
      }

      sharedPref.setStringList("noteListJson", stringList);

      // Navigator.pop(context);
    } else {
      // Create
      Map<String, dynamic> noteMap = {
        "id": DateTime.now().millisecondsSinceEpoch, // 45465456465
        "title": title,
        "body": body,
      };
      // '{"id":2,"title":"my database Title","body":"Hello from DB"}'

      var jsonString = jsonEncode(noteMap);
      SharedPreferences sharedPref = await SharedPreferences.getInstance();

      var notes = sharedPref.getStringList('noteListJson') ?? [];

      notes.add(jsonString);

      sharedPref.setStringList("noteListJson", notes);

      print(notes);
      isUpdate = true;
      note = noteMap;
      // Navigator.pop(context);
    }
  }

  tests() async {
    // First step: make model
    Map<String, dynamic> map = {
      "id": 2,
      "title": "my database Title",
      "body": "Hello from DB",
    };

    // convert model to String json
    String jsonString = jsonEncode(map);

    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    sharedPref.setString("json_string", jsonString);

    /////////////////////////////////////////////////////
    /////////////////////////////////////////////////////
    /////////////////////////////////////////////////////
    /////////////////////////////////////////////////////
    /////////////////////////////////////////////////////

    var dbDataString = sharedPref.getString("json_string");

    if (dbDataString != null) {
      //Convert jsonString to JSON then cast to it's variable type
      var json = jsonDecode(dbDataString) as Map<String, dynamic>;

      // you can use the data
      var id = json["id"]; //1
      var title = json["title"]; // title1
      var body = json["body"];

      print("ID: $id");
      print("title: $title");
      print("body: $body");
    }
  }
}

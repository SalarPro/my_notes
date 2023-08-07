// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_notes/src/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.title, this.body});

  final String? title;
  final String? body;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  var titleTEC = TextEditingController();
  var bodyTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      titleTEC.text = widget.title ?? "";
      bodyTEC.text = widget.body ?? "";
    }
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
        actions: [
          IconButton(
            onPressed: () {
              save();
            },
            icon: Icon(Icons.save),
          ),
        ],
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
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          maxLines: null,
          cursorColor: Colors.amber,
          expands: true,
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
    Navigator.pop(context);
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

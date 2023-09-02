// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_notes/src/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note});

  final NoteModel? note;
  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  NoteModel? note;

  var titleTEC = TextEditingController();
  var bodyTEC = TextEditingController();

  bool isUpdate = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    note = widget.note;
    if (note != null) {
      isUpdate = true;
      titleTEC.text = note?.title ?? "";
      bodyTEC.text = note?.body ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Stack(
        children: [
          _body,
          if (isLoading)
            Positioned.fill(
                child: Container(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ))
        ],
      ),
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
    setState(() {
      isLoading = true;
    });

    var title = titleTEC.text;
    var body = bodyTEC.text;

    if (isUpdate) {
      note?.title = title;
      note?.body = body;
      await note?.update();
    } else {
      note = NoteModel(
        title: title,
        body: body,
      );
      await note!.create();
    }
    setState(() {
      isLoading = false;
    });

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

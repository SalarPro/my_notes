// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  var titleTEC = TextEditingController();
  var bodyTEC = TextEditingController();

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

    print("title: $title");
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("title", title);
    pref.setString("body", body);
    Navigator.pop(context);
  }
}

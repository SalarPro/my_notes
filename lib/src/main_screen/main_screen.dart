import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_notes/src/note_editor_screen/note_editor_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? databaseJsonString;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextStyle get titleTextStyle =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  TextStyle get bodyTextStyle =>
      TextStyle(fontSize: 14, color: Colors.grey.shade700);

  String titleText = "Title";
  String bodyText = "Body";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _body,
      floatingActionButton: _floatingActionButton,
    );
  }

  Widget get _floatingActionButton {
    return FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteEditorScreen()));

          loadData();
        },
        child: Icon(Icons.add));
  }

  AppBar get _appBar => AppBar(
        title: const Text('My Notes'),
      );

  Widget get _body {
    return Center(
      child: ListView(
        children: [
          cellView(),
        ],
      ),
    );
  }

  Widget cellView() {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteEditorScreen(
                      body: bodyText,
                      title: titleText,
                    )));
        loadData();
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(13),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                textAlign: TextAlign.start,
                style: titleTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 15),
              Text(
                bodyText,
                style: bodyTextStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadData() async {
    var sharedPref = await SharedPreferences.getInstance();
    var dbDataString = sharedPref.getString("json_string");

    if (dbDataString != null) {
      //Convert jsonString to JSON then cast to it's variable type
      var json = jsonDecode(dbDataString) as Map<String, dynamic>;

      // you can use the data
      var id = json["id"]; //1
      var title = json["title"]; // title1
      var body = json["body"];

      print("ID: $id");

      titleText = title;
      bodyText = body;
      setState(() {});
    }
  }
}

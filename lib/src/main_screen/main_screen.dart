import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_notes/src/note_editor_screen/note_editor_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String>? databaseJsonString;

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

  List<Map<String, dynamic>> myNotes = [];

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
          for (var note in myNotes)
            cellView(
              titleText: note['title'],
              bodyText: note['body'],
            )
        ],
      ),
    );
  }

  Widget cellView({String? titleText, String? bodyText}) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteEditorScreen(
                      title: titleText,
                      body: bodyText,
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
                titleText ?? "",
                textAlign: TextAlign.start,
                style: titleTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 15),
              Text(
                bodyText ?? "",
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

    var noetList = sharedPref.getStringList("noteListJson") ?? [];
    print("noetList: ${noetList.length}");

    myNotes.clear();
    // myNotes = [];
    for (var jsonString in noetList) {
      jsonString; //  '{"id": 123, "title": "alksdlaksd", "body": "asdasd"}'
      var json = jsonDecode(jsonString) as Map<String, dynamic>;
      myNotes.add(json);
    }
    setState(() {});
  }
}

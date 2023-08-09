// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

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
  TextStyle get idTextStyle =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.normal);

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
      floatingActionButton: myNotes.isEmpty ? null : _floatingActionButton,
    );
  }

  Widget get _floatingActionButton {
    return FloatingActionButton(
        onPressed: () async {
          createNewNote();
        },
        child: const Icon(Icons.add));
  }

  AppBar get _appBar => AppBar(
        title: const Text('My Notes'),
      );

  Widget get _body {
    if (myNotes.isEmpty)
      return GestureDetector(
        onTap: () {
          createNewNote();
        },
        child: Center(
          child: Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: BorderRadius.circular(13)),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Note App\nPLease type your FIRST note",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 2,
                      wordSpacing: 5,
                      height: 1.5,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    createNewNote();
                  },
                  child: Text("Create NOTE!"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shadowColor: Colors.red,
                    elevation: 10,
                  ),
                )
              ],
            )),
          ),
        ),
      );

    return Center(
      child: ListView(
        children: [
          for (var note in myNotes)
            cellView(
              note: note,
            ),
        ],
      ),
    );
  }

  Widget cellView({required Map<String, dynamic> note}) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteEditorScreen(
                      note: note,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note['title'] ?? "",
                textAlign: TextAlign.start,
                style: titleTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 15),
              Text(
                note["body"] ?? "",
                style: bodyTextStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "ID: ${note['id']}",
                  style: idTextStyle,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialogToDeleteNote(note);
                },
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
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

    //To remove old data from list variable
    myNotes.clear(); // -> []
    // myNotes = [1,2,3,1,2,3,4];

    for (var jsonString in noetList) {
      // jsonString;   '{"id": 123, "title": "alksdlaksd", "body": "asdasd"}'
      var json = jsonDecode(jsonString) as Map<String, dynamic>;
      myNotes.add(json);
    }
    setState(() {});
  }

  void showDialogToDeleteNote(Map<String, dynamic> note) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are sure you want to Delete"),
            content: Text("This note will be Delete!"),
            actions: [
              TextButton(
                onPressed: () {
                  deleteNote(note);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                ),
              ),
            ],
          );
        });
  }

  void deleteNote(Map<String, dynamic> note) async {
    //Update
    var noteTotUpdate = note;

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

    print("Before ${savedNotesList.length}");
    savedNotesList.removeAt(index);
    print("After ${savedNotesList.length}");

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

    loadData();
  }

  void createNewNote() async {
    print("before await");
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteEditorScreen()));
    print("after await");
    loadData();
    print("Screen SetState");
  }
}

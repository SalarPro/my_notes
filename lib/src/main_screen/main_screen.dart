// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:my_notes/src/models/note_model.dart';
import 'package:my_notes/src/note_editor_screen/note_editor_screen.dart';

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

  @override
  void initState() {
    super.initState();
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
          createNewNote();
        },
        child: const Icon(Icons.add));
  }

  AppBar get _appBar => AppBar(
        title: const Text('My Notes'),
      );

  Widget get _body {
    return StreamBuilder<List<NoteModel>>(
        stream: NoteModel.steamAll(),
        builder: (context, snapshot) {
          if (snapshot.data == null || (snapshot.data?.isEmpty ?? false)) {
            return emptyView;
          }

          var myNotes = snapshot.data!;

          return ListView(
            children: [
              for (var note in myNotes)
                cellView(
                  note: note,
                ),
            ],
          );
        });
  }

  get emptyView => GestureDetector(
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

  Widget cellView({required NoteModel note}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteEditorScreen(
                      note: note,
                    )));
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
                note.title ?? "",
                textAlign: TextAlign.start,
                style: titleTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 15),
              Text(
                note.body ?? "",
                style: bodyTextStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "ID: ${note.uid}",
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

  void showDialogToDeleteNote(NoteModel note) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are sure you want to Delete"),
            content: Text("This note will be Delete!"),
            actions: [
              TextButton(
                onPressed: () {
                  note.delete();
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

  void createNewNote() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => NoteEditorScreen()));
  }
}

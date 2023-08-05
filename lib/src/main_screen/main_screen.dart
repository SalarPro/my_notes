import 'package:flutter/material.dart';
import 'package:my_notes/src/note_editor_screen/note_editor_screen.dart';

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
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteEditorScreen()));
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
    return Padding(
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
              "Note Title",
              textAlign: TextAlign.start,
              style: titleTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 15),
            Text(
              mText,
              style: bodyTextStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}

String get mText =>
    "A notetakingc app developed by Apple Inc. It is provided on their iOS, iPadOS and macOS operating systems, fa";

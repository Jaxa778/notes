import 'package:flutter/material.dart';
import 'package:notes/controllers/notes_controller.dart';
import 'package:notes/views/widgets/manage_note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final notesController = NotesController();

  @override
  void initState() {
    super.initState();

    notesController.getNotes().then((result) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.filter_list_sharp),
        ),
        centerTitle: true,
        title: Text("Notes"),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return ManageNoteDialog();
                },
              );

              if (result == true) {
                setState(() {});
              }
            },
            icon: Icon(Icons.add_alert_outlined),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: notesController.notes.length,
        itemBuilder: (context, index) {
          final note = notesController.notes[index];
          return ListTile(
            title: Text(note.remainder),
            subtitle: Text(note.date.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) {
                        return ManageNoteDialog(oldNote: note);
                      },
                    );

                    if (result == true) {
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 20);
        },
      ),
    );
  }
}

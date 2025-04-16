import 'package:flutter/material.dart';
import 'package:notes/controllers/notes_controller.dart';
import 'package:notes/models/note_model.dart';

class ManageNoteDialog extends StatefulWidget {
  final NoteModel? oldNote;
  const ManageNoteDialog({super.key, this.oldNote});

  @override
  State<ManageNoteDialog> createState() => _ManageNoteDialogState();
}

class _ManageNoteDialogState extends State<ManageNoteDialog> {
  final notesController = NotesController();
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _dateController = TextEditingController();
  final _levelController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.oldNote != null) {
      _noteController.text = widget.oldNote!.remainder;
      _dateController.text = widget.oldNote!.date.toString();
      _levelController.text = widget.oldNote!.level;
    }
  }

  void showCalendar() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final DateTime fullDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        _dateController.text = fullDateTime.toString();
      }
      Navigator.pop(context);
      print(_dateController.text);
    }
  }

  void save() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final title = _noteController.text;
      final date = DateTime.parse(_dateController.text);
      final level = _levelController.text;

      if (widget.oldNote == null) {
        await notesController.addNote(
          remainder: title,
          date: date,
          level: level,
        );
      } else {
        final updatedNote = widget.oldNote!.copyWith(
          remainder: title,
          date: date,
        );
        await notesController.edit(updatedNote);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _dateController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.oldNote == null ? "Add Note" : "Edit Note"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Note",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please: Enter your note";
                }

                if (value.length < 6) {
                  return "Please: Enter a brief note.";
                }

                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () {
                showCalendar();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Date",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a reminder date.";
                }

                return null;
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              _isLoading
                  ? () {}
                  : () {
                    Navigator.pop(context);
                  },
          child: Text("Cancel"),
        ),
        FilledButton(
          onPressed: _isLoading ? () {} : save,
          child:
              _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Save"),
        ),
      ],
    );
  }
}

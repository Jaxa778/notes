import 'package:notes/models/note_model.dart';
import 'package:notes/services/local_database.dart';

class NotesController {
  NotesController._();

  static final _private = NotesController._();

  factory NotesController() {
    return _private;
  }

  final _localDatabase = LocalDatabase();
  List<NoteModel> notes = [];

  Future<void> getNotes() async {
    notes = await _localDatabase.get();
  }

  Future<void> addNote({
    required String remainder,
    required DateTime date,
    required String level,
  }) async {
    final newNote = NoteModel(
      id: -1,
      remainder: remainder,
      date: date,
      level: level,
    );

    final id = await _localDatabase.insert(newNote);
    notes.add(newNote.copyWith(id: id));
  }

  Future<void> edit(NoteModel note) async {
    await _localDatabase.update(note);
    final currentIndex = notes.indexWhere((t) {
      return t.id == note.id;
    });
    notes[currentIndex] = note;
  }

  Future<void> delete(int id) async {
    await _localDatabase.delete(id);
    notes.removeWhere((t) => t.id == id);
  }
}

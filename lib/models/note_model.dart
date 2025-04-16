class NoteModel {
  final int id;
  final String remainder;
  final DateTime date;
  final String level;

  NoteModel({
    required this.id,
    required this.remainder,
    required this.date,
    required this.level,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map["id"],
      remainder: map["remainder"],
      date: map["date"],
      level: map["level"],
    );
  }

  Map<String, dynamic> toMap() {
    return {"remainder": remainder, "date": date.toString(), "level": level};
  }

  NoteModel copyWith({
    int? id,
    String? remainder,
    DateTime? date,
    String? level,
  }) {
    return NoteModel(
      id: id ?? this.id,
      remainder: remainder ?? this.remainder,
      date: date ?? this.date,
      level: level ?? this.level,
    );
  }
}

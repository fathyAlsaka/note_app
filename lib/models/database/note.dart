class Note {
  late int id;
  final String title;
  final String content;
  final String creationDate;
  final String modifyDate;

  Note.create(
      {required this.title,
      required this.content,
      required this.creationDate,
      required this.modifyDate});
  Note(
      {required this.id,
      required this.title,
      required this.content,
      required this.creationDate,
      required this.modifyDate});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'creationDate': creationDate,
      'modifyDate': modifyDate
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, creationDate: $creationDate, modifyDate: $modifyDate}';
  }
}

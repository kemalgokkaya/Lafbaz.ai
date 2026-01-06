class HistoryItem {
  final int? id;
  final String imagePath;
  final String mode; // 'Karizmatik', 'Diplomatik' vb.
  final String date;
  final String previewText;

  HistoryItem({
    this.id,
    required this.imagePath,
    required this.mode,
    required this.date,
    required this.previewText,
  });

  // Database'e yazarken (Model -> Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'mode': mode,
      'date': date,
      'previewText': previewText,
    };
  }

  // Database'den okurken (Map -> Model)
  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'],
      imagePath: map['imagePath'],
      mode: map['mode'],
      date: map['date'],
      previewText: map['previewText'],
    );
  }
}


import '../../../../const/constant.dart';

class BookMarkModel {
  final int? id;
  final int surahNumber;
  final int verseNumber;
  final String? note;
  final int colorValue;
  final String? createdAt;

  BookMarkModel({
    this.id,
    required this.surahNumber,
    required this.verseNumber,
    this.note,
    required this.colorValue,
    this.createdAt,
  });

  factory BookMarkModel.fromMap(Map<String, dynamic> map) {
    return BookMarkModel(
      id: map['id'] as int?,
      surahNumber: map[kSurahNumberColumn] as int,
      verseNumber: map[kVerseNumberColumn] as int,
      note: map[kNoteColumn] as String?,
      colorValue: map[kColorColumn] as int,
      createdAt: map[kCreatedAtColumn] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      kSurahNumberColumn: surahNumber,
      kVerseNumberColumn: verseNumber,
      kNoteColumn: note,
      kColorColumn: colorValue,
      kCreatedAtColumn: createdAt ?? DateTime.now().toIso8601String(),
    };
  }
}
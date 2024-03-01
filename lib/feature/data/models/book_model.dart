import 'package:audio_book/feature/domain/enitites/book_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.album,
    required super.title,
    required super.url,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
        id: json["id"],
        album: json["album"],
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "album": album,
        "title": title,
        "url": url,
      };
}

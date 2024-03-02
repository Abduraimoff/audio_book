import 'dart:convert';
import 'dart:typed_data';

import 'package:audio_book/feature/domain/enitites/book_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.album,
    required super.title,
    required super.url,
    required super.image,
    required super.duration,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
        id: json["id"],
        album: json["text"],
        title: json["title"],
        url: json["audio"],
        image: json["image"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": album,
        "title": title,
        "audio": url,
        "duration": duration,
        "image": image,
      };

  Future<Uint8List?> toImage({required Uri uri}) async {
    return base64.decode(uri.data!.toString().split(',').last);
  }
}

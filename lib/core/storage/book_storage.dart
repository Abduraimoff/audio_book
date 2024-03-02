import 'dart:convert';

import 'package:audio_book/feature/data/models/book_model.dart';
import 'package:audio_book/feature/domain/enitites/book_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class _Keys {
  static const storageKey = 'BOOKS';
}

class BookStorage {
  final SharedPreferences storage;
  BookStorage({required this.storage});

  Future<List<BookEntity>> getBooks() async {
    final existingList = storage.getStringList(_Keys.storageKey) ?? <String>[];

    return Future.value(
      existingList.map((e) => BookModel.fromJson(jsonDecode(e))).toList(),
    );
  }

  Future<List<BookEntity>> save(BookModel book) async {
    final existingList = storage.getStringList(_Keys.storageKey) ?? <String>[];

    final existingProdIndex = existingList.indexWhere((item) {
      final BookModel decodedBook = BookModel.fromJson(
        jsonDecode(item),
      );
      return decodedBook.id == book.id;
    });
    if (existingProdIndex == -1) {
      final String jsonBook = jsonEncode(book.toJson());
      existingList.add(jsonBook);
    }

    storage.setStringList(_Keys.storageKey, existingList);

    return Future.value(
      existingList.map((e) => BookModel.fromJson(jsonDecode(e))).toList(),
    );
  }
}

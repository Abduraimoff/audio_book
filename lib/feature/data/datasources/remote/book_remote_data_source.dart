import 'dart:convert';

import 'package:audio_book/core/error/exception.dart';
import 'package:audio_book/feature/data/models/book_model.dart';
import 'package:flutter/services.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBooks();
}

class BookRemoteDataSourceImpl extends BookRemoteDataSource {
  @override
  Future<List<BookModel>> getBooks() async {
    try {
      String jsonString = await rootBundle.loadString('assets/json/books.json');

      List<dynamic> jsonList = json.decode(jsonString)['result'];

      List<BookModel> books =
          jsonList.map((json) => BookModel.fromJson(json)).toList();

      return books;
    } catch (e) {
      throw ServerException();
    }
  }
}

import 'package:audio_book/core/error/exception.dart';
import 'package:audio_book/feature/data/models/book_model.dart';
import 'package:dio/dio.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBooks();
}

class BookRemoteDataSourceImpl extends BookRemoteDataSource {
  final Dio _dio;

  BookRemoteDataSourceImpl(this._dio);
  @override
  Future<List<BookModel>> getBooks() async {
    try {
      final response = await _dio.get(
        "https://2dbcc9f37ba34b53a7b4118771ad32a9.api.mockbin.io/",
      );

      final data = response.data as List;

      List<BookModel> books =
          data.map((book) => BookModel.fromJson(book)).toList();

      return books;
    } catch (e) {
      throw ServerException();
    }
  }
}

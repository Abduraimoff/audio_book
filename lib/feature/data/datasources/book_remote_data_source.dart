import 'dart:io';

import 'package:audio_book/core/error/exception.dart';
import 'package:audio_book/feature/data/models/book_model.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBooks();
  Future<String?> downloadBook(String url);
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

  @override
Future<String?> downloadBook(String url) async {
  const String downloadDirectory0 = 'downloaded_files';
  try {
    String directoryPath = await _getFilePath();
    Directory downloadDirectory =
        Directory('$directoryPath/$downloadDirectory0');
    if (!downloadDirectory.existsSync()) {
      downloadDirectory.createSync(recursive: true);
    }

    final String filePath =
        '${downloadDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.mp3';
    await _dio.download(url, filePath);

    return filePath;
  } catch (e) {
    throw CacheException();
  }
}

static Future<String> _getFilePath() async {
  try {
    if (Platform.isIOS) {
      Directory appDir = await getApplicationDocumentsDirectory();
      return appDir.path;
    } else {
      Directory downloadDir = Directory('/storage/emulated/0/Download/');
      if (!await downloadDir.exists()) {
        downloadDir = (await getExternalStorageDirectory())!;
      }
      return downloadDir.path;
    }
  } catch (err) {
    print("Cannot get download folder path $err");
    throw CacheException();
  }
}
}

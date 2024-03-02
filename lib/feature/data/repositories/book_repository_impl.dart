import 'package:audio_book/core/error/exception.dart';
import 'package:audio_book/core/error/failure.dart';
import 'package:audio_book/feature/data/datasources/book_remote_data_source.dart';
import 'package:audio_book/feature/domain/enitites/book_entity.dart';
import 'package:audio_book/feature/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

class BookRepositoryImpl extends BookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, List<BookEntity>>> getBooks() async {
    try {
      final result = await remoteDataSource.getBooks();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> downloadBook(String url) async {
    try {
      final result = await remoteDataSource.downloadBook(url);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

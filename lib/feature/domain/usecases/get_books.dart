import 'package:audio_book/feature/domain/enitites/book_entity.dart';
import 'package:audio_book/feature/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';

class GetBooks extends UseCase<List<BookEntity>, NoParams> {
  final BookRepository repository;

  GetBooks(this.repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) async {
    return await repository.getBooks();
  }
}

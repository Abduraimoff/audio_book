import 'package:audio_book/core/error/failure.dart';
import 'package:audio_book/core/usecases/usecase.dart';
import 'package:audio_book/feature/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

class DownloadBook extends UseCase<String?, DownloadParams> {
  final BookRepository repository;

  DownloadBook(this.repository);

  @override
  Future<Either<Failure, String?>> call(DownloadParams params) async {
    return await repository.downloadBook(params.url);
  }
}

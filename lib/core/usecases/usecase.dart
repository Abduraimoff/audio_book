import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadParams extends Equatable {
  final String url;

  const DownloadParams({required this.url});

  @override
  List<Object?> get props => [url];
}

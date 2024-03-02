// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'storage_cubit.dart';

class StorageState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<BookEntity> books;
  const StorageState({
    this.isLoading = false,
    this.error,
    this.books = const [],
  });

  StorageState copyWith({
    bool? isLoading,
    String? error,
    List<BookEntity>? books,
  }) {
    return StorageState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      books: books ?? this.books,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, books];
}

import 'package:equatable/equatable.dart';

abstract class BookEntity extends Equatable {
  final String id;
  final String album;
  final String title;
  final String url;

  const BookEntity({
    required this.id,
    required this.album,
    required this.title,
    required this.url,
  });

  @override
  List<Object?> get props => [id, album, title, url];
}

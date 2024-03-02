import 'package:equatable/equatable.dart';

abstract class BookEntity extends Equatable {
  final String? id;
  final String album;
  final String title;
  final String url;
  final String image;
  final String duration;

  const BookEntity({
    this.id,
    required this.album,
    required this.title,
    required this.url,
    required this.image,
    required this.duration,
  });

  @override
  List<Object?> get props => [id, album, title, url, image, duration];
}

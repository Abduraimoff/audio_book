import 'package:audio_book/core/audio/audio_service.dart';
import 'package:audio_book/feature/data/datasources/remote/book_remote_data_source.dart';
import 'package:audio_book/feature/data/repositories/book_repository_impl.dart';
import 'package:audio_book/feature/domain/repositories/book_repository.dart';
import 'package:audio_book/feature/domain/usecases/get_books.dart';
import 'package:audio_book/feature/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:audio_book/feature/presentation/screens/nav/bloc/navbar_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! BloC && Cubit
  sl.registerFactory<NavBarBloc>(() => NavBarBloc());
  sl.registerFactory<AudioBloc>(() => AudioBloc(sl(), sl()));
  //! UseCase
  sl.registerLazySingleton<GetBooks>(() => GetBooks(sl()));
  //! Repository
  sl.registerLazySingleton<BookRepository>(() => BookRepositoryImpl(sl()));
  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton<MyAudioHandler>(() => MyAudioHandler(sl()));

  //! External

  sl.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<Dio>(() => Dio());
}

import 'package:audio_book/core/audio/audio_service.dart';
import 'package:audio_book/core/storage/book_storage.dart';
import 'package:audio_book/feature/data/datasources/book_remote_data_source.dart';
import 'package:audio_book/feature/data/repositories/book_repository_impl.dart';
import 'package:audio_book/feature/domain/repositories/book_repository.dart';
import 'package:audio_book/feature/domain/usecases/download_book.dart';
import 'package:audio_book/feature/domain/usecases/get_books.dart';
import 'package:audio_book/feature/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:audio_book/feature/presentation/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:audio_book/feature/presentation/bloc/storage_cubit/storage_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! BloC && Cubit
  sl.registerFactory<NavBarBloc>(() => NavBarBloc());
  sl.registerFactory<AudioBloc>(() => AudioBloc(sl(), sl()));
  sl.registerFactory<StorageCubit>(() => StorageCubit(sl(), sl()));
  //! UseCase
  sl.registerLazySingleton<GetBooks>(() => GetBooks(sl()));
  sl.registerLazySingleton<DownloadBook>(() => DownloadBook(sl()));
  //! Repository
  sl.registerLazySingleton<BookRepository>(() => BookRepositoryImpl(sl()));
  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton<MyAudioHandler>(() => MyAudioHandler(sl()));
  sl.registerLazySingleton<BookStorage>(() => BookStorage(storage: sl()));

  //! External

  sl.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<Dio>(() => Dio());
}

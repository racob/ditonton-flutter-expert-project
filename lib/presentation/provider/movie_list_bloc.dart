import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../domain/usecases/get_now_playing_movies.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';

abstract class MovieListEvent {}

class FetchNowPlayingMovies extends MovieListEvent {}

class FetchPopularMovies extends MovieListEvent {}

class FetchTopRatedMovies extends MovieListEvent {}

abstract class MovieListState extends Equatable {}

class isLoading extends MovieListState {
  @override
  List<Object> get props => [];
}

class isLoadedNowPlaying extends MovieListState {
  final List<Movie> nowPlayingMovies;

  isLoadedNowPlaying(this.nowPlayingMovies);

  @override
  List<Object> get props => [];
}

class isLoadedPopular extends MovieListState {
  final List<Movie> popularMovies;

  isLoadedPopular(this.popularMovies);

  @override
  List<Object> get props => [];
}

class isLoadedTopRated extends MovieListState {
  final List<Movie> topRatedMovies;

  isLoadedTopRated(this.topRatedMovies);

  @override
  List<Object> get props => [];
}

class isError extends MovieListState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(isLoading()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(isLoading());
      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (moviesData) => emit(isLoadedNowPlaying(moviesData)),
      );
    });

    on<FetchPopularMovies>((event, emit) async {
      emit(isLoading());
      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (moviesData) => emit(isLoadedPopular(moviesData)),
      );
    });

    on<FetchTopRatedMovies>((event, emit) async {
      emit(isLoading());
      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (moviesData) => emit(isLoadedTopRated(moviesData)),
      );
    });
  }
}

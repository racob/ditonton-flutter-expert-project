import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../domain/usecases/get_watchlist_movies.dart';

abstract class WatchlistMovieEvent {}

class FetchWatchlistMovies extends WatchlistMovieEvent {}

abstract class WatchlistMovieState extends Equatable {}

class isLoading extends WatchlistMovieState {
  @override
  List<Object> get props => [];
}

class isLoaded extends WatchlistMovieState {
  final List<Movie> watchlistMovies;

  isLoaded(this.watchlistMovies);

  @override
  List<Object> get props => [];
}

class isError extends WatchlistMovieState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc({required this.getWatchlistMovies}) : super(isLoading()) {
    on<FetchWatchlistMovies>(_onFetchWatchlistMoviesEvent);
  }

  Future<void> _onFetchWatchlistMoviesEvent(
    FetchWatchlistMovies event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(isLoading());
    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) => emit(isError(failure.message)),
      (moviesData) => emit(isLoaded(moviesData)),
    );
  }
}

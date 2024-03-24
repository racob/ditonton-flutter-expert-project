import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_top_rated_movies.dart';

abstract class TopRatedMoviesEvent {}

class FetchTopRatedMovies extends TopRatedMoviesEvent {}

abstract class TopRatedMoviesState extends Equatable {}

class isLoading extends TopRatedMoviesState {
  @override
  List<Object> get props => [];
}

class isLoaded extends TopRatedMoviesState {
  final List<Movie> movies;

  isLoaded(this.movies);

  @override
  List<Object> get props => [];
}

class isError extends TopRatedMoviesState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc(this.getTopRatedMovies) : super(isLoading()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(isLoading());
      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (moviesData) => emit(isLoaded(moviesData)),
      );
    });
  }
}

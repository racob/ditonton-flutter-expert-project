import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies.dart';

abstract class PopularMoviesEvent {}

class FetchPopularMovies extends PopularMoviesEvent {}

abstract class PopularMoviesState extends Equatable {}

class isLoading extends PopularMoviesState {
  @override
  List<Object> get props => [];
}

class isLoaded extends PopularMoviesState {
  final List<Movie> movies;

  isLoaded(this.movies);

  @override
  List<Object> get props => [];
}

class isError extends PopularMoviesState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(isLoading()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(isLoading());
      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (moviesData) => emit(isLoaded(moviesData)),
      );
    });
  }
}

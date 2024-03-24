import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_movies.dart';

abstract class MovieSearchState extends Equatable {}

class isEmpty extends MovieSearchState {
  @override
  List<Object> get props => [];
}

class isLoading extends MovieSearchState {
  @override
  List<Object> get props => [];
}

class isLoaded extends MovieSearchState {
  final List<Movie> searchResult;

  isLoaded(this.searchResult);

  @override
  List<Object> get props => [];
}

class isError extends MovieSearchState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

abstract class MovieSearchEvent {}

class FetchMovieSearch extends MovieSearchEvent {
  final String query;

  FetchMovieSearch(this.query);
}

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc(this.searchMovies) : super(isEmpty()) {
    on<FetchMovieSearch>((event, emit) async {
      emit(isLoading());
      final result = await searchMovies.execute(event.query);
      result.fold(
        (failure) {
          emit(isError(failure.message));
        },
        (data) {
          emit(isLoaded(data));
        },
      );
    });
  }
}

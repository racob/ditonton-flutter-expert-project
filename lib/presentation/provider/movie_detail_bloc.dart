import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_movie_recommendations.dart';
import '../../domain/usecases/get_watchlist_status.dart';
import '../../domain/usecases/remove_watchlist.dart';
import '../../domain/usecases/save_watchlist.dart';

abstract class MovieDetailEvent {}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  FetchMovieDetail(this.id);
}

class AddToWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  AddToWatchlist(this.movie);
}

class RemoveFromWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  RemoveFromWatchlist(this.movie);
}

class LoadWatchlistStatus extends MovieDetailEvent {
  final int id;

  LoadWatchlistStatus(this.id);
}

abstract class MovieDetailState extends Equatable {}

class isLoading extends MovieDetailState {
  @override
  List<Object> get props => [];
}

class isLoaded extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;

  isLoaded(this.movie, this.recommendations, this.isAddedToWatchlist);

  @override
  List<Object> get props => [];
}

class isError extends MovieDetailState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class WatchlistOperationSuccess extends MovieDetailState {
  final String message;

  WatchlistOperationSuccess(this.message);

  @override
  List<Object> get props => [];
}

class WatchlistOperationFailure extends MovieDetailState {
  final String message;

  WatchlistOperationFailure(this.message);

  @override
  List<Object> get props => [];
}

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetail? _movie;
  List<Movie> _recommendations = [];

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(isLoading()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(isLoading());

      final movieResult = await getMovieDetail.execute(event.id);
      final recommendationsResult =
          await getMovieRecommendations.execute(event.id);
      final isAddedToWatchlist = await getWatchListStatus.execute(event.id);
      movieResult.fold(
        (failure) {
          emit(isError("Failed to fetch MOVIE details."));
        },
        (movie) async {
          recommendationsResult.fold(
            (failure) => emit(isError("Failed to fetch MOVIE details.")),
            (recommendations) {
              _movie = movie;
              _recommendations = recommendations;
              emit(isLoaded(movie, recommendations, isAddedToWatchlist));
            },
          );
        },
      );
    });

    on<AddToWatchlist>((event, emit) async {
      (await saveWatchlist.execute(event.movie)).fold(
        (failure) {
          emit(WatchlistOperationFailure(failure.message));
        },
        (successMessage) {
          emit(WatchlistOperationSuccess(successMessage));
          add(LoadWatchlistStatus(event.movie.id));
        },
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      (await removeWatchlist.execute(event.movie)).fold(
        (failure) {
          emit(WatchlistOperationFailure(failure.message));
        },
        (successMessage) {
          emit(WatchlistOperationSuccess(successMessage));
          add(LoadWatchlistStatus(event.movie.id));
        },
      );
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final isAddedToWatchlist = await getWatchListStatus.execute(event.id);
      emit(isLoaded(_movie!, _recommendations, isAddedToWatchlist));
    });
  }
}

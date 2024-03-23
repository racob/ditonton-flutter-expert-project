import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/entities/tv_detail.dart';
import '../../../domain/usecases/tv/get_tv_detail.dart';
import '../../../domain/usecases/tv/get_tv_recommendations.dart';
import '../../../domain/usecases/tv/get_watchlist_status.dart';
import '../../../domain/usecases/tv/remove_watchlist.dart';
import '../../../domain/usecases/tv/save_watchlist.dart';

abstract class TvDetailEvent {}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  FetchTvDetail(this.id);
}

class AddToWatchlist extends TvDetailEvent {
  final TvDetail tv;

  AddToWatchlist(this.tv);
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvDetail tv;

  RemoveFromWatchlist(this.tv);
}

class LoadWatchlistStatus extends TvDetailEvent {
  final int id;

  LoadWatchlistStatus(this.id);
}

abstract class TvDetailState extends Equatable {}

class isLoading extends TvDetailState {
  @override
  List<Object> get props => [];
}

class isLoaded extends TvDetailState {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedToWatchlist;

  isLoaded(this.tv, this.recommendations, this.isAddedToWatchlist);

  @override
  List<Object> get props => [];
}

class isError extends TvDetailState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class WatchlistOperationSuccess extends TvDetailState {
  final String message;

  WatchlistOperationSuccess(this.message);

  @override
  List<Object> get props => [];
}

class WatchlistOperationFailure extends TvDetailState {
  final String message;

  WatchlistOperationFailure(this.message);

  @override
  List<Object> get props => [];
}

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetTvWatchListStatus getWatchListStatus;
  final SaveTvWatchlist saveWatchlist;
  final RemoveTvWatchlist removeWatchlist;

  TvDetail? _tv;
  List<Tv> _recommendations = [];

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(isLoading()) {
    on<FetchTvDetail>((event, emit) async {
      emit(isLoading());

      final tvResult = await getTvDetail.execute(event.id);
      final recommendationsResult =
          await getTvRecommendations.execute(event.id);
      final isAddedToWatchlist = await getWatchListStatus.execute(event.id);
      tvResult.fold(
        (failure) {
          emit(isError("Failed to fetch TV details."));
        },
        (tv) async {
          recommendationsResult.fold(
            (failure) => emit(isError("Failed to fetch TV details.")),
            (recommendations) {
              _tv = tv;
              _recommendations = recommendations;
              emit(isLoaded(tv, recommendations, isAddedToWatchlist));
            },
          );
        },
      );
    });

    on<AddToWatchlist>((event, emit) async {
      (await saveWatchlist.execute(event.tv)).fold(
        (failure) {
          emit(WatchlistOperationFailure(failure.message));
        },
        (successMessage) {
          emit(WatchlistOperationSuccess(successMessage));
          add(LoadWatchlistStatus(event.tv.id));
        },
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      (await removeWatchlist.execute(event.tv)).fold(
        (failure) {
          emit(WatchlistOperationFailure(failure.message));
        },
        (successMessage) {
          emit(WatchlistOperationSuccess(successMessage));
          add(LoadWatchlistStatus(event.tv.id));
        },
      );
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final isAddedToWatchlist = await getWatchListStatus.execute(event.id);
      emit(isLoaded(_tv!, _recommendations, isAddedToWatchlist));
    });
  }
}

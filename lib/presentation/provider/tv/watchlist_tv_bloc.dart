import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_watchlist_tvs.dart';

abstract class WatchlistTvEvent {}

class FetchWatchlistTvs extends WatchlistTvEvent {}

abstract class WatchlistTvState {}

class isLoading extends WatchlistTvState {}

class isLoaded extends WatchlistTvState {
  final List<Tv> watchlistTvs;

  isLoaded(this.watchlistTvs);
}

class isError extends WatchlistTvState {
  final String message;

  isError(this.message);
}

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvs getWatchlistTvs;

  WatchlistTvBloc({required this.getWatchlistTvs})
      : super(isLoading()) {
    on<FetchWatchlistTvs>(_onFetchWatchlistTvsEvent);
  }

  Future<void> _onFetchWatchlistTvsEvent(
    FetchWatchlistTvs event,
    Emitter<WatchlistTvState> emit,
  ) async {
    emit(isLoading());
    final result = await getWatchlistTvs.execute();
    result.fold(
      (failure) => emit(isError(failure.message)),
      (tvsData) => emit(isLoaded(tvsData)),
    );
  }
}

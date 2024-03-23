import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_watchlist_tvs.dart';

abstract class WatchlistTvEvent {}

class FetchWatchlistTvs extends WatchlistTvEvent {}

abstract class WatchlistTvState extends Equatable {}

class isLoading extends WatchlistTvState {
  @override
  List<Object> get props => [];
}

class isLoaded extends WatchlistTvState {
  final List<Tv> watchlistTvs;

  isLoaded(this.watchlistTvs);

  @override
  List<Object> get props => [];
}

class isError extends WatchlistTvState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvs getWatchlistTvs;

  WatchlistTvBloc({required this.getWatchlistTvs}) : super(isLoading()) {
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

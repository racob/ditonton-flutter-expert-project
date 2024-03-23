import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_now_playing_tvs.dart';
import '../../../domain/usecases/tv/get_popular_tvs.dart';
import '../../../domain/usecases/tv/get_top_rated_tvs.dart';

abstract class TvListEvent {}

class FetchNowPlayingTvs extends TvListEvent {}

class FetchPopularTvs extends TvListEvent {}

class FetchTopRatedTvs extends TvListEvent {}

abstract class TvListState {}

class isLoading extends TvListState {}

class isLoadedNowPlaying extends TvListState {
  final List<Tv> nowPlayingTvs;
  isLoadedNowPlaying(this.nowPlayingTvs);
}

class isLoadedPopular extends TvListState {
  final List<Tv> popularTvs;
  isLoadedPopular(this.popularTvs);
}

class isLoadedTopRated extends TvListState {
  final List<Tv> topRatedTvs;
  isLoadedTopRated(this.topRatedTvs);
}


class isError extends TvListState {
  final String message;

  isError(this.message);
}

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTvs getNowPlayingTvs;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTvs getTopRatedTvs;

  TvListBloc({
    required this.getNowPlayingTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  }) : super(isLoading()) {
    on<FetchNowPlayingTvs>((event, emit) async {
      emit(isLoading());
      final result = await getNowPlayingTvs.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (tvsData) => emit(isLoadedNowPlaying(tvsData)),
      );
    });

    on<FetchPopularTvs>((event, emit) async {
      emit(isLoading());
      final result = await getPopularTvs.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (tvsData) => emit(isLoadedPopular(tvsData)),
      );
    });

    on<FetchTopRatedTvs>((event, emit) async {
      emit(isLoading());
      final result = await getTopRatedTvs.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (tvsData) => emit(isLoadedTopRated(tvsData)),
      );
    });
  }
}

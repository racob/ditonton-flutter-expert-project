import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_now_playing_tvs.dart';

abstract class NowPlayingTvsEvent {}

class FetchNowPlayingTvs extends NowPlayingTvsEvent {}

abstract class NowPlayingTvsState {}

class isEmpty extends NowPlayingTvsState {}

class isLoading extends NowPlayingTvsState {}

class isLoaded extends NowPlayingTvsState {
  final List<Tv> tvs;

  isLoaded(this.tvs);
}

class isError extends NowPlayingTvsState {
  final String message;

  isError(this.message);
}

class NowPlayingTvsBloc extends Bloc<NowPlayingTvsEvent, NowPlayingTvsState> {
  final GetNowPlayingTvs getNowPlayingTvs;

  NowPlayingTvsBloc(this.getNowPlayingTvs) : super(isEmpty()) {
    on<FetchNowPlayingTvs>((event, emit) async {
      emit(isLoading());
      final result = await getNowPlayingTvs.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (tvsData) => emit(isLoaded(tvsData)),
      );
    });
  }
}

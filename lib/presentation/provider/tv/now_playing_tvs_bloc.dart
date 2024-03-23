import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_now_playing_tvs.dart';

abstract class NowPlayingTvsEvent {}

class FetchNowPlayingTvs extends NowPlayingTvsEvent {}

abstract class NowPlayingTvsState extends Equatable {}

class isLoading extends NowPlayingTvsState {
  @override
  List<Object> get props => [];
}

class isLoaded extends NowPlayingTvsState {
  final List<Tv> tvs;

  isLoaded(this.tvs);

  @override
  List<Object> get props => [];
}

class isError extends NowPlayingTvsState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class NowPlayingTvsBloc extends Bloc<NowPlayingTvsEvent, NowPlayingTvsState> {
  final GetNowPlayingTvs getNowPlayingTvs;

  NowPlayingTvsBloc(this.getNowPlayingTvs) : super(isLoading()) {
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

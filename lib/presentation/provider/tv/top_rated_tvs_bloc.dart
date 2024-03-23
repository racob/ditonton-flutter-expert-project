import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_top_rated_tvs.dart';

abstract class TopRatedTvsEvent {}

class FetchTopRatedTvs extends TopRatedTvsEvent {}

abstract class TopRatedTvsState {}

class isEmpty extends TopRatedTvsState {}

class isLoading extends TopRatedTvsState {}

class isLoaded extends TopRatedTvsState {
  final List<Tv> tvs;

  isLoaded(this.tvs);
}

class isError extends TopRatedTvsState {
  final String message;

  isError(this.message);
}

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;

  TopRatedTvsBloc(this.getTopRatedTvs) : super(isEmpty()) {
    on<FetchTopRatedTvs>((event, emit) async {
      emit(isLoading());
      final result = await getTopRatedTvs.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (tvsData) => emit(isLoaded(tvsData)),
      );
    });
  }
}

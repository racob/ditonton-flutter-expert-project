import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_top_rated_tvs.dart';

abstract class TopRatedTvsEvent {}

class FetchTopRatedTvs extends TopRatedTvsEvent {}

abstract class TopRatedTvsState extends Equatable {}

class isLoading extends TopRatedTvsState {
  @override
  List<Object> get props => [];
}

class isLoaded extends TopRatedTvsState {
  final List<Tv> tvs;

  isLoaded(this.tvs);

  @override
  List<Object> get props => [];
}

class isError extends TopRatedTvsState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;

  TopRatedTvsBloc(this.getTopRatedTvs) : super(isLoading()) {
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

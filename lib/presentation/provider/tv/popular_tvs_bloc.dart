import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_popular_tvs.dart';

abstract class PopularTvsEvent {}

class FetchPopularTvs extends PopularTvsEvent {}

abstract class PopularTvsState extends Equatable {}

class isLoading extends PopularTvsState {
  @override
  List<Object> get props => [];
}

class isLoaded extends PopularTvsState {
  final List<Tv> tvs;

  isLoaded(this.tvs);

  @override
  List<Object> get props => [];
}

class isError extends PopularTvsState {
  final String message;

  isError(this.message);

  @override
  List<Object> get props => [];
}

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs getPopularTvs;

  PopularTvsBloc(this.getPopularTvs) : super(isLoading()) {
    on<FetchPopularTvs>((event, emit) async {
      emit(isLoading());
      final result = await getPopularTvs.execute();
      result.fold(
        (failure) => emit(isError(failure.message)),
        (tvsData) => emit(isLoaded(tvsData)),
      );
    });
  }
}

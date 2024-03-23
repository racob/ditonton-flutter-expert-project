import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_popular_tvs.dart';

abstract class PopularTvsEvent {}

class FetchPopularTvs extends PopularTvsEvent {}

abstract class PopularTvsState {}

class isEmpty extends PopularTvsState {}

class isLoading extends PopularTvsState {}

class isLoaded extends PopularTvsState {
  final List<Tv> tvs;

  isLoaded(this.tvs);
}

class isError extends PopularTvsState {
  final String message;

  isError(this.message);
}

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs getPopularTvs;

  PopularTvsBloc(this.getPopularTvs) : super(isEmpty()) {
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

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tvs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TvSearchState {}

class isEmpty extends TvSearchState {}

class isLoading extends TvSearchState {}

class isLoaded extends TvSearchState {
  final List<Tv> searchResult;

  isLoaded(this.searchResult);
}

class isError extends TvSearchState {
  final String message;

  isError(this.message);
}

abstract class TvSearchEvent {}

class FetchTvSearch extends TvSearchEvent {
  final String query;

  FetchTvSearch(this.query);
}

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs searchTvs;

  TvSearchBloc(this.searchTvs) : super(isEmpty()) {
    on<FetchTvSearch>((event, emit) async {
      emit(isLoading());
      final result = await searchTvs.execute(event.query);
      result.fold(
            (failure) {
          emit(isError(failure.message));
        },
            (data) {
          emit(isLoaded(data));
        },
      );
    });
  }
}

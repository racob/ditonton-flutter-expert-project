import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TvSearchState extends Equatable {}

class isEmpty extends TvSearchState {
  @override
  List<Object> get props => [];
}

class isLoading extends TvSearchState {
  @override
  List<Object> get props => [];
}

class isLoaded extends TvSearchState {
  final List<Tv> searchResult;

  isLoaded(this.searchResult);
  @override
  List<Object> get props => [];
}

class isError extends TvSearchState {
  final String message;

  isError(this.message);
  @override
  List<Object> get props => [];
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

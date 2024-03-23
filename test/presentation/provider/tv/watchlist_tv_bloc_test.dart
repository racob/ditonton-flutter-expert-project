import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tvs.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_tv_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late MockGetWatchlistTvs mockGetWatchlistTvs;
  late WatchlistTvBloc bloc;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    bloc = WatchlistTvBloc(getWatchlistTvs: mockGetWatchlistTvs);
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'should change state to loading and loaded when usecase is called',
    build: () {
      when(mockGetWatchlistTvs.execute())
          .thenAnswer((_) async => Right([testWatchlistTv]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvs()),
    expect: () => [
      isLoading(),
      isLoaded([testWatchlistTv]),
    ],
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetWatchlistTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvs()),
    expect: () => [
      isLoading(),
      isError('Server Failure'),
    ],
  );
}

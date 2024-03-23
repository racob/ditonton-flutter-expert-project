import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_tv_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetTvWatchListStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetTvWatchListStatus mockGetWatchlistStatus;
  late MockSaveTvWatchlist mockSaveWatchlist;
  late MockRemoveTvWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatus = MockGetTvWatchListStatus();
    mockSaveWatchlist = MockSaveTvWatchlist();
    mockRemoveWatchlist = MockRemoveTvWatchlist();
    bloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;

  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvs = <Tv>[tTv];

  void _arrageUsecases(
      {required bool isAddedToWatchlist, bool isError = false}) {
    when(mockGetTvDetail.execute(tId)).thenAnswer((_) async =>
        isError ? Left(ServerFailure('Server Failure')) : Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId)).thenAnswer((_) async =>
        isError ? Left(ServerFailure('Server Failure')) : Right(tTvs));
    when(mockGetWatchlistStatus.execute(tId))
        .thenAnswer((_) async => isAddedToWatchlist);
  }

  group('Get Tv Detail, recommendations, watchlist status', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should change state to loading and loaded when usecase is called',
      build: () {
        _arrageUsecases(isAddedToWatchlist: false);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvDetail(tId)),
      expect: () => [
        isLoading(),
        isLoaded(testTvDetail, tTvs, false),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should return error when data is unsuccessful',
      build: () {
        _arrageUsecases(isAddedToWatchlist: false, isError: true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvDetail(tId)),
      expect: () => [
        isLoading(),
        isError('Server Failure'),
      ],
    );
  });

  group('Watchlist operations', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should execute save watchlist when function called',
      build: () {
        _arrageUsecases(isAddedToWatchlist: false);
        when(mockSaveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Success'));
        return bloc;
      },
      act: (bloc) {
        bloc.add(FetchTvDetail(tId));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        bloc.add(AddToWatchlist(testTvDetail));
      },
      expect: () => [
        isLoading(),
        WatchlistOperationSuccess('Success'),
        isLoaded(testTvDetail, tTvs, true),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should execute remove watchlist when function called',
      build: () {
        _arrageUsecases(isAddedToWatchlist: false);
        when(mockRemoveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Success'));
        return bloc;
      },
      act: (bloc) {
        bloc.add(FetchTvDetail(tId));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        bloc.add(RemoveFromWatchlist(testTvDetail));
      },
      expect: () => [
        isLoading(),
        WatchlistOperationSuccess('Success'),
        isLoaded(testTvDetail, tTvs, false),
      ],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/provider/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
    video: false,
  );

  final tMovies = <Movie>[tMovie];

  void _arrageUsecases(
      {required bool isAddedToWatchlist, bool isError = false}) {
    when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => isError
        ? Left(ServerFailure('Server Failure'))
        : Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async =>
        isError ? Left(ServerFailure('Server Failure')) : Right(tMovies));
    when(mockGetWatchlistStatus.execute(tId))
        .thenAnswer((_) async => isAddedToWatchlist);
  }

  group('Get Movie Detail, recommendations, watchlist status', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should change state to loading and loaded when usecase is called',
      build: () {
        _arrageUsecases(isAddedToWatchlist: false);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        isLoading(),
        isLoaded(testMovieDetail, tMovies, false),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should return error when data is unsuccessful',
      build: () {
        _arrageUsecases(isAddedToWatchlist: false, isError: true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        isLoading(),
        isError('Server Failure'),
      ],
    );
  });

  group('Watchlist operations', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should execute save watchlist when function called',
      build: () {
        _arrageUsecases(isAddedToWatchlist: false);
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Success'));
        return bloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieDetail(tId));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        bloc.add(AddToWatchlist(testMovieDetail));
      },
      expect: () => [
        isLoading(),
        WatchlistOperationSuccess('Success'),
        isLoaded(testMovieDetail, tMovies, true),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should execute remove watchlist when function called',
      build: () {
        _arrageUsecases(isAddedToWatchlist: false);
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Success'));
        return bloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieDetail(tId));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        bloc.add(RemoveFromWatchlist(testMovieDetail));
      },
      expect: () => [
        isLoading(),
        WatchlistOperationSuccess('Success'),
        isLoaded(testMovieDetail, tMovies, false),
      ],
    );
  });
}

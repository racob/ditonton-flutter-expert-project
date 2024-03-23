import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late TvListBloc bloc;
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TvListBloc(
      getNowPlayingTvs: mockGetNowPlayingTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

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
  final tTvList = <Tv>[tTv];

  group('now playing tvs', () {
    blocTest<TvListBloc, TvListState>(
      'should change state to loading and loaded when usecase is called',
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvs()),
      expect: () => [
        isLoading(),
        isLoadedNowPlaying(tTvList),
      ],
    );

    blocTest<TvListBloc, TvListState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvs()),
      expect: () => [
        isLoading(),
        isError('Server Failure'),
      ],
    );
  });

  group('popular tvs', () {
    blocTest<TvListBloc, TvListState>(
      'should change state to loading and loaded when usecase is called',
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect: () => [
        isLoading(),
        isLoadedPopular(tTvList),
      ],
    );

    blocTest<TvListBloc, TvListState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect: () => [
        isLoading(),
        isError('Server Failure'),
      ],
    );
  });

  group('top rated tvs', () {
    blocTest<TvListBloc, TvListState>(
      'should change state to loading and loaded when usecase is called',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvs()),
      expect: () => [
        isLoading(),
        isLoadedTopRated(tTvList),
      ],
    );

    blocTest<TvListBloc, TvListState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvs()),
      expect: () => [
        isLoading(),
        isError('Server Failure'),
      ],
    );
  });
}

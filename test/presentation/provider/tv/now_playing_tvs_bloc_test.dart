import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:ditonton/presentation/provider/tv/now_playing_tvs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvs])
void main() {
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;
  late NowPlayingTvsBloc bloc;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    bloc = NowPlayingTvsBloc(mockGetNowPlayingTvs);
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

  blocTest<NowPlayingTvsBloc, NowPlayingTvsState>(
    'should change state to loading and loaded when usecase is called',
    build: () {
      when(mockGetNowPlayingTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTvs()),
    expect: () => [
      isLoading(),
      isLoaded(tTvList),
    ],
  );

  blocTest<NowPlayingTvsBloc, NowPlayingTvsState>(
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
}

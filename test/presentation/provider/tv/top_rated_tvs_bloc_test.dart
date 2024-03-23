import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tvs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late TopRatedTvsBloc bloc;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TopRatedTvsBloc(mockGetTopRatedTvs);
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

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'should change state to loading and loaded when usecase is called',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [
      isLoading(),
      isLoaded(tTvList),
    ],
  );

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
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
}

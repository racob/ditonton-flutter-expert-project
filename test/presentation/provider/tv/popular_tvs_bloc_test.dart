import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/presentation/provider/tv/popular_tvs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late MockGetPopularTvs mockGetPopularTvs;
  late PopularTvsBloc bloc;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    bloc = PopularTvsBloc(mockGetPopularTvs);
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

  blocTest<PopularTvsBloc, PopularTvsState>(
    'should change state to loading and loaded when usecase is called',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvs()),
    expect: () => [
      isLoading(),
      isLoaded(tTvList),
    ],
  );

  blocTest<PopularTvsBloc, PopularTvsState>(
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
}

import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tvs.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist.dart';
import 'package:ditonton/presentation/provider/tv/now_playing_tvs_bloc.dart';
import 'package:ditonton/presentation/provider/tv/popular_tvs_bloc.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tvs_bloc.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_bloc.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_bloc.dart';
import 'package:ditonton/presentation/provider/tv/tv_search_bloc.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/usecases/tv/get_now_playing_tvs.dart';
import 'domain/usecases/tv/search_tvs.dart';
import 'injection.dart';

class BlocProvided extends StatelessWidget {
  const BlocProvided({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TvListBloc(
            getNowPlayingTvs: locator<GetNowPlayingTvs>(),
            getPopularTvs: locator<GetPopularTvs>(),
            getTopRatedTvs: locator<GetTopRatedTvs>(),
          ),
        ),
        BlocProvider(
          create: (_) => NowPlayingTvsBloc(locator<GetNowPlayingTvs>()),
        ),
        BlocProvider(
          create: (_) => PopularTvsBloc(locator<GetPopularTvs>()),
        ),
        BlocProvider(
          create: (_) => TopRatedTvsBloc(locator<GetTopRatedTvs>()),
        ),
        BlocProvider(
          create: (_) => TvDetailBloc(
            getTvDetail: locator<GetTvDetail>(),
            getTvRecommendations: locator<GetTvRecommendations>(),
            getWatchListStatus: locator<GetTvWatchListStatus>(),
            saveWatchlist: locator<SaveTvWatchlist>(),
            removeWatchlist: locator<RemoveTvWatchlist>(),
          ),
        ),
        BlocProvider(
          create: (_) => TvSearchBloc(locator<SearchTvs>()),
        ),
        BlocProvider(
          create: (_) => WatchlistTvBloc(
            getWatchlistTvs: locator<GetWatchlistTvs>(),
          ),
        ),
      ],
      child: child,
    );
  }
}

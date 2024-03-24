import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/tv/tv_watchlist.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../provider/watchlist_movie_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Watchlist'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.movie), text: "Movies"),
                Tab(icon: Icon(Icons.movie), text: "TV Series")
              ],
            ),
          ),
          body: TabBarView(
            children: [_movies(), TvWatchlist()],
          )),
    );
  }

  Widget _movies() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
        builder: (context, state) {
          if (state is isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is isLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.watchlistMovies[index];
                return MovieCard(movie);
              },
              itemCount: state.watchlistMovies.length,
            );
          } else if (state is isError) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

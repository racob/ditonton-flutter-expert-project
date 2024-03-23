import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../provider/tv/watchlist_tv_bloc.dart';
import '../../widgets/tv_card_list.dart';

class TvWatchlist extends StatefulWidget {
  const TvWatchlist({super.key});

  @override
  State<TvWatchlist> createState() => _TvWatchlistState();
}

class _TvWatchlistState extends State<TvWatchlist> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistTvBloc>().add(FetchWatchlistTvs());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
        builder: (context, state) {
          if (state is isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is isLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.watchlistTvs[index];
                return TvCard(tv);
              },
              itemCount: state.watchlistTvs.length,
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
}

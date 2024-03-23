import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/pages/tv/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants.dart';
import '../../../domain/entities/tv.dart';
import 'now_playing_tvs_page.dart';

class HomeTvsList extends StatefulWidget {
  const HomeTvsList({super.key});

  @override
  State<HomeTvsList> createState() => _HomeTvsListState();
}

class _HomeTvsListState extends State<HomeTvsList> {

  @override
  void initState() {
    super.initState();
    context.read<TvListBloc>().add(FetchNowPlayingTvs());
    context.read<TvListBloc>().add(FetchPopularTvs());
    context.read<TvListBloc>().add(FetchTopRatedTvs());
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeading(
              title: 'Now Playing',
              onTap: () =>
                  Navigator.pushNamed(context, NowPlayingTvsPage.ROUTE_NAME),
            ),
            BlocBuilder<TvListBloc, TvListState>(
              buildWhen: (context, state) =>
                  !(state is isLoadedPopular) && !(state is isLoadedTopRated),
              builder: (context, state) {
                if (state is isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is isLoadedNowPlaying) {
                  return TvsList(state.nowPlayingTvs);
                } else {
                  return Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
            ),
            BlocBuilder<TvListBloc, TvListState>(
              buildWhen: (context, state) =>
                  !(state is isLoadedNowPlaying) &&
                  !(state is isLoadedTopRated),
              builder: (context, state) {
                if (state is isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is isLoadedPopular) {
                  return TvsList(state.popularTvs);
                } else {
                  return Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
            ),
            BlocBuilder<TvListBloc, TvListState>(
              buildWhen: (context, state) =>
                  !(state is isLoadedPopular) && !(state is isLoadedNowPlaying),
              builder: (context, state) {
                if (state is isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is isLoadedTopRated) {
                  return TvsList(state.topRatedTvs);
                } else {
                  return Text('Failed');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvsList extends StatelessWidget {
  final List<Tv> tvs;

  TvsList(this.tvs);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}

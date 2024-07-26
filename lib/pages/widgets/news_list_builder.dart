import 'package:tech_i/cubit/news/news_cubit.dart';
import 'package:tech_i/cubit/news/news_state.dart';
import 'package:tech_i/pages/widgets/news_card.dart';
import 'package:tech_i/pages/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsListBuilder extends StatefulWidget {
  const NewsListBuilder({super.key, required this.controller});
  final ScrollController controller;
  @override
  State<NewsListBuilder> createState() => _NewsListBuilderState();
}

class _NewsListBuilderState extends State<NewsListBuilder> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const ShimmerLoading();
            } else if (state is NewsLoaded || state is MoreNewsLoading) {
              final stories = state is NewsLoaded
                  ? state.stories
                  : (state as MoreNewsLoading).stories;
              return ListView.builder(
                controller: widget.controller,
                itemCount: stories.keys.length + 1,
                itemBuilder: (context, index) {
                  if (index < stories.length) {
                    return NewsCard(
                      story: stories[stories.keys.elementAt(index)]!,
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            } else if (state is NewsError) {
              return GestureDetector(
                onTap: () {
                  context.read<NewsCubit>().fetchStories();
                },
                child: Center(
                  child: Text(
                    "Error: ${state.message},\n Tap to refresh",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Press the button to fetch stories',
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

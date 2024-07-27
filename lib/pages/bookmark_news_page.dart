import 'package:TechI/pages/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TechI/cubit/bookmarkNews/bookmark_cubit.dart';
import 'package:TechI/pages/widgets/news_card.dart';

class FavNewsPage extends StatelessWidget {
  const FavNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkLoaded>(
        builder: (context, state) {
          if (state.isLoading) {
            return const ShimmerLoading();
          }

          if (state.bookmarkStoryList.isEmpty) {
            return const Center(child: Text('No bookmarks yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(4.0),
            itemCount: state.bookmarkStoryList.keys.length,
            itemBuilder: (context, index) {
              final storyMap = state.bookmarkStoryList[
                  state.bookmarkStoryList.keys.elementAt(index)];
              return NewsCard(
                story: storyMap!,
              );
            },
          );
        },
      ),
    );
  }
}

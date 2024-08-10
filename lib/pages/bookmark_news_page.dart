import 'package:TechI/cubit/bookmarkNews/bookmark_cubit.dart';
import 'package:TechI/pages/widgets/news_card.dart';
import 'package:TechI/pages/widgets/shimmer_loading.dart';
import 'package:TechI/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkNewsPage extends StatelessWidget {
  const BookmarkNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        surfaceTintColor: context.theme.scaffoldBackgroundColor,
        shadowColor:
            context.theme.appBarTheme.iconTheme!.color!.withOpacity(0.5),
        elevation: 5,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 15,
            ),
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

import 'package:TechI/cubit/bookmarkNews/bookmark_cubit.dart';
import 'package:TechI/pages/bookmark_news_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarksIconWidget extends StatelessWidget {
  const BookmarksIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Bookmarks",
      child: IconButton(
        onPressed: () async {
          await context.read<BookmarkCubit>().fetchBookmarkStories();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const FavNewsPage();
              },
            ),
          );
        },
        icon: const Icon(Icons.bookmark_border_rounded),
      ),
    );
  }
}

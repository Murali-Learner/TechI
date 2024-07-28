import 'package:TechI/utils/extension/spacer_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TechI/cubit/bookmarkNews/bookmark_cubit.dart';
import 'package:TechI/cubit/news/news_cubit.dart';
import 'package:TechI/model/story.dart';
import 'package:TechI/pages/web_view_page.dart';
import 'package:TechI/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatefulWidget {
  final Story story;

  const NewsCard({super.key, required this.story});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  late BookmarkCubit _favCubit;
  late NewsCubit _newsCubit;

  @override
  void initState() {
    super.initState();
    _favCubit = context.read<BookmarkCubit>();
    _newsCubit = context.read<NewsCubit>();
    setState(() {});
  }

  Future<void> toggleFavorite() async {
    _favCubit.toggleBookMark(widget.story);
    _newsCubit.toggleFavorite(widget.story);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      message: widget.story.title,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return WebViewPage(story: widget.story);
              },
            ),
          );
        },
        child: Card(
          elevation: 1.0,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Wrap(
                          children: [
                            SizedBox(
                              child: Text(
                                widget.story.title,
                                style: context.textTheme.bodyLarge!.copyWith(
                                  fontSize: context.isTablet ? 16 : 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        style: const ButtonStyle(
                            alignment: Alignment.topRight,
                            overlayColor: WidgetStateColor.transparent),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          toggleFavorite();
                        },
                        icon: Icon(
                          widget.story.isBookmark
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined,
                          color: widget.story.isBookmark ? Colors.red : null,
                        ),
                      )
                    ],
                  ),
                  5.vSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'By ${widget.story.by}',

                        style: context.textTheme.headlineSmall!.copyWith(
                          fontSize: 14,
                          // fontWeight: FontWeight.w500,
                        ),
                        // style: context.textTheme.bodyMedium!.copyWith(
                        //   color: context.theme.dividerColor,
                        // ),
                      ),
                      Text(
                        'Score: ${widget.story.score}',
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontSize: 14,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_i/cubit/favNews/fav_cubit.dart';
import 'package:tech_i/cubit/news/news_cubit.dart';
import 'package:tech_i/model/story.dart';
import 'package:tech_i/pages/widgets/in_app_web_view.dart';
import 'package:tech_i/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatefulWidget {
  final Story story;

  const NewsCard({super.key, required this.story});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  late FavCubit _favCubit;
  late NewsCubit _newsCubit;

  @override
  void initState() {
    super.initState();
    _favCubit = context.read<FavCubit>();
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
                return InAppWebViewPage(story: widget.story);
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
                                style: context.textTheme.bodyLarge!
                                    .copyWith(fontSize: 15),
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
                          widget.story.isFav
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined,
                          color: widget.story.isFav ? Colors.red : null,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'By ${widget.story.by}',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.theme.dividerColor,
                        ),
                      ),
                      Text(
                        'Score: ${widget.story.score}',
                        style: context.textTheme.bodyLarge,
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

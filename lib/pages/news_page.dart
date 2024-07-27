import 'package:TechI/cubit/bookmarkNews/bookmark_cubit.dart';
import 'package:TechI/cubit/scrollButton/scroll_button_cubit.dart';
import 'package:TechI/cubit/news/news_cubit.dart';
import 'package:TechI/cubit/news/news_state.dart';
import 'package:TechI/helper/enums.dart';
import 'package:TechI/pages/bookmark_news_page.dart';
import 'package:TechI/pages/widgets/news_list_builder.dart';
import 'package:TechI/pages/widgets/news_tab_builder.dart';
import 'package:TechI/pages/widgets/theme_set_icon_widget.dart';
import 'package:TechI/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TechI/utils/extension/spacer_extension.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().fetchStories();
    init();
  }

  void init() {
    final newsCubit = context.read<NewsCubit>();

    _tabController = TabController(length: NewsType.values.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // debugPrint("NewsType ${NewsType.values[_tabController.index]}");
        newsCubit.setNewsType(NewsType.values[_tabController.index]);
      }
    });
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    newsCubit.fetchStories();
  }

  void _scrollListener() {
    ScrollPosition position = _controller.position;
    final newsCubit = context.read<NewsCubit>();
    final newsState = newsCubit.state;
    final buttonCubit = context.read<ScrollButtonCubit>();

    if (position.pixels == position.maxScrollExtent &&
        newsState is! MoreNewsLoading) {
      newsCubit.setPageCount();
    }
    if (position.pixels == position.minScrollExtent) {
      buttonCubit.setScrollButtonVisibility(false);
    } else if (position.userScrollDirection == ScrollDirection.reverse) {
      buttonCubit.setScrollButtonVisibility(true);
    }
    // else if (position.userScrollDirection == ScrollDirection.forward) {}
  }

  Future<void> _refresh() async {
    await context.read<NewsCubit>().fetchStories();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TechI',
          style: context.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          const ThemeSetIconWidget(),
          10.hSpace,
          Tooltip(
            message: "Bookmark News",
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
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            NewsTabBuilder(tabController: _tabController),
            NewsListBuilder(controller: _controller),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<ScrollButtonCubit, ScrollButtonState>(
        builder: (context, state) {
          return Visibility(
            visible: state is ScrollButtonShow,
            child: FloatingActionButton(
              elevation: 5.0,
              shape: const CircleBorder(),
              onPressed: () {
                setState(
                  () {
                    _controller.animateTo(
                      _controller.position.minScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.keyboard_arrow_up_outlined,
                size: 30,
              ),
            ),
          );
        },
      ),
    );
  }
}

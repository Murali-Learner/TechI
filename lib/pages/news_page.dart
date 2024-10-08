import 'package:TechI/cubit/news/news_cubit.dart';
import 'package:TechI/cubit/news/news_state.dart';
import 'package:TechI/cubit/scrollButton/scroll_button_cubit.dart';
import 'package:TechI/helper/enums.dart';
import 'package:TechI/pages/widgets/bookmarks_icon_widget.dart';
import 'package:TechI/pages/widgets/news_list_builder.dart';
import 'package:TechI/pages/widgets/news_tab_builder.dart';
import 'package:TechI/pages/widgets/theme_set_icon_widget.dart';
import 'package:TechI/utils/extension/context_extension.dart';
import 'package:TechI/utils/extension/spacer_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        newsCubit.setPageSize(context.isMobile ? 12 : 18);
        newsCubit.fetchStories();
      }
    });
  }

  void _scrollListener() {
    ScrollPosition position = _controller.position;
    final newsCubit = context.read<NewsCubit>();
    final newsState = newsCubit.state;
    final buttonCubit = context.read<ScrollButtonCubit>();

    if (position.pixels == position.maxScrollExtent &&
        newsState is! MoreNewsLoading) {
      newsCubit.loadMoreNews();
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
    Size preferredSize = const Size.fromHeight(kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        shadowColor:
            context.theme.appBarTheme.iconTheme!.color!.withOpacity(0.5),
        elevation: 2.0,
        scrolledUnderElevation: 5.0,
        bottom: PreferredSize(
          preferredSize: preferredSize,
          child: NewsTabBuilder(tabController: _tabController),
        ),
        surfaceTintColor: context.theme.scaffoldBackgroundColor,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Text(
          'TechI',
          style: context.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          const ThemeSetIconWidget(),
          10.hSpace,
          const BookmarksIconWidget(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: NewsListBuilder(controller: _controller),
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
                      duration: const Duration(milliseconds: 600),
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

import 'package:TechI/helper/enums.dart';
import 'package:TechI/utils/extension/context_extension.dart';
import 'package:TechI/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';

class NewsTabBuilder extends StatelessWidget {
  const NewsTabBuilder({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: context.theme.scaffoldBackgroundColor,
      indicatorSize: TabBarIndicatorSize.label,
      controller: _tabController,
      tabs: NewsType.values.map((type) {
        return Tab(
          text: type.displayName,
        );
      }).toList(),
    );
  }
}

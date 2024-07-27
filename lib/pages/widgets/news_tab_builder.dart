import 'package:TechI/helper/enums.dart';
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
    return Container(
      color: Colors.green.withOpacity(0.1),
      child: TabBar(
        controller: _tabController,
        tabs: NewsType.values.map((type) {
          return Tab(
            text: type.displayName,
          );
        }).toList(),
      ),
    );
  }
}

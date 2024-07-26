import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_i/cubit/favNews/fav_cubit.dart';
import 'package:tech_i/pages/widgets/news_card.dart';

class FavNewsPage extends StatelessWidget {
  const FavNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite News'),
      ),
      body: BlocBuilder<FavCubit, FavLoaded>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.favStoryList.isEmpty) {
            return const Center(child: Text('No favorite stories yet'));
          }

          return ListView.builder(
            itemCount: state.favStoryList.keys.length,
            itemBuilder: (context, index) {
              final storyMap =
                  state.favStoryList[state.favStoryList.keys.elementAt(index)];
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

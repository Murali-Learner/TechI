import 'package:tech_i/cubit/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: state == ThemeState.dark
                  ? Colors.grey[600]!
                  : Colors.grey[100]!,
              highlightColor: state == ThemeState.dark
                  ? Colors.grey[700]!
                  : Colors.grey[300]!,
              child: Card(
                child: ListTile(
                  title: Container(
                    height: 20.0,
                    color: Colors.white,
                  ),
                  subtitle: Container(
                    height: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

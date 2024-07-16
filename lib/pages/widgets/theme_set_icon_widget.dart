import 'package:tech_i/cubit/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSetIconWidget extends StatelessWidget {
  const ThemeSetIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return IconButton(
          iconSize: 25,
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
          icon: Icon(state != ThemeState.light
              ? Icons.wb_sunny
              : Icons.dark_mode_sharp),
        );
      },
    );
  }
}

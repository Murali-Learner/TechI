import 'package:tech_i/cubit/scrollButton/scroll_button_cubit.dart';
import 'package:tech_i/cubit/news/news_cubit.dart';
import 'package:tech_i/cubit/news/news_state.dart';
import 'package:tech_i/cubit/theme/theme_cubit.dart';
import 'package:tech_i/pages/news_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => ScrollButtonCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeCubit = context.read<ThemeCubit>();
          return MaterialApp(
            title: 'TechI',
            debugShowCheckedModeBanner: false,
            theme: themeCubit.themeData,
            home: BlocBuilder<NewsCubit, NewsState>(
              builder: (context, state) {
                return const NewsPage();
              },
            ),
          );
        },
      ),
    );
  }
}

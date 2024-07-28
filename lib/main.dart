import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:TechI/cubit/bookmarkNews/bookmark_cubit.dart';
import 'package:TechI/cubit/scrollButton/scroll_button_cubit.dart';
import 'package:TechI/cubit/news/news_cubit.dart';
import 'package:TechI/cubit/news/news_state.dart';
import 'package:TechI/cubit/theme/theme_cubit.dart';
import 'package:TechI/helper/hive_helper.dart';
import 'package:TechI/pages/news_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HiveHelper hiveHelper = HiveHelper();
  await hiveHelper.initHive();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit(),
        ),
        BlocProvider(
          create: (context) => BookmarkCubit(),
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

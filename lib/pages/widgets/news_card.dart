import 'package:tech_i/model/story.dart';
import 'package:tech_i/pages/widgets/in_app_web_view.dart';
import 'package:tech_i/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final Story story;

  const NewsCard({super.key, required this.story});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // launchUrl(Uri.parse(story.url));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return InAppWebViewPage(story: story);
            },
          ),
        );
      },
      child: Card(
        elevation: 1.0,
        child: SizedBox(
          height: context.isTablet ? context.height(6) : context.height(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text(
                    story.title,
                    style: context.textTheme.bodyLarge!.copyWith(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    // maxLines: 1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'By ${story.by}',
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: context.theme.dividerColor,
                      ),
                    ),
                    Text(
                      'Score: ${story.score}',
                      style: context.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

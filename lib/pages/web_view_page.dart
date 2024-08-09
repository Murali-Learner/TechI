import 'dart:collection';

import 'package:TechI/cubit/bookmarkNews/bookmark_cubit.dart';
import 'package:TechI/cubit/news/news_cubit.dart';
import 'package:TechI/model/story.dart';
import 'package:TechI/utils/extension/context_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, required this.story});
  final Story story;

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  bool isLoading = true;

  PullToRefreshController? pullToRefreshController;

  String url = "";
  double progress = 0;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isBookmarked = widget.story.isBookmark;
    });
    init();
  }

  Future<void> init() async {
    if (widget.story.url.isNotEmpty) {
      pullToRefreshController = kIsWeb ||
              ![TargetPlatform.iOS, TargetPlatform.android]
                  .contains(defaultTargetPlatform)
          ? null
          : PullToRefreshController(
              settings: PullToRefreshSettings(
                backgroundColor: Colors.green.withOpacity(0.2),
                color: Colors.green,
              ),
              onRefresh: () async {
                if (defaultTargetPlatform == TargetPlatform.android) {
                  webViewController?.reload();
                } else if (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.macOS) {
                  webViewController?.loadUrl(
                      urlRequest:
                          URLRequest(url: await webViewController?.getUrl()));
                }
              },
            );
    }
  }

  Future<void> toggleFavorite() async {
    context.read<BookmarkCubit>().toggleBookMark(widget.story);
    context.read<NewsCubit>().toggleFavorite(widget.story);

    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Wrap(
          children: [
            Text(
              widget.story.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: widget.story.url.isEmpty
            ? null
            : [
                Tooltip(
                  message: "Share",
                  child: IconButton(
                    onPressed: () async {
                      await Share.share(
                        widget.story.url,
                        subject:
                            "Checkout the Latest news on TechI: ${widget.story.title}",
                      );
                    },
                    icon: const Icon(Icons.share),
                  ),
                ),
                Tooltip(
                  message: "Open in Browser",
                  child: IconButton(
                    onPressed: () {
                      launchUrl(Uri.parse(widget.story.url));
                    },
                    icon: const Icon(Icons.open_in_browser),
                  ),
                ),
                Tooltip(
                  message: "Bookmark",
                  child: IconButton(
                      onPressed: () async {
                        await toggleFavorite();
                      },
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border_outlined,
                        color: isBookmarked ? Colors.red : null,
                      )),
                ),
              ],
      ),
      body: widget.story.url.isEmpty
          ? Center(
              child: Text(
                "Invalid URL",
                style: context.textTheme.bodyLarge,
              ),
            )
          : Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(url: WebUri(widget.story.url)),
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialSettings: settings,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) async {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) async {
                    setState(() {
                      isLoading = true;
                      this.url = url.toString();
                    });
                  },
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                      resources: request.resources,
                      action: PermissionResponseAction.GRANT,
                    );
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController?.endRefreshing();

                    setState(() {
                      isLoading = false;
                      this.url = url.toString();
                    });
                  },
                  onReceivedError: (controller, request, error) {
                    pullToRefreshController?.endRefreshing();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, isReload) {
                    setState(() {
                      this.url = url.toString();
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    debugPrint(consoleMessage.toString());
                  },
                ),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: context.theme.primaryColor,
                    ),
                  ),
              ],
            ),
    );
  }
}

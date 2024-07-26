import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_i/cubit/favNews/fav_cubit.dart';
import 'package:tech_i/model/story.dart';
import 'package:tech_i/utils/extension/context_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tech_i/helper/hive_helper.dart';

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({super.key, required this.story});
  final Story story;

  @override
  InAppWebViewPageState createState() => InAppWebViewPageState();
}

class InAppWebViewPageState extends State<InAppWebViewPage> {
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
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFav = widget.story.isFav;
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
                color: Colors.blue,
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
    context.read<FavCubit>().toggleBookMark(widget.story);
    setState(() {
      isFav = !isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.story.isFav);
    if ((widget.story.url.isEmpty)) {
      return Material(
        child: Center(
            child: Text(
          "No URL found",
          style: context.textTheme.bodyLarge,
        )),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.story.title),
          actions: [
            IconButton(
              onPressed: () {
                launchUrl(Uri.parse(widget.story.url));
              },
              icon: const Icon(Icons.open_in_browser),
            ),
            IconButton(
                onPressed: () async {
                  await toggleFavorite();
                },
                icon: Icon(
                  isFav ? Icons.bookmark : Icons.bookmark_border_outlined,
                  color: isFav ? Colors.red : null,
                )),
          ],
        ),
        body: Stack(
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
              shouldOverrideUrlLoading: (controller, navigationAction) async {
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
                  color: context.theme.progressIndicatorTheme.color,
                ),
              ),
          ],
        ),
      );
    }
  }
}

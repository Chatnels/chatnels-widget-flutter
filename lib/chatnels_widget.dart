library chatnels_widget;

import 'package:chatnels_widget/htmlTemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class Chatnels extends StatefulWidget {
  final String orgDomain;
  final String serviceProvider;
  String sessionToken;

  Chatnels(
      {required this.orgDomain,
      required this.sessionToken,
      this.serviceProvider = 'chatnels.com',
      Key? key})
      : super(key: key);

  @override
  State<Chatnels> createState() => _ChatnelsState();
}

class _ChatnelsState extends State<Chatnels> {
  late final WebViewController _controller;

  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('Print',
          onMessageReceived: (JavaScriptMessage message) {})
      ..loadHtmlString(
          htmlTemplate(
              widget.orgDomain, widget.serviceProvider, widget.sessionToken),
          baseUrl: 'chatnels://local.chatnels.com/');

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  void didUpdateWidget(covariant Chatnels oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebViewWidget(
      controller: _controller,
    ));
  }
}

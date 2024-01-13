library chatnels_widget;

import 'dart:convert';

import 'package:chatnels_widget/enums.dart';
import 'package:chatnels_widget/htmlTemplate.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class Chatnels extends StatefulWidget {
  final String orgDomain;
  final String serviceProvider;
  final String sessionToken;
  final Map<String, dynamic> viewData;
  final void Function(String type, Map<String, dynamic> data)? onChatnelsEvent;
  final VoidCallback? onReady;
  final VoidCallback? onRequestSession;
  final VoidCallback? onError;

  const Chatnels(
      {required this.orgDomain,
      required this.sessionToken,
      this.serviceProvider = 'chatnels.com',
      required this.viewData,
      this.onChatnelsEvent,
      this.onReady,
      this.onRequestSession,
      this.onError,
      Key? key})
      : super(key: key);

  @override
  State<Chatnels> createState() => _ChatnelsState();
}

class _ChatnelsState extends State<Chatnels> {
  late String sessionToken;
  late Map<String, dynamic> viewData;
  late void Function(String type, Map<String, dynamic> data)? onChatnelsEvent;
  late VoidCallback? onReady;
  late VoidCallback? onRequestSession;
  late VoidCallback? onError;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    sessionToken = widget.sessionToken;
    viewData = widget.viewData;
    onChatnelsEvent = widget.onChatnelsEvent;
    onReady = widget.onReady;
    onRequestSession = widget.onRequestSession;
    onError = widget.onError;

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
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          debugPrint('Page started loading: $url');
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('''
            Page resource error:
            code: ${error.errorCode}
            description: ${error.description}
            errorType: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
          ''');
        },
      ))
      ..addJavaScriptChannel('ChatnelsWebView',
          onMessageReceived: _onWebViewMessageReceived)
      ..loadHtmlString(
          htmlTemplate(
              widget.orgDomain, widget.serviceProvider, sessionToken, viewData),
          baseUrl: 'chatnels://local.chatnels.com/');
    // ..loadRequest(Uri.parse('https://www.chatnels.com'));

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

    if (widget.sessionToken != oldWidget.sessionToken ||
        widget.onChatnelsEvent != oldWidget.onChatnelsEvent ||
        widget.onReady != oldWidget.onReady ||
        widget.onRequestSession != oldWidget.onRequestSession ||
        widget.onError != oldWidget.onError) {
      setState(() {
        sessionToken = widget.sessionToken;
        onChatnelsEvent = widget.onChatnelsEvent;
        onReady = widget.onReady;
        onRequestSession = widget.onRequestSession;
        onError = widget.onError;
      });

      // check if sessionToken has changed and fire Webview Javascript event
      if (widget.sessionToken != oldWidget.sessionToken) {
        _controller.runJavaScript('''
        if (window.ChatnelsClient) {
            window.ChatnelsClient.updateSessionToken("$sessionToken");
        }
        ''');
      }
      if (widget.viewData != oldWidget.viewData) {
        _injectEmbedData(widget.viewData);
      }
    }
  }

  void _onWebViewMessageReceived(JavaScriptMessage message) {
    try {
      Map<String, dynamic> jsonObj = JsonDecoder().convert(message.message);
      String type = jsonObj['type'];
      Map<String, String> data = jsonObj['data'];

      if (type == InternalChatnelsEvents.APP_READY.name) {
        _injectEmbedData(viewData);
        onReady!();
      } else if (type == InternalChatnelsEvents.LOAD_SCRIPT_ERROR.name) {
        onError!();
      } else if (type == InternalChatnelsEvents.APP_REQUEST_FOCUS.name) {
        // unable to find any request focus method for the webview
      } else if (type == ChatnelsEvents.REAUTH.name) {
        onRequestSession!();
      } else {
        onChatnelsEvent!(type, data);
      }
    } catch (e) {}
  }

  void _injectEmbedData(Map<String, dynamic> viewData) {
    try {
      String type = viewData['type'];
      String data = JsonEncoder().convert(viewData['data']);
      String options = JsonEncoder().convert(viewData['options']);
      String colorScheme = JsonEncoder().convert(viewData['colorScheme']);

      _controller.runJavaScript('''
      if (window.ChatnelsClient) {
        window.ChatnelsClient.showView({
          type: "$type",
          data: $data,
          options: $options,
          colorScheme: $colorScheme,
        });
      }
      ''');
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}

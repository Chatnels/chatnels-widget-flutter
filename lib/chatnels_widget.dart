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
  final Map<String, dynamic>? colorScheme;
  final void Function(String type, Map<String, dynamic> data)? onChatnelsEvent;
  final VoidCallback? onReady;
  final VoidCallback? onRequestSession;
  final VoidCallback? onError;

  const Chatnels(
      {required this.orgDomain,
      required this.sessionToken,
      this.serviceProvider = 'chatnels.com',
      required this.viewData,
      this.colorScheme = const {},
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
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

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
      ..clearCache()
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
          htmlTemplate(widget.orgDomain, widget.serviceProvider,
              widget.sessionToken, widget.viewData),
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
    super.didUpdateWidget(oldWidget);

    if (widget.sessionToken != oldWidget.sessionToken) {
      // check if sessionToken has changed and fire Webview Javascript event
      debugPrint(
          '''session token updated: old token - ${oldWidget.sessionToken}, new token ${widget.sessionToken}''');
      _injectSessionToken(widget.sessionToken);
    }

    if (JsonEncoder().convert(widget.viewData) !=
        JsonEncoder().convert(oldWidget.viewData)) {
      debugPrint(
          '''view Data updated: old view Data - ${oldWidget.viewData}, new token ${widget.viewData}''');
      _injectEmbedData(widget.viewData);
    }
  }

  void updateSessionToken(String sessionToken) {
    _injectSessionToken(sessionToken);
  }

  void updateViewData(Map<String, dynamic> viewData) {
    _injectEmbedData(viewData);
  }

  void _onWebViewMessageReceived(JavaScriptMessage message) {
    try {
      Map<String, dynamic> jsonObj = JsonDecoder().convert(message.message);
      dynamic type = jsonObj['type'];
      dynamic data = jsonObj['data'];

      if (type == InternalChatnelsEvents.APP_READY.name) {
        debugPrint('''Chatnels widget App Ready''');
        _injectEmbedData(widget.viewData);
        widget.onReady!();
      } else if (type == InternalChatnelsEvents.LOAD_SCRIPT_ERROR.name) {
        debugPrint('''Chatnels widget onError''');
        widget.onError!();
      } else if (type == InternalChatnelsEvents.APP_REQUEST_FOCUS.name) {
        // unable to find any request focus method for the webview
      } else if (type == ChatnelsEvents.REAUTH.name) {
        debugPrint('''Chatnels widget onRequestSession''');
        widget.onRequestSession!();
      } else {
        debugPrint(
            '''Chatnels widget onChatnelsEvent - type: $type - data: $data ''');
        widget.onChatnelsEvent!(type, data);
      }
    } catch (e) {
      debugPrint('''
      Error in parsing Chatnels webview message:
      $e
      ''');
    }
  }

  void _injectEmbedData(
      Map<String, dynamic> viewData) {
    try {
      String type = viewData['type'];
      String data = JsonEncoder().convert(viewData['data']);
      String options = JsonEncoder().convert(viewData['options']);

      _controller.runJavaScript('''
      if (window.ChatnelsClient) {
        window.ChatnelsClient.showView({
          type: "$type",
          data: $data,
          options: $options,
        });
        window.ChatnelsClient.setColorScheme(${JsonEncoder().convert(widget.colorScheme)});
      }
      ''');
    } catch (e) {}
  }

  void _injectSessionToken(String sessionToken) {
    _controller.runJavaScript('''
        if (window.ChatnelsClient) {
            window.ChatnelsClient.updateSessionToken("$sessionToken");
        }
        ''');
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}

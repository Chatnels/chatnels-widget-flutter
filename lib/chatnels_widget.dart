library chatnels_widget;

import 'dart:convert';
import 'package:chatnels_widget/enums.dart';
import 'package:chatnels_widget/html_template.dart';
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
  final List<String>? additionalEvents;
  final void Function(String type, Map<String, dynamic> data)? onChatnelsEvent;
  final VoidCallback? onReady;
  final VoidCallback? onRequestSession;
  final VoidCallback? onError;
  final bool inspectable;

  const Chatnels(
      {required this.orgDomain,
      required this.sessionToken,
      this.serviceProvider = 'chatnels.com',
      required this.viewData,
      this.colorScheme = const {},
      this.additionalEvents = const [],
      this.onChatnelsEvent,
      this.onReady,
      this.onRequestSession,
      this.onError,
      this.inspectable = false,
      Key? key})
      : super(key: key);

  @override
  State<Chatnels> createState() => ChatnelsState();
}

class ChatnelsState extends State<Chatnels> {
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
        onNavigationRequest: (NavigationRequest request) {
          debugPrint('onNavigationRequest: ${request.url}');
          if (request.url == 'chatnels://local.chatnels.com/' ||
              request.url == 'about:blank') {
            return NavigationDecision.navigate;
          }

          widget.onChatnelsEvent!(
              ChatnelsEvents.EXTERNAL_URL.name, {'url': request.url});

          return NavigationDecision.prevent;
        },
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
      AndroidWebViewController.enableDebugging(widget.inspectable);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    } else if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController)
          .setInspectable(widget.inspectable);
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

    if (const JsonEncoder().convert(widget.viewData) !=
        const JsonEncoder().convert(oldWidget.viewData)) {
      debugPrint(
          '''view Data updated: old view Data - ${oldWidget.viewData}, new view Data ${widget.viewData}''');
      _injectEmbedData(widget.viewData);
    }
  }

  void sendChatMessage(String chatUUID, String message) {
    _injectChatMessageData(chatUUID, message);
  }

  void updateSessionToken(String sessionToken) {
    _injectSessionToken(sessionToken);
  }

  void updateViewData(Map<String, dynamic> viewData) {
    _injectEmbedData(viewData);
  }

  void _onWebViewMessageReceived(JavaScriptMessage message) {
    try {
      Map<String, dynamic> jsonObj =
          const JsonDecoder().convert(message.message);
      dynamic type = jsonObj['type'];
      dynamic data = jsonObj['data'];

      if (type == InternalChatnelsEvents.APP_READY.name) {
        debugPrint('''Chatnels widget App Ready''');
        _injectEmbedData(widget.viewData);
        widget.onReady!();
      } else if (type == InternalChatnelsEvents.LOAD_SCRIPT_ERROR.name) {
        debugPrint('''
        Chatnels widget onLoadScriptError
        $jsonObj
        ''');
        widget.onError!();
      } else if (type == InternalChatnelsEvents.APP_REQUEST_FOCUS.name) {
        // unable to find any request focus method for the webview
      } else if (type == ChatnelsEvents.REAUTH.name) {
        debugPrint('''Chatnels widget onRequestSession''');
        widget.onRequestSession!();
      } else {
        debugPrint(
            '''Chatnels widget trigger onChatnelsEvent - type: $type - data: $data ''');
        widget.onChatnelsEvent!(type, data);
      }
    } catch (e) {
      debugPrint('''
      Error in parsing Chatnels webview message:
      $e
      ${message.message}
      ''');
    }
  }

  void _injectEmbedData(Map<String, dynamic> viewData) {
    try {
      String type = viewData['type'];
      String data = const JsonEncoder().convert(viewData['data']);
      String options = const JsonEncoder().convert(viewData['options']);

      _controller.runJavaScript('''
      if (window.ChatnelsClient) {
        window.ChatnelsClient.showView({
          type: "$type",
          data: $data,
          options: $options,
        });
        window.ChatnelsClient.setColorScheme(${const JsonEncoder().convert(widget.colorScheme)});
        window.ChatnelsClient.additionalEvents = ${const JsonEncoder().convert(widget.additionalEvents)};
      }
      ''');
    } catch (e) {}
  }

  void _injectChatMessageData(String chatUUID, String message) {
    _controller.runJavaScript('''
      if (window.ChatnelsClient && window.ChatnelsClient.sendChatMessage) {
        window.ChatnelsClient.sendChatMessage($chatUUID, $message);
      }
    ''');
  }

  void _injectSessionToken(String sessionToken) {
    _controller.runJavaScript('''
        if (window.ChatnelsClient && window.ChatnelsClient.updateSessionToken) {
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

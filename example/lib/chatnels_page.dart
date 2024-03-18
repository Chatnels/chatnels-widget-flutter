import 'package:chatnels_widget/enums.dart';
import 'package:flutter/material.dart';
import 'package:chatnels_widget/chatnels_widget.dart';

class ChatnelsPage extends StatefulWidget {
  final String? serviceProvider;
  final String? orgDomain;
  final String? sessionToken;
  final String? displayUUID;
  final String? chatUUID;
  final VoidCallback? onBack;

  const ChatnelsPage({
    this.serviceProvider,
    this.orgDomain,
    this.sessionToken,
    this.displayUUID,
    this.chatUUID,
    this.onBack,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatnelsPage> createState() => _ChatnelsPageState();
}

class _ChatnelsPageState extends State<ChatnelsPage>
    with AutomaticKeepAliveClientMixin<ChatnelsPage> {
  final TextEditingController _serviceProviderInputCtrl =
      TextEditingController(text: '');
  final TextEditingController _orgDoaminInputCtrl =
      TextEditingController(text: '');
  final TextEditingController _sessionTokenInputCtrl =
      TextEditingController(text: '');
  final TextEditingController _displayIdInputCtrl =
      TextEditingController(text: '');
  final TextEditingController _chatIdInputCtrl =
      TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _serviceProviderInputCtrl.text = widget.serviceProvider ?? '';
    _orgDoaminInputCtrl.text = widget.orgDomain ?? '';
    _sessionTokenInputCtrl.text = widget.sessionToken ?? '';
    _displayIdInputCtrl.text = widget.displayUUID ?? '';
    _chatIdInputCtrl.text = widget.chatUUID ?? '';
  }

  void _showDialog() {
    _displayIdInputCtrl.text = widget.displayUUID ?? '';

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              scrollable: true,
              content: Stack(children: [
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _serviceProviderInputCtrl,
                            decoration: const InputDecoration(
                                labelText: 'Service Provider'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _orgDoaminInputCtrl,
                            decoration:
                                const InputDecoration(labelText: 'Domain'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _sessionTokenInputCtrl,
                            decoration: const InputDecoration(
                                labelText: 'Session Token'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _displayIdInputCtrl,
                            decoration:
                                const InputDecoration(labelText: 'Display Id'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _chatIdInputCtrl,
                            decoration:
                                const InputDecoration(labelText: 'Chat Id'),
                          ),
                        )
                      ],
                    )),
              ]),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        debugPrint('''
                          serviceProvider: ${_serviceProviderInputCtrl.text}
                          orgDomain: ${_orgDoaminInputCtrl.text}
                          sessionToken: ${_sessionTokenInputCtrl.text}
                          displayId: ${_displayIdInputCtrl.text}
                          chatId: ${_chatIdInputCtrl.text}
                        ''');
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Submit'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => widget.onBack!(),
          ),
          title: const Text('Chatnels chat'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Builder(builder: (BuildContext context) {
            if (_orgDoaminInputCtrl.text.isNotEmpty &&
                _sessionTokenInputCtrl.text.isNotEmpty) {
              return Chatnels(
                serviceProvider: _serviceProviderInputCtrl.text,
                orgDomain: _orgDoaminInputCtrl.text,
                sessionToken: _sessionTokenInputCtrl.text,
                viewData: {
                  'type': 'chat',
                  'data': {
                    if (widget.displayUUID!.isNotEmpty)
                      'displayId': widget.displayUUID,
                    if (_chatIdInputCtrl.text.isNotEmpty)
                      'chatId': _chatIdInputCtrl.text
                  },
                },
                colorScheme: {
                  ChatnelsColorSchema.chatTheme.name: 'ios',
                  ChatnelsColorSchema.chatFont.name: 'Poppins',
                  ChatnelsColorSchema.chatTextSize.name: '16px',
                  ChatnelsColorSchema.chatInboundBgColor.name: '245 245 245',
                  ChatnelsColorSchema.chatInboundTextColor.name: '0 0 0',
                  ChatnelsColorSchema.chatOutboundBgColor.name: '67 133 245',
                  ChatnelsColorSchema.chatOutboundLinkTextColor.name:
                      '255 255 255',
                  ChatnelsColorSchema.chatOutboundTextColor.name: '255 255 255',
                  ChatnelsColorSchema.chatDateDividerBgOpacity.name: 0,
                },
                additionalEvents: [
                  ChatnelsEvents.CHAT_MESSAGE.name,
                  ChatnelsEvents.CHAT_MESSAGE_OUTBOUND.name,
                  ChatnelsEvents.CHAT_MESSAGE_INBOUND.name
                ],
                onReady: () {
                  debugPrint('''
                        Chatnels is READY!!!
                      ''');
                },
                onRequestSession: () {
                  _showDialog();
                },
                onChatnelsEvent: (type, data) {
                  debugPrint('''
                      onChatnelsEvent:
                      type: $type:
                      data: $data
                      ''');
                  if (type == ChatnelsEvents.CHAT_ACTION.name) {
                    // handle chat cmd action here
                    debugPrint('''This is action prompt
                          type: $type
                          data: $data
                        ''');
                  } else if (type == ChatnelsEvents.EXTERNAL_URL.name) {
                    // use url_launcher package
                    // !await launchUrlString(data.url, mode: LaunchMode.inAppBrowserView);
                  } else if (type == ChatnelsEvents.CHAT_MESSAGE_INBOUND.name) {
                    debugPrint('''This is inbound message prompt
                          type: $type
                          data: $data
                        ''');
                  } else if (type ==
                      ChatnelsEvents.CHAT_MESSAGE_OUTBOUND.name) {
                    debugPrint('''This is outbound message prompt
                          type: $type
                          data: $data
                        ''');
                  }
                },
              );
            }

            return Container();
          }),
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          tooltip: 'Chat Setting',
          onPressed: () {
            _showDialog();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop);
  }
}

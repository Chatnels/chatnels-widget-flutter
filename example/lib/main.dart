import 'package:chatnels_widget/enums.dart';
import 'package:flutter/material.dart';
import 'package:chatnels_widget/chatnels_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatnels Widget Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatnelsHomePage(title: 'Chatnels Demo Home Page'),
    );
  }
}

class ChatnelsHomePage extends StatefulWidget {
  const ChatnelsHomePage({super.key, required this.title});
  final String title;

  @override
  State<ChatnelsHomePage> createState() => _ChatnelsHomePageState();
}

class _ChatnelsHomePageState extends State<ChatnelsHomePage> {
  final ValueNotifier<Map<String, dynamic>> sessionTokenNotifier =
      ValueNotifier<Map<String, dynamic>>({
    'serviceProvider': 'dev.chatnels.com',
    'orgDomain': 'thrivingdemo',
    'sessionToken': '1vf7l0air6t6pv3dt26vr7j2lj',
    'displayId': '',
    'chatId': ''
  });

  final TextEditingController _serviceProviderInputCtrl =
      TextEditingController(text: 'dev.chatnels.com');
  final TextEditingController _orgDoaminInputCtrl =
      TextEditingController(text: 'thrivingdemo');
  final TextEditingController _sessionTokenInputCtrl =
      TextEditingController(text: '1vf7l0air6t6pv3dt26vr7j2lj');
  final TextEditingController _displayIdInputCtrl =
      TextEditingController(text: '8128e344c6971c2a338699dfb3b70b5b');
  final TextEditingController _chatIdInputCtrl =
      TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  void _showDialog() {
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
                        sessionTokenNotifier.value = {
                          'serviceProvider': _serviceProviderInputCtrl.text,
                          'orgDomain': _orgDoaminInputCtrl.text,
                          'sessionToken': _sessionTokenInputCtrl.text,
                          'displayId': _displayIdInputCtrl.text,
                          'chatId': _chatIdInputCtrl.text
                        };
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
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: ValueListenableBuilder(
              valueListenable: sessionTokenNotifier,
              builder: (context, value, child) {
                if (value['orgDomain'].length > 0 &&
                    value['sessionToken'].length > 0) {
                  return Chatnels(
                    serviceProvider: value['serviceProvider'],
                    orgDomain: value['orgDomain'],
                    sessionToken: value['sessionToken'],
                    viewData: {
                      'type': 'chat',
                      'data': {
                        if (value['displayId'].length > 0)
                          'displayId': value['displayId'],
                        if (value['chatId'].length > 0)
                          'chatId': value['chatId']
                      },
                    },
                    colorScheme: {
                      ChatnelsColorSchema.chatTheme.name: 'ios',
                      ChatnelsColorSchema.chatFont.name: 'Poppins',
                      ChatnelsColorSchema.chatTextSize.name: '16px',
                      ChatnelsColorSchema.chatInboundBgColor.name:
                          '245 245 245',
                      ChatnelsColorSchema.chatInboundTextColor.name: '0 0 0',
                      ChatnelsColorSchema.chatOutboundBgColor.name:
                          '67 133 245',
                      ChatnelsColorSchema.chatOutboundLinkTextColor.name:
                          '255 255 255',
                      ChatnelsColorSchema.chatOutboundTextColor.name:
                          '255 255 255',
                      ChatnelsColorSchema.chatDateDividerBgOpacity.name: 0,
                    },
                    onReady: () {},
                    onRequestSession: () {
                      _showDialog();
                    },
                    onChatnelsEvent: (type, data) {
                      debugPrint('''
                      chat action $type:
                      data: $data
                      ''');
                      if (type == ChatnelsEvents.CHAT_ACTION.name) {
                        // handle chat cmd action here
                      } else if (type == ChatnelsEvents.EXTERNAL_URL.name) {
                        // use url_launcher package
                        // !await launchUrlString(data.url, mode: LaunchMode.inAppBrowserView);
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

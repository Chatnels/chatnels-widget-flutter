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
    'serviceProvider': 'chatnels.com',
    'orgDomain': '',
    'sessionToken': '',
    'displayId': '',
    'chatId': ''
  });

  final TextEditingController _serviceProviderInputCtrl =
      TextEditingController(text: 'chatnels.com');
  final TextEditingController _orgDoaminInputCtrl =
      TextEditingController(text: '');
  final TextEditingController _sessionTokenInputCtrl =
      TextEditingController(text: '');
  final TextEditingController _displayIdInputCtrl =
      TextEditingController(text: '');
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
        body: ValueListenableBuilder(
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
                      if (value['chatId'].length > 0) 'chatId': value['chatId']
                    },
                  },
                  colorScheme: const {
                    'chatTheme': 'ios',
                    'chatInBoundBgColor': '245 245 245',
                    'chatInBoundTextColor': '0 0 0',
                    'chatOutBoundBgColor': '67 133 245',
                    'chatOutBoundTextColor': '255 255 255',
                    'chatDateDividerBgColor': '206 206 206',
                    'chatDateDividerBgOpacity': 0,
                  },
                  onReady: () {
                  },
                  onRequestSession: () {
                    _showDialog();
                  },
                  onChatnelsEvent: (type, data) {
                    if (type == ChatnelsEvents.CHAT_ACTION.name) {
                      // handle chat cmd action here
                      debugPrint('''
                      chat action $type:
                      data: $data
                      ''');
                    }
                  },
                );
              }

              return Container();
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop);
  }
}

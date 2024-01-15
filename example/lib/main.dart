import 'package:flutter/material.dart';
import 'package:chatnels_widget/chatnels_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatnels Widget Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatnelsHomePage(title: 'Chatnels Demo Home Page'),
    );
  }
}

class ChatnelsHomePage extends StatefulWidget {
  const ChatnelsHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ChatnelsHomePage> createState() => _ChatnelsHomePageState();
}

class _ChatnelsHomePageState extends State<ChatnelsHomePage> {
  final ValueNotifier<Map<String, dynamic>> sessionTokenNotifier =
      ValueNotifier<Map<String, dynamic>>({
    'orgDomain': 'want2vancouver',
    'sessionToken': '5slm7360jeptid9umjc6lo4t52',
    'displayId': '911852ec783a4aa4169c97834da40d60',
    'chatId': ''
  });

  final TextEditingController _orgDoaminInputCtrl =
      TextEditingController(text: 'want2vancouver');
  final TextEditingController _sessionTokenInputCtrl =
      TextEditingController(text: '5slm7360jeptid9umjc6lo4t52');
  final TextEditingController _displayIdInputCtrl =
      TextEditingController(text: '911852ec783a4aa4169c97834da40d60');
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
                          orgDomain: ${_orgDoaminInputCtrl.text}
                          sessionToken: ${_sessionTokenInputCtrl.text}
                          displayId: ${_displayIdInputCtrl.text}
                          chatId: ${_chatIdInputCtrl.text}
                        ''');
                        sessionTokenNotifier.value = {
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: sessionTokenNotifier,
            builder: (context, value, child) {
              return Chatnels(
                orgDomain: value['orgDomain'],
                sessionToken: value['sessionToken'],
                viewData: {
                  'type': 'chat',
                  'data': {
                    if (value['displayId'].length > 0)
                      'displayId': value['displayId'],
                    if (value['chatId'].length > 0) 'chatId': value['chatId']
                  },
                  'colorScheme': const {
                    'navbarColor': '#356b5c',
                    'navbarFontColor': 'white',
                  },
                },
                onRequestSession: () {
                  _showDialog();
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop);
  }
}

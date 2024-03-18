import 'package:example/chatnels_page.dart';
import 'package:example/home_page.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final String serviceProvider = 'dev.chatnels.com';
  final String orgDomain = 'thriving';
  final String sessionToken = 'nisn71po8qmr6mu6j5lppfv2pk';
  String displayUUID = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: IndexedStack(
        index: currentIndex,
        children: [
          HomePage(
            onPageChange: () {
              setState(() {
                displayUUID = '4f551f153ed319eae571048863b7d7ab';
                currentIndex = 1;
              });
            },
          ),
          ChatnelsPage(
            serviceProvider: serviceProvider,
            orgDomain: orgDomain,
            sessionToken: sessionToken,
            displayUUID: displayUUID,
            onBack: () {
              setState(() {
                displayUUID = '';
                currentIndex = 0;
              });
            },
          )
        ],
      )),
    );
  }
}

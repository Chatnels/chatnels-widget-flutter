import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final void Function(String sessionToken)? onServiceProiderChange;
  final void Function(String sessionToken)? onOrgDomainChange;
  final void Function(String sessionToken)? onSessionTokenChange;
  final void Function(String sessionToken)? onDisplayUUIDChange;
  final VoidCallback? onPageChange;

  const HomePage({
    Key? key,
    this.onServiceProiderChange,
    this.onOrgDomainChange,
    this.onSessionTokenChange,
    this.onDisplayUUIDChange,
    this.onPageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            onPressed: () {
              onPageChange!();
            },
            child: const Text('Chat'))
      ]),
    );
  }
}

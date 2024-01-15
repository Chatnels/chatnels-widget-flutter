Make sure you have a valid orgDomain and session token first before initialize the widget.

starting a new chat by padding displayId only.
going into a specific chat by passing both displayId and chatId.

```dart
Map<String, dynamic> viewData = {
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
};
```
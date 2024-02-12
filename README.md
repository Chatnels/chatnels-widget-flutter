Make sure you have a valid orgDomain and session token first before initialize the widget.

- starting a new chat by adding displayId only.
- going into a specific chat by passing both displayId and chatId.



| Name             | Type                                              | Default        | Description                                             |
|------------------|---------------------------------------------------|----------------|---------------------------------------------------------|
| serviceProvider  | String                                            | 'chatnels.com' | Connect to different env domain                         |
| orgDomain        | String                                            |                | The organization domain name                            |
| sessionToken     | String                                            |                | session token for accessing Chatnels service            |
| viewData         | Map<String, dynamic>                              |                | config for showing specific view                        |
| colorScheme      | Map<String, dynamic>                              |                | config for view's colours                               |
| onReady          | VoidCallback?                                     |                | callback for Chatnels is loaded and ready to use        |
| onRequestSession | VoidCallback?                                     |                | callback for requesting a new session                   |
| onChatnelsEvents | Function(String type, Map<String, dynamic> data)? |                | callback for event data that will be passing to the app |
| onError          | VoidCallback?                                     |                | callback for webview error                              |

### viewData Map<String, dynamic> structure

```dart
Map<String, dynamic> viewData = {
  'type': 'chat',
  'data': {
    if (value['displayId'].length > 0)
      'displayId': value['displayId'],
    if (value['chatId'].length > 0) 'chatId': value['chatId']
  },
};
```

Example code will be in the example folder
```
body: Chatnels(
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
 onRequestSession: () {
  // your code to request new Chatnels session token from your server
 },
)
```

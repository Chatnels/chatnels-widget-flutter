enum ChatnelsEvents {
  CHAT_ACTION,
  CHAT_CLOSED,
  EXTERNAL_URL,
  INBOX_BACK,
  INBOX_ITEM_CLICKED,
  REAUTH,
  THREADS_BACK,
  USER_PROFILE_CLICK,
}

extension ChatnelsEventsExtension on ChatnelsEvents {
  String get name {
    switch (this) {
      case ChatnelsEvents.CHAT_ACTION:
        return 'chat:action';
      case ChatnelsEvents.CHAT_CLOSED:
        return 'chat:closed';
      case ChatnelsEvents.EXTERNAL_URL:
        return 'external:url';
      case ChatnelsEvents.INBOX_BACK:
        return 'inbox:back';
      case ChatnelsEvents.INBOX_ITEM_CLICKED:
        return 'inbox:item:clicked';
      case ChatnelsEvents.REAUTH:
        return 'reAuth';
      case ChatnelsEvents.THREADS_BACK:
        return 'threads:back';
      case ChatnelsEvents.USER_PROFILE_CLICK:
        return 'user:profile:click';
      default:
        return '';
    }
  }
}

enum InternalChatnelsEvents {
  LOAD_SCRIPT_ERROR,
  APP_READY,
  APP_REQUEST_FOCUS,
}

extension InternalChatnelsEventsExtension on InternalChatnelsEvents {
  String get name {
    switch (this) {
      case InternalChatnelsEvents.LOAD_SCRIPT_ERROR:
        return 'loadScriptError';
      case InternalChatnelsEvents.APP_READY:
        return 'app:ready';
      case InternalChatnelsEvents.APP_REQUEST_FOCUS:
        return 'app:request:focus';
      default:
        return '';
    }
  }
}

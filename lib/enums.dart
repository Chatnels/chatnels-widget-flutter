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

enum ChatnelsColorSchema {
  chatFont,
  chatTextSize,
  chatActionNextBtnBgColor,
  chatActionNextBtnBorderColor,
  chatActionNextBtnTextColor,
  chatDateDividerBgColor,
  chatDateDividerBgOpacity,
  chatInBoundBgColor,
  chatInBoundBgOpacity,
  chatInBoundLinkTextColor,
  chatInBoundMentionTextColor,
  chatInBoundTextColor,
  chatSelectionBtnBgColor,
  chatSelectionBtnBorderColor,
  chatSelectionBtnTextColor,
  chatSelectionBtnBgColorSelected,
  chatSelectionBtnBorderColorSelected,
  chatSelectionBtnTextColorSelected,
  chatOutBoundBgColor,
  chatOutBoundBgOpacity,
  chatOutBoundLinkTextColor,
  chatOutBoundMentionTextColor,
  chatOutBoundTextColor,
}

extension ChatnelsColorSchemaExtension on ChatnelsColorSchema {
  String get name {
    switch (this) {
      case ChatnelsColorSchema.chatFont:
        return 'chatFont';
      case ChatnelsColorSchema.chatTextSize:
        return 'chatTextSize';
      case ChatnelsColorSchema.chatActionNextBtnBgColor:
        return 'chatActionNextBtnBgColor';
      case ChatnelsColorSchema.chatActionNextBtnBorderColor:
        return 'chatActionNextBtnBorderColor';
      case ChatnelsColorSchema.chatActionNextBtnTextColor:
        return 'chatActionNextBtnTextColor';
      case ChatnelsColorSchema.chatDateDividerBgColor:
        return 'chatDateDividerBgColor';
      case ChatnelsColorSchema.chatDateDividerBgOpacity:
        return 'chatDateDividerBgOpacity';
      case ChatnelsColorSchema.chatInBoundBgColor:
        return 'chatInBoundBgColor';
      case ChatnelsColorSchema.chatInBoundBgOpacity:
        return 'chatInBoundBgOpacity';
      case ChatnelsColorSchema.chatInBoundLinkTextColor:
        return 'chatInBoundLinkTextColor';
      case ChatnelsColorSchema.chatInBoundMentionTextColor:
        return 'chatInBoundMentionTextColor';
      case ChatnelsColorSchema.chatInBoundTextColor:
        return 'chatInBoundTextColor';
      case ChatnelsColorSchema.chatSelectionBtnBgColor:
        return 'chatSelectionBtnBgColor';
      case ChatnelsColorSchema.chatSelectionBtnBorderColor:
        return 'chatSelectionBtnBorderColor';
      case ChatnelsColorSchema.chatSelectionBtnTextColor:
        return 'chatSelectionBtnTextColor';
      case ChatnelsColorSchema.chatSelectionBtnBgColorSelected:
        return 'chatSelectionBtnBgColorSelected';
      case ChatnelsColorSchema.chatSelectionBtnBorderColorSelected:
        return 'chatSelectionBtnBorderColorSelected';
      case ChatnelsColorSchema.chatSelectionBtnTextColorSelected:
        return 'chatSelectionBtnTextColorSelected';
      case ChatnelsColorSchema.chatOutBoundBgColor:
        return 'chatOutBoundBgColor';
      case ChatnelsColorSchema.chatOutBoundBgOpacity:
        return 'chatOutBoundBgOpacity';
      case ChatnelsColorSchema.chatOutBoundLinkTextColor:
        return 'chatOutBoundLinkTextColor';
      case ChatnelsColorSchema.chatOutBoundMentionTextColor:
        return 'chatOutBoundMentionTextColor';
      case ChatnelsColorSchema.chatOutBoundTextColor:
        return 'chatOutBoundTextColor';
      default:
        return '';
    }
  }
}

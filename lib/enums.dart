enum ChatnelsEvents {
  CHAT_ACTION,
  CHAT_CLOSED,
  CHAT_CREATED,
  CHAT_MESSAGE,
  CHAT_MESSAGE_INBOUND,
  CHAT_MESSAGE_OUTBOUND,
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
      case ChatnelsEvents.CHAT_CREATED:
        return 'chat:created';
      case ChatnelsEvents.CHAT_MESSAGE:
        return 'chat:message';
      case ChatnelsEvents.CHAT_MESSAGE_INBOUND:
        return 'chat:message:inbound';
      case ChatnelsEvents.CHAT_MESSAGE_OUTBOUND:
        return 'chat:message:outbound';
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
  chatTheme,
  chatFont,
  chatTextSize,
  chatActionNextBtnBgColor,
  chatActionNextBtnBorderColor,
  chatActionNextBtnTextColor,
  chatDateDividerBgColor,
  chatDateDividerBgOpacity,
  chatInboundBgColor,
  chatInboundBgOpacity,
  chatInboundLinkTextColor,
  chatInboundMentionTextColor,
  chatInboundTextColor,
  chatSelectionBtnBgColor,
  chatSelectionBtnBorderColor,
  chatSelectionBtnTextColor,
  chatSelectionBtnBgColorSelected,
  chatSelectionBtnBorderColorSelected,
  chatSelectionBtnTextColorSelected,
  chatOutboundBgColor,
  chatOutboundBgOpacity,
  chatOutboundLinkTextColor,
  chatOutboundMentionTextColor,
  chatOutboundTextColor,
}

extension ChatnelsColorSchemaExtension on ChatnelsColorSchema {
  String get name {
    switch (this) {
      case ChatnelsColorSchema.chatTheme:
        return 'chatTheme';
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
      case ChatnelsColorSchema.chatInboundBgColor:
        return 'chatInboundBgColor';
      case ChatnelsColorSchema.chatInboundBgOpacity:
        return 'chatInboundBgOpacity';
      case ChatnelsColorSchema.chatInboundLinkTextColor:
        return 'chatInboundLinkTextColor';
      case ChatnelsColorSchema.chatInboundMentionTextColor:
        return 'chatInboundMentionTextColor';
      case ChatnelsColorSchema.chatInboundTextColor:
        return 'chatInboundTextColor';
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
      case ChatnelsColorSchema.chatOutboundBgColor:
        return 'chatOutboundBgColor';
      case ChatnelsColorSchema.chatOutboundBgOpacity:
        return 'chatOutboundBgOpacity';
      case ChatnelsColorSchema.chatOutboundLinkTextColor:
        return 'chatOutboundLinkTextColor';
      case ChatnelsColorSchema.chatOutboundMentionTextColor:
        return 'chatOutboundMentionTextColor';
      case ChatnelsColorSchema.chatOutboundTextColor:
        return 'chatOutboundTextColor';
      default:
        return '';
    }
  }
}

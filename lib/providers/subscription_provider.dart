import 'package:flutter/foundation.dart';

class SubscriptionProvider extends ChangeNotifier {
  bool _isPremium = false;
  int _freeChatUsed = 0;
  static const int freeChatLimit = 3;

  bool get isPremium => _isPremium;
  int get freeChatUsed => _freeChatUsed;
  int get freeChatsLeft => (freeChatLimit - _freeChatUsed).clamp(0, freeChatLimit);
  bool get isChatLocked => !_isPremium && _freeChatUsed >= freeChatLimit;

  void activatePremium() {
    if (_isPremium) return;
    _isPremium = true;
    notifyListeners();
  }

  bool consumeFreeChat() {
    if (_isPremium) return true;
    if (_freeChatUsed >= freeChatLimit) return false;
    _freeChatUsed++;
    notifyListeners();
    return true;
  }
}

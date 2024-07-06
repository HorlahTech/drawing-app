// / Singleton class to manage active popups
import 'package:flutter/material.dart';

class PopupManager {
  static final PopupManager _instance = PopupManager._internal();

  factory PopupManager() {
    return _instance;
  }

  PopupManager._internal();

  final List<OverlayEntry> _activePopups = [];

  void addPopup(OverlayEntry entry) {
    _activePopups.add(entry);
  }

  void removePopup(OverlayEntry entry) {
    _activePopups.remove(entry);
  }

  void hideAllPopups() {
    for (final popup in _activePopups) {
      popup.remove();
    }
    _activePopups.clear();
  }
}

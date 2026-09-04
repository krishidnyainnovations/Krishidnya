import 'dart:convert';

import 'package:cropdoc/core/storage/preferences_service.dart';

/// Persists chat conversation history locally.
class ChatHistoryService {
  ChatHistoryService(this._prefs);

  final PreferencesService _prefs;
  static const _key = 'chat_history';

  List<Map<String, String>> load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
  }

  Future<void> save(List<Map<String, String>> history) async {
    await _prefs.setString(_key, jsonEncode(history));
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}

/// Locale preference storage.
class LocalePreferences {
  LocalePreferences(this._prefs);

  final PreferencesService _prefs;
  static const _key = 'app_locale';

  String? getLocaleCode() => _prefs.getString(_key);

  Future<void> setLocaleCode(String code) async {
    await _prefs.setString(_key, code);
  }
}

/// Mandi price favorites and recent searches.
class MandiPreferences {
  MandiPreferences(this._prefs);

  final PreferencesService _prefs;
  static const _favoritesKey = 'mandi_favorites';
  static const _recentKey = 'mandi_recent';

  List<String> getFavorites() {
    final raw = _prefs.getString(_favoritesKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>).cast<String>();
  }

  Future<void> addFavorite(String crop) async {
    final favorites = getFavorites();
    if (!favorites.contains(crop)) {
      favorites.insert(0, crop);
      await _prefs.setString(_favoritesKey, jsonEncode(favorites.take(10).toList()));
    }
  }

  List<String> getRecent() {
    final raw = _prefs.getString(_recentKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>).cast<String>();
  }

  Future<void> addRecent(String crop) async {
    final recent = getRecent()..remove(crop);
    recent.insert(0, crop);
    await _prefs.setString(_recentKey, jsonEncode(recent.take(8).toList()));
  }
}

/// Tracks locally read notification IDs.
class NotificationPreferences {
  NotificationPreferences(this._prefs);

  final PreferencesService _prefs;
  static const _readKey = 'notification_read_ids';

  Set<String> getReadIds() {
    final raw = _prefs.getString(_readKey);
    if (raw == null) return {};
    return (jsonDecode(raw) as List<dynamic>).cast<String>().toSet();
  }

  Future<void> markAsRead(String id) async {
    final ids = getReadIds()..add(id);
    await _prefs.setString(_readKey, jsonEncode(ids.toList()));
  }

  Future<void> markAllAsRead(List<String> ids) async {
    final read = getReadIds()..addAll(ids);
    await _prefs.setString(_readKey, jsonEncode(read.toList()));
  }
}

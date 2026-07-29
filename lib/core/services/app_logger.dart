import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Log severity levels for monitoring.
enum LogLevel { debug, info, warning, error, api }

/// A single monitored log entry.
class LogEntry {
  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
    this.details,
    this.stackTrace,
  });

  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;
  final String? details;
  final StackTrace? stackTrace;

  String get formattedTime =>
      '${timestamp.hour.toString().padLeft(2, '0')}:'
      '${timestamp.minute.toString().padLeft(2, '0')}:'
      '${timestamp.second.toString().padLeft(2, '0')}.'
      '${timestamp.millisecond.toString().padLeft(3, '0')}';

  @override
  String toString() {
    final buffer = StringBuffer('[$formattedTime] [${level.name.toUpperCase()}] [$tag] $message');
    if (details != null && details!.isNotEmpty) {
      buffer.write('\n  ↳ $details');
    }
    return buffer.toString();
  }
}

/// Centralized logger with in-memory monitoring buffer.
///
/// All API errors, auth failures, and network issues are captured here
/// so they can be inspected during development.
class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  static const int _maxEntries = 500;

  final _entries = Queue<LogEntry>();
  final _listeners = <VoidCallback>[];

  late final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kDebugMode ? Level.trace : Level.warning,
  );

  UnmodifiableListView<LogEntry> get entries =>
      UnmodifiableListView(_entries.toList());

  List<LogEntry> get errors => _entries
      .where((e) => e.level == LogLevel.error || e.level == LogLevel.warning)
      .toList();

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void debug(String tag, String message, {String? details}) =>
      _log(LogLevel.debug, tag, message, details: details);

  void info(String tag, String message, {String? details}) =>
      _log(LogLevel.info, tag, message, details: details);

  void warning(String tag, String message, {String? details}) =>
      _log(LogLevel.warning, tag, message, details: details);

  void error(
    String tag,
    String message, {
    String? details,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(
        LogLevel.error,
        tag,
        message,
        details: details ?? error?.toString(),
        stackTrace: stackTrace,
      );

  void api(String tag, String message, {String? details}) =>
      _log(LogLevel.api, tag, message, details: details);

  void clear() {
    _entries.clear();
    _notify();
  }

  void _log(
    LogLevel level,
    String tag,
    String message, {
    String? details,
    StackTrace? stackTrace,
  }) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      tag: tag,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );

    _entries.addLast(entry);
    while (_entries.length > _maxEntries) {
      _entries.removeFirst();
    }

    if (kDebugMode) {
      final output = entry.toString();
      switch (level) {
        case LogLevel.debug:
          _logger.d(output);
        case LogLevel.info:
        case LogLevel.api:
          _logger.i(output);
        case LogLevel.warning:
          _logger.w(output);
        case LogLevel.error:
          _logger.e(output, stackTrace: stackTrace);
      }
    }

    _notify();
  }

  void _notify() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }
}

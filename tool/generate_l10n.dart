// ignore_for_file: avoid_print
/// Generates lib/l10n/app_localizations*.dart from ARB files.
/// Run: dart run tool/generate_l10n.dart
import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/l10n');
  final arbFiles = l10nDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  final locales = <String, Map<String, dynamic>>{};
  for (final file in arbFiles) {
    final name = file.uri.pathSegments.last;
    final locale = name.replaceFirst('app_', '').replaceFirst('.arb', '');
    final content = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    locales[locale] = Map.fromEntries(
      content.entries.where((e) => !e.key.startsWith('@')),
    );
  }

  final enStrings = locales['en']!;
  final templateKeys = enStrings.keys.where((k) => k != '@@locale').toList();
  final localeCodes = locales.keys.toList()..sort();

  _writeAbstract(templateKeys, localeCodes);
  for (final locale in localeCodes) {
    _writeLocaleClass(locale, templateKeys, locales[locale]!, enStrings);
  }

  print('Generated localizations for: ${localeCodes.join(', ')}');
}

void _writeAbstract(List<String> keys, List<String> localeCodes) {
  final buffer = StringBuffer('''
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

''');

  for (final code in localeCodes) {
    buffer.writeln("import 'app_localizations_$code.dart';");
  }

  buffer.writeln('''
// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
''');

  for (final code in localeCodes) {
    buffer.writeln("    Locale('$code'),");
  }

  buffer.writeln('  ];\n');

  for (final key in keys) {
    if (key == 'dashboardGreeting') {
      buffer.writeln('  String dashboardGreeting(String timeOfDay, String name);');
    } else if (key == 'cropsTracked') {
      buffer.writeln('  String cropsTracked(int count);');
    } else {
      buffer.writeln('  String get $key;');
    }
  }

  buffer.writeln('''
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>[${localeCodes.map((c) => "'$c'").join(', ')}].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
''');

  for (final code in localeCodes) {
    final className = _className(code);
    buffer.writeln("    case '$code': return $className();");
  }

  buffer.writeln('''
  }
  return AppLocalizationsEn();
}
''');

  File('lib/l10n/app_localizations.dart').writeAsStringSync(buffer.toString());
}

void _writeLocaleClass(
  String locale,
  List<String> keys,
  Map<String, dynamic> strings,
  Map<String, dynamic> enStrings,
) {
  final className = _className(locale);
  final buffer = StringBuffer('''
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

class $className extends AppLocalizations {
  $className([String locale = '$locale']) : super(locale);

''');

  for (final key in keys) {
    final value = strings[key] ?? enStrings[key];
    if (value == null) continue;
    final text = value as String;

    if (key == 'dashboardGreeting') {
      buffer.writeln('''
  @override
  String dashboardGreeting(String timeOfDay, String name) {
    return ${_interpolate(text, const {'timeOfDay': 'timeOfDay', 'name': 'name'})};
  }
''');
    } else if (key == 'cropsTracked') {
      buffer.writeln('''
  @override
  String cropsTracked(int count) {
    return ${_interpolate(text, const {'count': 'count.toString()'})};
  }
''');
    } else {
      buffer.writeln('''
  @override
  String get $key => ${_dartString(text)};
''');
    }
  }

  buffer.writeln('}');
  File('lib/l10n/app_localizations_$locale.dart').writeAsStringSync(buffer.toString());
}

String _className(String locale) =>
    'AppLocalizations${locale[0].toUpperCase()}${locale.substring(1)}';

String _dartString(String s) =>
    "'${s.replaceAll('\\', '\\\\').replaceAll("'", "\\'")}'";

String _interpolate(String template, Map<String, String> vars) {
  final parts = <String>[];
  var remaining = template;
  while (remaining.contains('{')) {
    final start = remaining.indexOf('{');
    final end = remaining.indexOf('}', start);
    if (end == -1) break;
    final before = remaining.substring(0, start);
    if (before.isNotEmpty) parts.add(_dartString(before));
    final key = remaining.substring(start + 1, end);
    parts.add(vars[key] ?? key);
    remaining = remaining.substring(end + 1);
  }
  if (remaining.isNotEmpty) parts.add(_dartString(remaining));
  if (parts.isEmpty) return _dartString(template);
  if (parts.length == 1) return parts.first;
  return parts.join(' + ');
}

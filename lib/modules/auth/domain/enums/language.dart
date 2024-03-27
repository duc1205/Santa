import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';

enum Language {
  @JsonValue('unknown')
  unknown,
  @JsonValue('en')
  en,
  @JsonValue('vi')
  vi
}

extension LanguageExt on Language {
  String getValue() {
    switch (this) {
      case Language.unknown:
        return 'unknown';
      case Language.en:
        return 'en';
      case Language.vi:
        return 'vi';
    }
  }

  String getName() {
    switch (this) {
      case Language.unknown:
        return 'Unknown';
      case Language.en:
        return LocaleKeys.auth_english.trans();
      case Language.vi:
        return LocaleKeys.auth_vietnamese.trans();
    }
  }
}

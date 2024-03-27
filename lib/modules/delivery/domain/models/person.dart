import 'package:flutter/foundation.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/modules/delivery/domain/enums/person_source.dart';

@immutable
class Person {
  final String? name;
  final String phoneNumber;
  final PersonSource source;

  const Person({
    this.name,
    required this.phoneNumber,
    required this.source,
  });

  bool match(String query) => phoneNumber.contains(query) || name?.match(query) == true;
}

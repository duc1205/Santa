import 'package:json_annotation/json_annotation.dart';

enum PackageCategory {
  @JsonValue("food")
  food,
  @JsonValue("others")
  others,
}

extension PackageCategoryTypeExt on PackageCategory {
  String toValue() {
    switch (this) {
      case PackageCategory.food:
        return "food";
      case PackageCategory.others:
        return "others";
      default:
        return '';
    }
  }
}

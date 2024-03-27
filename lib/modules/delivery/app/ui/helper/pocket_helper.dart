import 'package:flutter/material.dart';
import 'package:santapocket/modules/cabinet/domain/enums/pocket_size_uuid.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

Color pocketDetailColor(bool isSelected, bool isAvailable) {
  if (isSelected) {
    return AppTheme.yellow1;
  } else if (!isAvailable) {
    return AppTheme.greyText;
  } else {
    return AppTheme.radiantGlowOrange;
  }
}

Color pocketColor(PocketSizeUuid? uuid) {
  switch (uuid) {
    case PocketSizeUuid.small:
      return AppTheme.orange;
    case PocketSizeUuid.medium:
      return AppTheme.red;
    case PocketSizeUuid.large:
      return AppTheme.blackDark;
    default:
      return Colors.transparent;
  }
}

Color sizeThemeColor(bool isSelected, bool isAvailable) {
  if (isSelected) {
    return AppTheme.white;
  } else if (!isAvailable) {
    return AppTheme.grey4;
  } else {
    return AppTheme.black;
  }
}

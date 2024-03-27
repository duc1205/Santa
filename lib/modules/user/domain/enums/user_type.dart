import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';

enum UserType { defaultType, shipper, receiver }

extension UserTypeExt on UserType {
  String getValue() {
    switch (this) {
      case UserType.defaultType:
        return 'unknown';
      case UserType.shipper:
        return 'shipper';
      case UserType.receiver:
        return 'receiver';
    }
  }

  String getName() {
    switch (this) {
      case UserType.defaultType:
        return 'Unknown';
      case UserType.shipper:
        return LocaleKeys.user_shipper.trans();
      case UserType.receiver:
        return LocaleKeys.user_receiver.trans();
    }
  }
}

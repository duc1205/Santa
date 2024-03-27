import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';

enum PaymentMethod { moMo, vnPay, bankTransfer, santaPayroll }

extension PaymentMethodExt on PaymentMethod {
  String toValue() {
    switch (this) {
      case PaymentMethod.moMo:
        return LocaleKeys.payment_momo_wallet.trans();
      case PaymentMethod.vnPay:
        return LocaleKeys.payment_vnpay_wallet.trans();
      case PaymentMethod.bankTransfer:
        return "";
      case PaymentMethod.santaPayroll:
        return LocaleKeys.payment_santa_payroll.trans();
    }
  }
}

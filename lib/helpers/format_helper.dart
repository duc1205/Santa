import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:santapocket/core/constants/constants.dart';

class FormatHelper {
  FormatHelper._();

  static String formatDate(String pattern, DateTime? date, {String? locale}) {
    if (date == null) return "";
    return DateFormat(pattern, locale ?? Platform.localeName).format(date.toLocal());
  }

  static String formatCreatedDate(DateTime? date) {
    if (date == null) return "";
    return formatDate("dd/MM/yyyy, kk:mm", date);
  }

  static String formatPrivatePhoneNumber(String number) {
    String resultPrivateNumber = "";
    if (number.length > 4) {
      String lastThreeNumbers = number.substring(number.length - 3);
      String privatedNumbers = number.substring(0, number.length - 3).replaceAll(RegExp(r"."), "x");
      resultPrivateNumber = privatedNumbers + lastThreeNumbers;
    }
    return resultPrivateNumber;
  }

  static String formatCurrency(
    dynamic amount, {
    String locale = 'vi_VN',
    String unit = 'đ',
  }) =>
      NumberFormat.currency(
        locale: locale,
        symbol: unit,
      ).format(amount ?? 0).removeAllWhitespace;

  static String formatCurrencyV2(
    dynamic amount, {
    String locale = 'vi_VN',
    String unit = 'Xu',
  }) =>
      NumberFormat.currency(
        locale: locale,
        symbol: unit,
      ).format(amount ?? 0);

  static String formatId(int? id) {
    if (id == null) return "";
    return "#$id";
  }

  static String formatDistance(double? distance) {
    if (distance == null) return "-\nkm";
    return "${distance.toStringAsFixed(2)} km";
  }

  static String formatPhone(String countryCode, String phone) {
    if (phone.startsWith("0")) {
      return countryCode + phone.substring(1);
    }
    return countryCode + phone;
  }

  static String reverseFormatPhone(String phone) {
    if (phone.startsWith("84")) {
      return "0${phone.substring(2)}";
    }
    return phone;
  }

  static int roundSantaXu(int value) {
    return (value / Constants.santaXuConversionRate).round();
  }

  static String getPlatformLocaleName() {
    return Platform.localeName.substring(0, 2);
  }
}

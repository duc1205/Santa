extension DateTimeExt on DateTime {
  String toJson() => toIso8601String() + getTimeZone();

  String getTimeZone() {
    final sign = timeZoneOffset.isNegative ? "-" : "+";
    final hours = timeZoneOffset.inHours.toString().padLeft(2, "0");
    final minutes = (timeZoneOffset.inMinutes - timeZoneOffset.inHours * 60).toString().padLeft(2, "0");
    return "$sign$hours:$minutes";
  }
}

import 'package:santapocket/storage/spref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPref {
  static final SPref instance = SPref._internal();

  SPref._internal();

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefKey.keyAccessToken);
  }

  Future setAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefKey.keyAccessToken, token);
  }

  Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPrefKey.keyRefreshToken);
  }

  Future saveRefreshToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPrefKey.keyRefreshToken, token);
  }

  Future<int?> getExpiresAt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SPrefKey.keyExpiresAt);
  }

  Future setExpiresAt(int expiresAt) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SPrefKey.keyExpiresAt, expiresAt);
  }

  Future setLocale(String locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("locale", locale);
  }

  Future<String?> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("locale");
  }

  Future<int?> getPermissionLastAsk() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("permissionNotificationLastAsk");
  }

  Future setPermissionLastAsk(int dateTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("permissionNotificationLastAsk", dateTime);
  }

  Future<int?> getPermissionAskTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("permissionNotificationAskTime");
  }

  Future setPermissionAskTime(int time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("permissionNotificationAskTime", time);
  }

  Future<bool> getDeveloperModeEnable() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SPrefKey.keyDeveloperModeEnable) ?? false;
  }

  Future setDeveloperModeEnable(bool isEnable) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SPrefKey.keyDeveloperModeEnable, isEnable);
  }

  Future<int?> getCountMostReadSystemNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SPrefKey.keyCountMostReadSystemNotification);
  }

  Future setCountMostReadSystemNotification(int count) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SPrefKey.keyCountMostReadSystemNotification, count);
  }

  dynamic deleteAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final strLocale = prefs.getString('locale');
    await prefs.clear();
    if (strLocale != null) {
      await prefs.setString('locale', strLocale);
    }
  }
}

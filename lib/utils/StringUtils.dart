import 'package:flutter_shop/http/Api.dart';
import 'package:package_info/package_info.dart';

/**
 * 判断字符换是否为空
 * @author longlyboyhe
 * @date 2018/12/26
 */
class StringUtils {
  static bool isEmpty(String string) {
    if (null == string) {
      return true;
    } else {
      return string.isEmpty;
    }
  }

  ///验证手机号
  static bool verifyPhone(String phone) {
    RegExp regExp = RegExp("^1[3|4|5|7|8][0-9]\\d{8}\$");
    return regExp.hasMatch(phone);
  }

  static String getImageUrl(String url) {
    if (url == null) {
      return "";
    } else if (url.contains('http')) {
      return url;
    } else {
      return Api.BASE_IMG + url;
    }
  }

  static Future<String> getVersion() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static double str2Double(String str, {double defaultDouble}) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultDouble != null ? defaultDouble : 0;
    }
  }
}
